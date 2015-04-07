//
//  HTTPReponseBody.swift
//  Fillio
//
//  Created by Kévin MACHADO on 20/03/2015.
//  Copyright (c) 2015 Kévin MACHADO. All rights reserved.
//

import Foundation

class FIONetworkTaskResponse {
    
    private let _response: NSURLResponse
    
    private let _data: NSData
    
    init(response: NSURLResponse, data: NSData) {
        self._response = response
        self._data = data
    }
    
    var response: AnyObject {
        
        // detect type
        
        if let mime = _response.MIMEType {
            switch mime {
            case "application/json":
                return FIONetworkResponseBody.JSON(self._data).data
            case "application/xml":
                return FIONetworkResponseBody.XML(self._data).data
            default:
                return FIONetworkResponseBody.HTML(self._data).data
            }
        }
        
        return FIONetworkResponseBody.HTML(self._data).data
    }
    
}

/// The response body
private enum FIONetworkResponseBody {
    
    case JSON(NSData)
    
    case XML(NSData)
    
    case HTML(NSData)
    
    var data: AnyObject {
        switch self {
        case .JSON(let data) :
            var serializeError: NSError?
            if let json: AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &serializeError) {
                if let error = serializeError {
                    return ["error":error.description]
                }
                return json
            }
            return ["error":"Cannot parse JSON"]
        case .XML(let data) :
            return ["error":"Cannot parse XML"]
        case .HTML(let data) :
            if let string = NSString(data: data, encoding: NSUTF8StringEncoding) {
                return string
            }
            return ["error":"Cannot parse HTML"]
        }
    }
    
}