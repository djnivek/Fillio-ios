//
//  NetworkObject.swift
//  Fillio
//
//  Created by Kévin MACHADO on 03/04/2015.
//  Copyright (c) 2015 Kévin MACHADO. All rights reserved.
//

import Foundation

enum FIONetworkResultType {
    case Image
    case Object
}

class FIONetworkResultObject {
    
    private var properties: [String:Any]?
    
    subscript (path: AnyObject) -> AnyObject? {
        get {
            
        }
    }

}