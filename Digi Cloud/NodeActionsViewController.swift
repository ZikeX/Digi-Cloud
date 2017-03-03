//
//  NodeActionsViewController.swift
//  Digi Cloud
//
//  Created by Mihai Cristescu on 20/10/16.
//  Copyright © 2016 Mihai Cristescu. All rights reserved.
//

import UIKit

final class NodeActionsViewController: UITableViewController {

    // MARK: - Properties

    weak var delegate: NodeActionsViewControllerDelegate?

    private var node: Node

    private var contextMenuFileActions: [ActionCell] = []

    private var contextMenuFolderActions: [ActionCell] = []

    // MARK: - Initializers and Deinitializers

    init(node: Node) {
        self.node = node
        super.init(style: .plain)
        INITLog(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit { DEINITLog(self) }

    // MARK: - Overridden Methods and Properties

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.preferredContentSize.width = 250
        self.preferredContentSize.height = tableView.contentSize.height - 1
        super.viewWillAppear(animated)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return node.type == "dir" ? contextMenuFolderActions.count : contextMenuFileActions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return node.type == "dir" ? contextMenuFolderActions[indexPath.row] : contextMenuFileActions[indexPath.row]
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let tag = tableView.cellForRow(at: indexPath)?.tag,
            let action = ActionType(rawValue: tag) {
            self.delegate?.didSelectOption(action: action)
        }
    }

    // MARK: - Helper Functions

    private func setupViews() {
        let folderActions = [ActionCell(title: NSLocalizedString("Share", comment: ""), action: .share),
                             ActionCell(title: NSLocalizedString("Bookmark", comment: ""), action: .bookmark),
                             ActionCell(title: NSLocalizedString("Rename", comment: ""), action: .rename),
                             ActionCell(title: NSLocalizedString("Copy", comment: ""), action: .copy),
                             ActionCell(title: NSLocalizedString("Move", comment: ""), action: .move),
                             ActionCell(title: NSLocalizedString("Directory information", comment: ""), action: .folderInfo)]

        contextMenuFolderActions.append(contentsOf: folderActions)

        let fileActions = [ActionCell(title: NSLocalizedString("Share", comment: ""), action: .share),
                           ActionCell(title: NSLocalizedString("Make available offline", comment: ""), action: .makeOffline),
                           ActionCell(title: NSLocalizedString("Rename", comment: ""), action: .rename),
                           ActionCell(title: NSLocalizedString("Copy", comment: ""), action: .copy),
                           ActionCell(title: NSLocalizedString("Move", comment: ""), action: .move),
                           ActionCell(title: NSLocalizedString("Delete", comment: ""), action: .delete)]

        contextMenuFileActions.append(contentsOf: fileActions)

        let headerView: UIView = {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 50))
            view.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
            return view
        }()

        let iconImage: UIImageView = {
            let imageName = node.type == "dir" ? "FolderIcon" : "FileIcon"
            let imageView = UIImageView(image: UIImage(named: imageName))
            imageView.contentMode = .scaleAspectFit
            return imageView
        }()

        let elementName: UILabel = {
            let label = UILabel()
            label.text = node.name
            label.font = UIFont.systemFont(ofSize: 14)
            return label
        }()

        let separator: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor(white: 0.8, alpha: 1)
            return view
        }()

        headerView.addSubview(iconImage)
        headerView.addSubview(elementName)

        let offset = node.type == "dir" ? 22 : 20
        headerView.addConstraints(with: "H:|-\(offset)-[v0(26)]-10-[v1]-10-|", views: iconImage, elementName)
        headerView.addConstraints(with: "V:[v0(26)]", views: iconImage)
        iconImage.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        elementName.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true

        headerView.addSubview(separator)
        headerView.addConstraints(with: "H:|[v0]|", views: separator)
        headerView.addConstraints(with: "V:[v0(\(1 / UIScreen.main.scale))]|", views: separator)

        tableView.isScrollEnabled = false
        tableView.rowHeight = 50
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
    }
}
