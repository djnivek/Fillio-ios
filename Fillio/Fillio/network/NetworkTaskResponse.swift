//
//  HTTPReponseBody.swift
//  Fillio
//
//  Created by Kévin MACHADO on 20/03/2015.
//  Copyright (c) 2015 Kévin MACHADO. All rights reserved.
//

import Foundation

public class FIONetworkTaskResponse {
    
    private let _response: NSURLResponse?
    
    private let _data: NSData?
    
    let error: NSError?
    
    init(response: NSURLResponse, data: NSData) {
        self._response = response
        self._data = data
    }
    
    init(error: NSError) {
        self.error = error
    }
    
    /// The status of the response
    ///
    /// Return false if the response has an error
    var isFailed: Bool {
        return error != nil
    }
    
    var data: AnyObject {
        
        // detect type
        if let resp = _response {
            if let mime = resp.MIMEType {
                switch mime {
                case "application/json":
                    return FIONetworkResponseBody.JSON(self._data).data
                case "application/xml":
                    return FIONetworkResponseBody.XML(self._data).data
                default:
                    return FIONetworkResponseBody.HTML(self._data).data
                }
            }
        }
        
        return FIONetworkResponseBody.HTML(self._data).data
    }
    
}

/// The response body
private enum FIONetworkResponseBody {
    
    case JSON(NSData?)
    
    case XML(NSData?)
    
    case HTML(NSData?)
    
    var data: AnyObject {
        switch self {
        case .JSON(let data) :
            var serializeError: NSError?
            if let d = data {
                if let json: AnyObject = NSJSONSerialization.JSONObjectWithData(d, options: NSJSONReadingOptions.AllowFragments, error: &serializeError) {
                    if let error = serializeError {
                        return ["error":error.description]
                    }
                    return json
                }
            }
            return ["error":"Cannot parse JSON"]
        case .XML(let data) :
            return ["error":"Cannot parse XML"]
        case .HTML(let data) :
            if let d = data {
                if let string = NSString(data: d, encoding: NSUTF8StringEncoding) {
                    return string
                }
            }
            return ["error":"Cannot parse HTML"]
        }
    }
    
}