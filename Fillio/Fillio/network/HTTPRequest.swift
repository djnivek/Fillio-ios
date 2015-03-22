//
//  HTTPRequest.swift
//  Fillio
//
//  Created by Kévin MACHADO on 18/03/2015.
//  Copyright (c) 2015 Kévin MACHADO. All rights reserved.
//

import Foundation

public struct HTTPRequest {
    var url: String
    var params: NSDictionary?
    var method: HTTPMethod
    var headers: String
    var body: String?
}