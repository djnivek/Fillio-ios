//
//  User.swift
//  Fillio
//
//  Created by Kévin MACHADO on 09/03/2015.
//  Copyright (c) 2015 Kévin MACHADO. All rights reserved.
//

import Foundation

class FIOApiObject: Sendable {
    
    var id: String?
    var createdAt: NSDate?
    
    func save() {
        var action = FIOApiAction(module: "api", controller: "dataobject", action: "set", library: "fillio")
        //action["test"] = "coucou"
        action.run()
    }
    
    override func __toSendFormat() -> NSDictionary {
        let dict = [id!: "_id", createdAt!.description: "_createdAt"]
        return dict
    }
}