//
//  DIGIConvenience.swift
//  Digi Cloud
//
//  Created by Mihai Cristescu on 26/09/16.
//  Copyright © 2016 Mihai Cristescu. All rights reserved.
//

import Foundation

extension DigiClient {
    
    func authenticate(email: String, password: String, completionHandlerforAuth: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        let method = Methods.Token
        let headers = DefaultHeaders.Headers
        let jsonBody = ["password":password, "email": email]
        
        _ = networkTask(type: "POST", method: method, headers: headers, json: jsonBody, parameters: nil) { (result, error) in
            if let error = error {
                print(error)
            } else {
                print(result)
            }
        }
        
    }
}
