//
//  Mount.swift
//  Digi Cloud
//
//  Created by Mihai Cristescu on 19/09/16.
//  Copyright © 2016 Mihai Cristescu. All rights reserved.
//

import Foundation

struct Mount {
    let id: String
    let name: String

    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}

extension Mount: JSONDecodable {
    init?(JSON: Any) {
        
        guard let JSON = JSON as? [String: Any],
            let name = JSON["name"] as? String,
            let id = JSON["id"] as? String
        else {
                print("Could not parce keys")
                return nil
        }

        self.name = name
        self.id = id
    }
}
