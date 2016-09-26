//
//  Constants.swift
//  Digi Cloud
//
//  Created by Mihai Cristescu on 16/09/16.
//  Copyright © 2016 Mihai Cristescu. All rights reserved.
//

import Foundation

struct API {
    static let Scheme       = "https"
    static let Host         = "storage.rcs-rds.ro"
}


struct DefaultHeaders {
    static let Headers = ["Content-Type":"application/json",
                          "Accept":"application/json"]
}

struct HeadersKeys {
    static let Email        = "X-Koofr-Email"
    static let Password     = "X-Koofr-Password"
}

struct HeaderResponses {
    static let Token        = "X-koofr-token"
}

struct ParametersKeys {
    static let Path         = "path"
}

struct Methods {
    static let Token        = "/token"
    static let User         = "/api/v2/user"
    static let Password     = "/api/v2/user/password"
    static let Bookmarks    = "/api/v2/user/bookmarks"
    static let Mounts       = "/api/v2/mounts"
    static let Files        = "/api/v2/mount/{id}/files/get"
}

struct Segues {
    static let toFiles      = "toFiles"
    static let toContent    = "toContent"
}
