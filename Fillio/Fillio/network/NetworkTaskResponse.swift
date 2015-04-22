//
//  HTTPReponseBody.swift
//  Fillio
//
//  Created by Kévin MACHADO on 20/03/2015.
//  Copyright (c) 2015 Kévin MACHADO. All rights reserved.
//

import Foundation

public class FIONetworkTaskResponse {
    
    private var _response: NSURLResponse?
    
    private var _data: NSData?
    
    var error: NSError?
    
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
    
    var data: FIONetworkBridgeResponse {
        
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
    
    var data: FIONetworkBridgeResponse {
        switch self {
        case .JSON(let data) :
            var serializeError: NSError?
            if let d = data {
                if let json: AnyObject = NSJSONSerialization.JSONObjectWithData(d, options: NSJSONReadingOptions.AllowFragments, error: &serializeError) {
                    if let error = serializeError {
                        return FIONetworkBridgeResponse(string: nil, object:FIONetworkResultObject(data: ["error":error.description]))
                    }
                    return FIONetworkBridgeResponse(string: nil, object:FIONetworkResultObject(data: json))
                }
            }
            return FIONetworkBridgeResponse(string: nil, object:FIONetworkResultObject(data: ["error":"Cannot parse JSON"]))
        case .XML(let data) :
            return FIONetworkBridgeResponse(string: nil, object:FIONetworkResultObject(data: ["error":"Cannot parse XML"]))
        case .HTML(let data) :
            if let d = data {
                if let string = NSString(data: d, encoding: NSUTF8StringEncoding) {
                    return FIONetworkBridgeResponse(string: string as String, object:nil)
                }
            }
            return FIONetworkBridgeResponse(string: nil, object:FIONetworkResultObject(data: ["error":"Cannot parse HTML"]))
        }
    }
    
}