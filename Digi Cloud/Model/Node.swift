//
//  Node.swift
//  Digi Cloud
//
//  Created by Mihai Cristescu on 19/09/16.
//  Copyright © 2016 Mihai Cristescu. All rights reserved.
//

import Foundation

struct Node {

    // MARK: - Properties

    var name: String
    let type: String
    let modified: TimeInterval
    let size: Int64
    let contentType: String
    let hash: String?
    var mount: Mount?
    let mountPath: String?
    var link: DownloadLink?
    var receiver: UploadLink?
    var bookmark: Bookmark?
}

extension Node {
    init?(JSON: Any?) {
        guard let JSON = JSON as? [String: Any],
            let name = JSON["name"] as? String,
            let type = JSON["type"] as? String,
            let modified = JSON["modified"] as? TimeInterval,
            let size = JSON["size"] as? Int64,
            let contentType = JSON["contentType"] as? String
            else {
                print("Couldnt parse JSON")
                return nil
        }

        self.name = name
        self.type = type
        self.modified = modified
        self.size = size
        self.contentType = contentType
        self.hash = JSON["hash"] as? String
        self.mount = Mount(JSON: JSON["mount"])
        self.mountPath = JSON["mountPath"] as? String
        self.link = DownloadLink(JSON: JSON["link"])
        self.receiver = UploadLink(JSON: JSON["receiver"])
        self.bookmark = Bookmark(JSON: JSON["bookmark"])
    }
}

extension Node {

    // Extension of the node name (otherwise "")
    var ext: String {
        return (name as NSString).pathExtension
    }

    // Location in given Mount
    func location(in parentLocation: Location) -> Location {

        var path = parentLocation.path + name

        if type == "dir" {
            path += "/"
        }

        return Location(mount: parentLocation.mount, path: path )
    }
}

extension Node: Hashable {
    var hashValue: Int {
        return self.hash?.hashValue ?? 0
    }
}

extension Node: Equatable {
    static func == (lhs: Node, rhs: Node) -> Bool {
        return lhs.name == rhs.name
    }
}
