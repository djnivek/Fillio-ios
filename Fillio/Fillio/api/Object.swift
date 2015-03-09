//
//  User.swift
//  Fillio
//
//  Created by Kévin MACHADO on 09/03/2015.
//  Copyright (c) 2015 Kévin MACHADO. All rights reserved.
//

import Foundation

class FIOApiObject: Encodable {
    
    var id: String?
    var createdAt: NSDate?
    
    override func __encode() -> NSDictionary {
        let dict: [String : String] = [id!: "_id", createdAt!.description: "_createdAt"]
        return dict
    }
}