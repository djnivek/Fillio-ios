//
//  HTTPMethod.swift
//  Fillio
//
//  Created by Kévin MACHADO on 20/03/2015.
//  Copyright (c) 2015 Kévin MACHADO. All rights reserved.
//

import Foundation

public enum HTTPMethod {
    case GET([String: AnyObject]?)
    case POST([String: AnyObject]?)
    case PUT()
    case DELETE()
}