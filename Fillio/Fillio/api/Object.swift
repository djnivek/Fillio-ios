//
//  User.swift
//  Fillio
//
//  Created by Kévin MACHADO on 09/03/2015.
//  Copyright (c) 2015 Kévin MACHADO. All rights reserved.
//

import Foundation

/// This class is provided to easily transfert data from iOS to Fillio Server.
///
/// You can :
///
/// - Save an object in your server
/// - Load one from your server
public class FIOApiObject {
    
    /// The unique identifier for the object
    private var _id: String?
    
    /// The creation date
    private var _createdAt: NSDate?
    
    /// This flag indicates you the object was gotten from the server
    private var _flagObjectFromServer: Boolean?
    
    private var _innerProperties: [String: Any]? {
        // loop that looks for properties
        let allProps = reflect(self)
        var innerProps = [String: Any]()
        for var i = 0; i < allProps.count; i++ {
            // put values into array of filtered values
            if allProps[i].0 != "super" {
                innerProps[allProps[i].0] = allProps[i].1.value
            }
            if let obj = self as? FIOApiTransferable {
                if let toIgnore = obj.ignoreFields() {
                    if !contains(toIgnore, allProps[i].0) {
                        innerProps[allProps[i].0] = allProps[i].1.value
                    }
                }
            }
        }
        return innerProps
    }
    
    /// The name of the class into your Fillio Project
    ///
    /// Example : Model_User
    private var _fillioModelName: String {
        if let obj = self as? FIOApiTransferable {
            return obj.modelName()
        }
        fatalError("Model name should be defined by Transferable Protocol")
    }
    
    public init() {
        
    }
    
    func getAll() {
        
    }
    
    func getOne(id: String) {
        
    }
    
    /// The method to select some content
    ///
    /// :param: id The id
    /// :param: conditions The id
    /// :param: optionalFields The fields that will be dislayed in the request
    private func _select(id: String?) {
        if let theId = id {
            let cond: [String: String] = ["id" : theId]
            self._select(cond)
        }
    }
    
    private func _select(conditions: [String: String]?) {
        
    }
}

extension FIOApiObject {
    
    func fields() -> [String] {
        var fields = [String]()
        
        // loop that looks for properties
        let allProps = reflect(self)
        var filteredProps = [String: Any]()
        for var i = 0; i < allProps.count; i++ {
            // put values into array of filtered values
            if allProps[i].0 != "super" {
                filteredProps[allProps[i].0] = allProps[i].1.value
            }
            if let obj = self as? FIOApiTransferable {
                if let toIgnore = obj.ignoreFields() {
                    if !contains(toIgnore, allProps[i].0) {
                        filteredProps[allProps[i].0] = allProps[i].1.value
                    }
                }
            }
        }
        
        return fields
    }
    
    func __toSendFormat() -> NSDictionary {
        var dict: NSMutableDictionary = [_id!: "_id", _createdAt!.description: "_createdAt"]
        if let keys = self._innerProperties?.keys {
            for key in keys {
                dic//t["test"] = "fdjk"
            }
        }
        return dict
    }
    
    private func _save() {
        var action = FIOApiAction(module: "api", controller: "dataobject", action: "set", library: "fillio")
        //action["test"] = "coucou"
        action.run()
    }
}