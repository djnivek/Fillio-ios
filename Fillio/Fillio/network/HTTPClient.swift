//
//  HttpServer.swift
//  Fillio
//
//  Created by Kévin MACHADO on 09/03/2015.
//  Copyright (c) 2015 Kévin MACHADO. All rights reserved.
//

import UIKit

enum HTTPMethod {
    case POST
    case PUT
    case DELETE
    case GET
}

enum HTTPResponseBody {
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

enum HTTPResponse {
    case OK(HTTPResponseBody)
    case NotFound, Forbidden, Unauthorized
    case InternalServerError
}

class FIONetworkHTTPClient {
    
    var queue = FIONetworkHTTPClientQueue()
    
    class var sharedClient: FIONetworkHTTPClient {
        struct Singleton {
            static let instance = FIONetworkHTTPClient()
        }
        return Singleton.instance
    }
    
    subscript(request: HTTPRequest) -> (() -> ())? {
        get {
            return nil
        }
        set {
            if let completionHandler = newValue {
                queue.append(request, withCompletion: completionHandler)
            }
        }
    }

    func getRequest(url: String, body: String) {
        //queue.stack.append(HTTPRequest(url: url, params: params))
    }
    
    func postRequest(url: String, params: NSDictionary, success: (()->()), failure:((NSError)->())) {
        //queue.stack.append(HTTPRequest(url: url, params: params))
        //success()
    }
    
    func downloadImage(url: String) -> UIImage {
        let url = NSURL(string: url)
        let data = NSData(contentsOfURL: url!)
        let image = UIImage(data: data!)
        return image!
    }
    
}

class Test {
    
    typealias Handler = (String -> ())
    
    enum functionType {
        case SUCCESS(Handler)
        case FAIL(Handler)
    }
    
    var handlers: [String: functionType] = [String: functionType]() {
        didSet {
            handleIt()
        }
    }
    
    subscript(path: String) -> ((String -> ()), (String -> ()))? {
        get {
            return nil
        }
        set (val) {
            if let callback = val {
                //var vdsfd = .SUCCESS(callback.1)
                //handlers[path] = vdsfd
            }
        }
    }
    
    func handleIt() {
        for handler in handlers {
            /*let (success, error) = handler.1
            switch success {
            case Function.SUCCESS(let function) :
                function("youpi")
            case Function.FAIL(let function) :
                function("oups")
            }*/
            //callback(handler.0)
            handlers.removeValueForKey(handler.0)
        }
    }
}