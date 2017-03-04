//
//  ShareInDigiTableViewController.swift
//  Digi Cloud
//
//  Created by Mihai Cristescu on 02/03/2017.
//  Copyright © 2017 Mihai Cristescu. All rights reserved.
//

import UIKit

final class SharePermissionsTableViewController: UIViewController {

    // MARK: - Properties

    var onFinish: (() -> Void)
    let node: Node

    // MARK: - Initializers and Deinitializers

    init(node: Node, onFinish: @escaping() -> Void) {
        self.node = node
        self.onFinish = onFinish
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit { DEINITLog(self) }

    // MARK: - Overridden Methods and Properties

    override func viewDidLoad() {
        setupViews()
    }

    // MARK: - Helper Functions

    private func setupViews() {
        view.backgroundColor = .red
    }
}