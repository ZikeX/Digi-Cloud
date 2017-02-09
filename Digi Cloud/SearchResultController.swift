//
//  SearchResultController.swift
//  Digi Cloud
//
//  Created by Mihai Cristescu on 13/12/16.
//  Copyright © 2016 Mihai Cristescu. All rights reserved.
//

import UIKit

class SearchResultController: UITableViewController {

    // MARK: - Properties
    var filteredContent = [Node]()
    weak var searchController: UISearchController?
    private let currentLocation: Location
    private var fileCellID: String = ""
    private let byteFormatter: ByteCountFormatter = {
        let f = ByteCountFormatter()
        f.countStyle = .binary
        f.allowsNonnumericFormatting = false
        return f
    }()
    private var searchInCurrentMount: Bool = true
    private var currentColor = UIColor(hue: 0.17, saturation: 0.55, brightness: 0.75, alpha: 1.0)
    private var mountNames: [String: UIColor] = [:]

    // MARK: - Initializers and Deinitializers
    init(currentLocation: Location) {
        self.currentLocation = currentLocation
        super.init(style: .plain)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Overridden Methods and Properties

    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = .bottom
        setupTableView()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredContent.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: fileCellID, for: indexPath) as? SearchCell else {
            return UITableViewCell()
        }
        let node = filteredContent[indexPath.row]

        if node.type == "dir" {
            cell.nodeIcon.image = UIImage(named: "FolderIcon")
            cell.nodeNameLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 16)
        } else {
            cell.nodeIcon.image = UIImage(named: "FileIcon")
            cell.nodeNameLabel.font = UIFont(name: "HelveticaNeue", size: 16)
        }

        cell.nodeMountLabel.text = node.location.mount.name

        if mountNames[node.location.mount.name] == nil {
            mountNames[node.location.mount.name] = currentColor
            var hue: CGFloat = 0
            var saturation: CGFloat = 0
            var brightness: CGFloat = 0
            var alpha: CGFloat = 0
            _ = currentColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
            currentColor = UIColor.init(hue: hue + 0.15, saturation: saturation, brightness: brightness, alpha: alpha)
        }
        cell.mountBackgroundColor = mountNames[node.location.mount.name]
        cell.nodePathLabel.text = node.location.path

        let name = node.name
        let attributedText = NSMutableAttributedString(string: name)

        guard let searchedText = searchController?.searchBar.text else {
            return cell
        }

        let nsString = NSString(string: name.lowercased())
        let nsRange = nsString.range(of: searchedText.lowercased())

        let backGrdColor = UIColor.init(red: 1.0, green: 0.88, blue: 0.88, alpha: 1.0)
        attributedText.addAttributes([NSBackgroundColorAttributeName: backGrdColor], range: nsRange)
        cell.nodeNameLabel.attributedText = attributedText

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        searchController?.searchBar.resignFirstResponder()
        let node = filteredContent[indexPath.row]
        let controller = node.type == "dir"
            ? ListingViewController(action: .noAction, for: node.location)
            : ContentViewController(location: node.location)
        controller.title = node.name
        let nav = self.parent?.presentingViewController?.navigationController as? MainNavigationController
        nav?.pushViewController(controller, animated: true)
    }

    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.searchController?.searchBar.resignFirstResponder()
    }

    // MARK: - Helper Functions

    private func setupTableView() {
        self.fileCellID = "SearchFileCell"
        tableView.register(SearchCell.self, forCellReuseIdentifier: fileCellID)
        tableView.cellLayoutMarginsFollowReadableWidth = false
        tableView.rowHeight = AppSettings.tableViewRowHeight
        tableView.separatorStyle = .none
    }

    fileprivate func filterContentForSearchText(searchText: String, scope: Int) {

        let count = searchText.characters.count
        if count < 3 {
            if count == 0 {
                self.filteredContent.removeAll()
                self.tableView.reloadData()
            }
            return
        }
        searchInCurrentMount = scope == 0 ? true  : false

        let searchLocation: Location? = scope == 0 ? self.currentLocation : nil

        DigiClient.shared.searchNodes(query: searchText, at: searchLocation) { nodes, error in
            guard error == nil else {
                print("Error: \(error!.localizedDescription)")
                return
            }
            if let nodes = nodes {
                self.filteredContent = nodes
                self.filteredContent.sort {
                    if $0.type == $1.type {
                        return $0.score > $1.score
                    } else {
                        return $0.type < $1.type
                    }
                }
                self.tableView.reloadData()
            }
        }
    }
}

extension SearchResultController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        self.searchController = searchController
        self.view.isHidden = false
        filterContentForSearchText(searchText: searchController.searchBar.text!, scope: searchController.searchBar.selectedScopeButtonIndex)
    }
}

extension SearchResultController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchText: searchBar.text!, scope: selectedScope)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
