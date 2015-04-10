//
//  FIOObject.swift
//  Fillio
//
//  Created by Kévin MACHADO on 10/04/2015.
//  Copyright (c) 2015 Kévin MACHADO. All rights reserved.
//

import Foundation
import Fillio

class Contact: FIONetworkObjectAuto {
    
    var firstname: String?
    var lastname: String?
    var phone: String?
    var age: NSNumber?
    
    /*override var description: String {
        get {
            if let f = firstname {
                if let l = lastname {
                    if let p = phone {
                        if let a = age {
                            return "\(f) \(l), \(a)ans, joignable au \(p)"
                        }
                        return "\(f) \(l), joignable au \(p)"
                    }
                    return "\(f) \(l)"
                }
                return "\(f)"
            }
            return "Fiche de contact vide"
        }
    }*/
}