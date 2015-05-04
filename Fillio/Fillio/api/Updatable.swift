//
//  Encodable.swift
//  Fillio
//
//  Created by Kévin MACHADO on 09/03/2015.
//  Copyright (c) 2015 Kévin MACHADO. All rights reserved.
//

import Foundation

class Updatable {
    
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
    
}