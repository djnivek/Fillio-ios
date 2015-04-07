//
//  HTTPReponseBody.swift
//  Fillio
//
//  Created by Kévin MACHADO on 20/03/2015.
//  Copyright (c) 2015 Kévin MACHADO. All rights reserved.
//

import Foundation

/// The response body
enum FIONetworkResponseBody {
    
    case JSON(AnyObject)
    
    case XML(AnyObject)
    
    case HTML(String)
    
    var data: String {
        switch self {
        case .JSON(let data) :
            var serializeError: NSError?
            if NSJSONSerialization.isValidJSONObject(data) {
                if let json = NSJSONSerialization.dataWithJSONObject(data, options: NSJSONWritingOptions.PrettyPrinted, error: &serializeError) {
                    if let jsonString = NSString(data: json, encoding: NSUTF8StringEncoding) {
                        return jsonString as String
                    }
                }
            } else {
                return "Error during serialization"
            }
            return "Cannot parse JSON"
        case .XML(let data) :
            return "Cannot parse XML"
        case .HTML(let string) :
            return string
        }
    }
    
}