//
//  ContentViewController.swift
//  Digi Cloud
//
//  Created by Mihai Cristescu on 23/09/16.
//  Copyright © 2016 Mihai Cristescu. All rights reserved.
//

import UIKit
import WebKit

class ContentViewController: UIViewController {

    // MARK: - Properties

    let location: Location
    var fileUrl: URL!
    var session: URLSession?

    private lazy var webView: WKWebView = {
        let view = WKWebView()
        view.navigationDelegate = self
        return view
    }()

    fileprivate let progressView: UIProgressView = {
        let view = UIProgressView(progressViewStyle: .default)
        view.progress = 0
        return view
    }()

    // MARK: - Initializers and Deinitializers

    init(location: Location) {
        self.location = location
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    #if DEBUG_CONTROLLERS
    deinit {
        print("[DEINIT]: " + String(describing: type(of: self)))
    }
    #endif

    // MARK: - Overridden Methods and Properties

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                                            target: self,
                                                            action: #selector(handleAction))
        navigationItem.rightBarButtonItem?.isEnabled = false

    }

    override func viewWillAppear(_ animated: Bool) {

        // get the file name from current path
        let fileName: String = self.location.path.components(separatedBy: "/").last!

        // create destination file url
        self.fileUrl = FileManager.filesCacheDirectoryURL.appendingPathComponent(fileName)

        // TODO: - If the file has changed in the cloud, it should be redownloaded again.
        // Check if the hash of the file is the same with the hash saved locally 

        if !FileManager.default.fileExists(atPath: fileUrl.path) {

            // Show progress view
            progressView.isHidden = false

            // Start downloading File
            session = DigiClient.shared.startDownloadFile(at: location, delegate: self)

        } else {
            loadFileContent()
        }

    }

    override func viewWillDisappear(_ animated: Bool) {

        // Close session and delegate
        session?.invalidateAndCancel()
    }

    // MARK: - Helper Functions

    func handleAction() {
        let controller = UIActivityViewController(activityItems: [fileUrl], applicationActivities: nil)
        controller.excludedActivityTypes = nil
        controller.modalPresentationStyle = .popover
        controller.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(controller, animated: true, completion: nil)
    }

    private func setupViews() {
        view.addSubview(webView)
        view.addSubview(progressView)
        view.addConstraints(with: "H:|[v0]|", views: webView)
        view.addConstraints(with: "V:|[v0]|", views: webView)
        view.addConstraints(with: "H:|[v0]|", views: progressView)
        view.addConstraints(with: "V:|-64-[v0(2)]", views: progressView)
    }

    fileprivate func loadFileContent() {

        // load file in the view
        self.webView.loadFileURL(self.fileUrl, allowingReadAccessTo: self.fileUrl)

        // enable right bar button for exporting
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }
}

extension ContentViewController: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {

        // avoid memory leak (self cannot be deinitialize because it is a delegate of the session)
        session.invalidateAndCancel()

        // get the file name from current path
        let fileName: String = self.location.path.components(separatedBy: "/").last!

        // create destination file url
        self.fileUrl = FileManager.filesCacheDirectoryURL.appendingPathComponent(fileName)

        // get the downloaded file from temp folder
        do {
            try FileManager.default.moveItem(at: location, to: self.fileUrl)

            DispatchQueue.main.async {
                self.loadFileContent()
            }

        } catch let error {
            print("Could not move file to disk: \(error.localizedDescription)")
        }
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {

        // calculate the progress value
        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)

        // Update the progress on screen
        DispatchQueue.main.async {
            self.progressView.setProgress(progress, animated: true)
        }
    }
}

extension ContentViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

        UIView.animate(withDuration: 0.5, animations: {
            self.progressView.alpha = 0
        })
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        // TODO: Show UIView for Export recommendation
        print(error.localizedDescription)
        self.progressView.alpha = 0
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }
}
