//
//  User.swift
//  Fillio
//
//  Created by Kévin MACHADO on 09/03/2015.
//  Copyright (c) 2015 Kévin MACHADO. All rights reserved.
//

import Foundation

class FIOApiObject: Updatable {
    
    var id: String?
    var createdAt: NSDate?
    
    /*override init() {
        super.init()
    }*/
    
    func getAll() {
        
    }
    
    func getOne(id: String) {
        
    }
    
    /// The method to select some content
    ///
    /// :param: id The id
    /// :param: conditions The id
    /// :param: optionalFields The fields
    private func _select(id: String?, optionalFields: [String]?) {
        if let theId = id {
            let cond: [String: String] = ["id" : theId]
            self._select(cond, optionalFields: optionalFields)
        }
    }
    
    private func _select(conditions: [String: String]?, optionalFields: [String]?) {
        
    }
    
    private func _save() {
        var action = FIOApiAction(module: "api", controller: "dataobject", action: "set", library: "fillio")
        //action["test"] = "coucou"
        action.run()
    }
    
    override func __toSendFormat() -> NSDictionary {
        let dict = [id!: "_id", createdAt!.description: "_createdAt"]
        return dict
    }
}

extension FIOApiObject {
    
}