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
    
    /// The identifier provided by fillio
    private var _id: String?
    
    /// The unique identifier created during the first initialization
    private var _uniqueID: String?
    
    /// The creation date
    private var _createdAt: NSDate?
    
    /// The update date
    private var _updatedAt: NSDate?
    
    /// This flag indicates you the object was gotten from the server
    private var _flagObjectFromServer: Bool?
    
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
        _flagObjectFromServer = false
        _createdAt = NSDate()
        _uniqueID = uniqueIdentifier()
    }
    
    private func uniqueIdentifier() -> String {
        fatalError("uniqueIdentifier : function does not exist for now, create it")
    }
    
    public init(fromServer: Bool) {
        _flagObjectFromServer = fromServer
    }
    
    convenience init(json: [String: AnyObject], fromServer: Bool) {
        self.init(fromServer: fromServer)
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
    
    public func save() {
        self._save()
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
    
    /// This method return params for the server (readonly)
    ///
    /// The ignore params are excluded to this list
    ///
    /// :returns: Properties formated into String
    func _intoParams() -> [String: String] {
        
        var dict = [String: String]()
        
        if let id = _id {
            dict["_id"] = id
        }
        if let uId = _uniqueID {
            dict["_uniqueID"] = uId
        }
        if let createdAt = _createdAt {
            dict["_createdAt"] = createdAt.description
        }
        if let keys = _innerProperties?.keys {
            for key in keys {
                if let propertyStringVal = _innerProperties![key] as? String {
                    dict[key] = propertyStringVal
                }
            }
        }
        return dict
    }
    
    private func _save() {
        
        let params = _intoParams()
        
        /*
        var action = FIOApiAction(module: "api", controller: "dataobject", action: "set", library: "fillio")
        //action["test"] = "coucou"
        action.run()*/
    }
}