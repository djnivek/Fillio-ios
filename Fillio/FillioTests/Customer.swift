//
//  Customer.swift
//  Fillio
//
//  Created by Kévin MACHADO on 04/05/2015.
//  Copyright (c) 2015 Kévin MACHADO. All rights reserved.
//

import Foundation
import Fillio

class Customer: FIOApiObject {
    
    var name: String
    var tel: String
    
    init(name: String, tel: String) {
        self.name = name
        self.tel = tel
        super.init()
    }
}

extension Customer: FIOApiTransferable {
    
    func modelName() -> String {
        return "Model_Customer"
    }
    
    func ignoreFields() -> [String]? {
        return nil
    }
}