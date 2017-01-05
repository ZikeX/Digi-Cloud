//
//  IntroductionViewController.swift
//  Digi Cloud
//
//  Created by Mihai Cristescu on 05/01/17.
//  Copyright © 2017 Mihai Cristescu. All rights reserved.
//

import UIKit

class IntroductionViewController: UIViewController {

    // MARK: - Properties

    var onFinish: (() -> Void)?

    // MARK: - Initializers and Deinitializers

    // MARK: - Overridden Methods and Properties

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .magenta
        setupViews()

        self.setDefaultAppSettings()
    }

    override func viewDidAppear(_ animated: Bool) {

        // Exit the Intro screen after 2 seconds (temporary functionality)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.onFinish?()
        }
    }

    // MARK: - Helper Functions

    fileprivate func setupViews() {
        let label: UILabel = {
            let l = UILabel()
            l.text = "Introduction"
            l.textColor = .white
            l.font = UIFont(name: "Helvetica", size: 48)
            l.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
            l.sizeToFit()
            l.center = view.center
            return l
        }()

        view.addSubview(label)
    }

    fileprivate func setDefaultAppSettings() {

        // Set that App has been started first time
        AppSettings.wasAppStarted = true

        // Set sorting defaults
        AppSettings.showFoldersFirst = true
        AppSettings.sortMethod = .byName
        AppSettings.sortAscending = true
    }

}
