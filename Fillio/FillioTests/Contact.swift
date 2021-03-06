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
    var adresse: Adresse?
    
    init(_ data: FIODictionary) {
        super.init(data, autoMapping: false)
        adresse = Adresse(data?["adresse"] as? [String: AnyObject])
    }
    
    override func Map() -> [String : String] {
        var map = [String: String]()
        map["prenom"] = "firstname"
        map["nom"] = "lastname"
        map["age"] = "age"
        map["phone"] = "phone"
        return map
    }
}