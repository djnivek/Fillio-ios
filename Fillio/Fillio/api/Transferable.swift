//
//  Encodable.swift
//  Fillio
//
//  Created by Kévin MACHADO on 09/03/2015.
//  Copyright (c) 2015 Kévin MACHADO. All rights reserved.
//

import Foundation

/// This protocol adds methods to transfert object to iOS from Fillio Server and from iOS to Fillio Server
public protocol FIOApiTransferable {
    
    /// This static method get the name of the class into your Fillio Project
    func modelName() -> String
    
    /// This static method get the fields' name that will be ignored into the data transfert
    func ignoreFields() -> [String]?
}

/// This protocol adds methods to transfert object to iOS from Fillio Server and from iOS to Fillio Server
/*protocol Transferable {
    
    /// This static method get the name of the class into your Fillio Project
    static func modelName() -> String
    
    /// The method that format the object to send it on the server
    func __toSendFormat() -> NSDictionary
}*/

/*class Transferable: TransferableProtocol {
    
    /// The name of the class into your Fillio Project
    ///
    /// Example : Model_User
    var fillioModelName: String
    
    init() {
        self.fillioModelName = FIOApiObject.modelName()
    }
    
    class func modelName() -> String {
        fatalError("The model name should be overriden")
    }
    
    func __toSendFormat() -> NSDictionary {
        fatalError("This method must be overidden")
    }
    
}*/