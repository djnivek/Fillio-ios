//
//  Adresse.swift
//  Fillio
//
//  Created by Kévin MACHADO on 11/04/2015.
//  Copyright (c) 2015 Kévin MACHADO. All rights reserved.
//

import Foundation
import Fillio

class Adresse: FIONetworkObjectAuto {
    
    var number: NSNumber?
    var street: String?
    
    init(_ data: FIODictionary) {
        super.init(data, autoMapping: true)
    }
    
    override var description: String {
        get {
            if let s = street {
                if let n = number {
                    return "\(n) \(s)"
                }
                return "\(s)"
            }
            return "Adresse non renseignée"
        }
    }

}