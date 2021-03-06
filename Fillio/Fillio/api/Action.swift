//
//  Action.swift
//  Fillio
//
//  Created by Kévin MACHADO on 09/03/2015.
//  Copyright (c) 2015 Kévin MACHADO. All rights reserved.
//

import Foundation

class FIOApiAction {
    
    let action: String
    let controller: String
    let module: String
    var library: String?
    
    var output: NSMutableDictionary
    
    var isLibrary: Bool {
        if let lib = library {
            return !lib.isEmpty
        }
        return false
    }
    
    init(module: String, controller: String, action: String, library: String?) {
        self.action = action
        self.controller = controller
        self.module = module
        self.library = library
        self.output = NSMutableDictionary()
    }
    
    init(module: String, controller: String, action: String) {
        self.action = action
        self.controller = controller
        self.module = module
        self.output = NSMutableDictionary()
    }
    
    func run() {
        /*let request = HTTPRequest(method: .GET)
        request.url = "user/dev/center"
        request.method
        FIONetworkClient.sharedClient[request] = {
            
        }*/
    }
}