//
//  ActionsViewController.swift
//  Digi Cloud
//
//  Created by Mihai Cristescu on 20/10/16.
//  Copyright © 2016 Mihai Cristescu. All rights reserved.
//

import UIKit

class ActionViewController: UITableViewController {

    var element: File!

    weak var delegate: ActionViewControllerDelegate?

    var contextMenuFileActions: [ActionCell] = []
    var contextMenuFolderActions: [ActionCell] = []

    override init(style: UITableViewStyle) {
        super.init(style: style)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        self.preferredContentSize.width = 400
        self.preferredContentSize.height = tableView.contentSize.height - 1
        super.viewWillAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    fileprivate func setupViews() {
        let folderActions = [ActionCell(title: NSLocalizedString("Share",                   comment: "Selection Title"), tag: 0),
                             ActionCell(title: NSLocalizedString("Rename",                  comment: "Selection Title"), tag: 2),
                             ActionCell(title: NSLocalizedString("Copy",                    comment: "Selection Title"), tag: 3),
                             ActionCell(title: NSLocalizedString("Move",                    comment: "Selection Title"), tag: 4),
                             ActionCell(title: NSLocalizedString("Folder information",      comment: "Selection Title"), tag: 6)]

        contextMenuFolderActions.append(contentsOf: folderActions)

        let fileActions = [ActionCell(title: NSLocalizedString("Share",                     comment: "Selection Title"), tag: 0),
                           ActionCell(title: NSLocalizedString("Make available offline",    comment: "Selection Title"), tag: 1),
                           ActionCell(title: NSLocalizedString("Rename",                    comment: "Selection Title"), tag: 2),
                           ActionCell(title: NSLocalizedString("Copy",                      comment: "Selection Title"), tag: 3),
                           ActionCell(title: NSLocalizedString("Move",                      comment: "Selection Title"), tag: 4),
                           ActionCell(title: NSLocalizedString("Delete",                    comment: "Selection Title"), tag: 5)]

        contextMenuFileActions.append(contentsOf: fileActions)

        let headerView: UIView = {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 50))
            view.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
            return view
        }()

        let iconImage: UIImageView = {
            let imageName = element.type == "dir" ? "FolderIcon" : "FileIcon"
            let imageView = UIImageView(image: UIImage(named: imageName))
            imageView.contentMode = .scaleAspectFit
            return imageView
        }()

        let elementName: UILabel = {
            let label = UILabel()
            label.text = element.name
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

        let offset = element.type == "dir" ? 22 : 20
        headerView.addConstraints(with: "H:|-\(offset)-[v0(26)]-10-[v1]-10-|", views: iconImage, elementName)
        headerView.addConstraints(with: "V:[v0(26)]", views: iconImage)
        iconImage.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        elementName.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true

        headerView.addSubview(separator)
        headerView.addConstraints(with: "H:|[v0]|", views: separator)
        headerView.addConstraints(with: "V:[v0(\(1/UIScreen.main.scale))]|", views: separator)

        tableView.isScrollEnabled = false
        tableView.rowHeight = 50
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return element.type == "dir" ? contextMenuFolderActions.count :contextMenuFileActions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return element.type == "dir" ? contextMenuFolderActions[indexPath.row] : contextMenuFileActions[indexPath.row]
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let tag = tableView.cellForRow(at: indexPath)?.tag {
            self.delegate?.didSelectOption(tag: tag)
        }
    }

    #if DEBUG
    deinit { print("ChooseElementActionViewController deinit") }
    #endif
}
