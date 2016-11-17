//
//  MoveTableViewController.swift
//  Digi Cloud
//
//  Created by Mihai Cristescu on 15/11/16.
//  Copyright © 2016 Mihai Cristescu. All rights reserved.
//

import UIKit

final class CopyOrMoveViewController: UITableViewController {

    // MARK: - Properties

    var onFinish: ((Void) -> Void)?
    private let FileCellID = "FileCell"
    private let FolderCellID = "DirectoryCell"
    private var element: Element
    private var action: ActionType
    private var content: [Element] = []
    private let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .none
        f.locale = Locale.current
        f.dateFormat = "dd.MM.YYY・HH:mm"
        return f
    }()
    private let byteFormatter: ByteCountFormatter = {
        let f = ByteCountFormatter()
        f.countStyle = .binary
        f.allowsNonnumericFormatting = false
        return f
    }()

    // MARK: - Initializers and Deinitializers

    init(element: Element, action: ActionType) {
        self.element = element
        self.action = action
        super.init(style: .grouped)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    #if DEBUG
    deinit {
        print("[DEINIT]: " + String(describing: type(of: self)))
    }
    #endif


    // MARK: - Overridden Methods and Properties

    override func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = true
        tableView.contentInset = UIEdgeInsets(top: -35, left: 0, bottom: 100, right: 0)
        tableView.register(FileCell.self, forCellReuseIdentifier: FileCellID)
        tableView.register(DirectoryCell.self, forCellReuseIdentifier: FolderCellID)
        tableView.rowHeight = AppSettings.tableViewRowHeight
        setupViews()

        getFolderContent()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return content.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let data = content[indexPath.row]

        if data.type == "dir" {
            let cell = tableView.dequeueReusableCell(withIdentifier: FolderCellID, for: indexPath) as! DirectoryCell
            cell.folderNameLabel.text = data.name
            return cell

        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: FileCellID, for: indexPath) as! FileCell

            let modifiedDate = dateFormatter.string(from: Date(timeIntervalSince1970: data.modified / 1000))
            cell.fileNameLabel.text = data.name

            let fileSizeString = byteFormatter.string(fromByteCount: data.size) + "・" + modifiedDate
            cell.fileSizeLabel.text = fileSizeString

            return cell
        }
    }

    // MARK: - Helper Functions

    private func getFolderContent() {
        DigiClient.shared.getLocationContent(mount: DigiClient.shared.destinationMount, queryPath: DigiClient.shared.destinationPath.last!) {
            (content, error) in
            guard error == nil else {
                print("Error: \(error?.localizedDescription)")
                return
            }
            self.content = content ?? []
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    private func setupViews() {
        view.backgroundColor = UIColor.white

        self.title = NSLocalizedString("Select destination", comment: "Window title")

        var buttonTitle: String

        switch action {
        case .copy:
            buttonTitle = NSLocalizedString("Copy here", comment: "Button Title")
        case .move:
            buttonTitle = NSLocalizedString("Move here", comment: "Button Title")
        default:
            return
        }

        let rightButton = UIBarButtonItem(title: NSLocalizedString("Cancel", comment: "Button Title"), style: .plain, target: self, action: #selector(handleDone))

        navigationItem.setRightBarButton(rightButton, animated: false)
        navigationController?.isToolbarHidden = false

        let copyMoveButton = UIBarButtonItem(title: buttonTitle, style: .plain, target: self, action: #selector(handleCopyOrMove))
        copyMoveButton.isEnabled = !DigiClient.shared.arePathsTheSame

        let toolBarItems = [UIBarButtonItem(title: NSLocalizedString("New Folder", comment: "Button Title"), style: .plain, target: self, action: #selector(handleNewFolder)),
                            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                            copyMoveButton]

        self.setToolbarItems(toolBarItems, animated: false)
    }

    @objc private func handleDone() {

        self.onFinish?()
    }

    @objc private func handleNewFolder() {
        let controller = CreateFolderViewController()
        controller.onFinish = { [unowned self](folderName) in
            DispatchQueue.main.async {
                _ = self.navigationController?.popViewController(animated: true)
                if folderName != nil {
                    // TODO: This is the new folder, navigate inside it
                } else {
                    return // Cancel
                }
            }
        }

        navigationController?.pushViewController(controller, animated: true)
    }

    @objc private func handleCopyOrMove() {

        guard let currentMount = DigiClient.shared.currentMount else { return }
        guard let currentPath = DigiClient.shared.currentPath.last else { return }

        let elementSourcePath = currentPath + element.name
        let destinationMount = currentMount // TODO: Update with destination mount
        let elementDestinationPath = currentPath + element.name  // TODO: Update with selected destination path (without element name inside)

        if true { return }

        DigiClient.shared.copyOrMoveElement(action:             action,
                                            path:               elementSourcePath,
                                            toMountId:          destinationMount,
                                            toPath:             elementDestinationPath,
                                            completionHandler:  {(statusCode, error) in return })
    }
}
