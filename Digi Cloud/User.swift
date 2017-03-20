//
//  User.swift
//  Digi Cloud
//
//  Created by Mihai Cristescu on 04/03/2017.
//  Copyright © 2017 Mihai Cristescu. All rights reserved.
//

struct User {
    let id: String
    let firstName: String
    let lastName: String
    var email: String
    var permissions: Permissions
}

extension User {

    init?(JSON: Any?) {
        if JSON == nil { return nil }
        guard let JSON = JSON as? [String: Any],
            let id = JSON["id"] as? String,
            let name = JSON["name"] as? String,
            let email = JSON["email"] as? String
            else {
                print("Error at parsing of User JSON.")
                return nil
        }

        if let permissions = Permissions(JSON: JSON["permissions"]) {
            self.permissions = permissions
        } else {
            return nil
        }

        self.id = id
        self.firstName = name
        self.lastName = name
        self.email = email
    }

    init?(infoJSON: Any?) {
        if infoJSON == nil { return nil }
        guard let JSON = infoJSON as? [String: Any],
            let id = JSON["id"] as? String,
            let firstName = JSON["firstName"] as? String,
            let lastName = JSON["lastName"] as? String,
            let email = JSON["email"] as? String
            else {
                print("Error at parsing of User infoJSON.")
                return nil
        }

        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.permissions = Permissions()
    }
}

extension User: Equatable {
    static func ==(lhs: User, rhs: User) -> Bool {
        return lhs.email == rhs.email
    }

}
