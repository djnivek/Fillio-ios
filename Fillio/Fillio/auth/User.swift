//
//  FIOAuthUser.swift
//  Fillio
//
//  Created by Kévin MACHADO on 09/03/2015.
//  Copyright (c) 2015 Kévin MACHADO. All rights reserved.
//

import Foundation

class FIOAuthUser: FIOApiObject {
    
    var name: String?
    
    class var sharedInstance: FIOAuthUser {
        struct Singleton {
            static let instance = FIOAuthUser()
        }
        return Singleton.instance
    }
    
    func currentUser() {
        
    }
    
    func logIn(username: String, password: String, completion: ((Bool, NSError?) -> ())?) {
        FIONetworkHTTPClient.sharedInstance.postRequest("/1/user/login", body: "", success: {
            if let callback = completion {
                callback(true, nil)
            }
            }, failure: { (error: NSError) in
                if let callback = completion {
                    callback(false, error)
                }
        })
    }
}