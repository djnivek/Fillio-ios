//
//  HttpServer.swift
//  Fillio
//
//  Created by Kévin MACHADO on 09/03/2015.
//  Copyright (c) 2015 Kévin MACHADO. All rights reserved.
//

import UIKit

enum HTTPResponse {
    case OK(HTTPResponseBody)
    case NotFound, Forbidden, Unauthorized
    case InternalServerError
}

public class FIONetworkHTTPClient {
    
    // session pour le client
    var sessions = [NSURLSession]()
    
    // file d'attente (?)
    var queue = FIONetworkHTTPClientQueue()
    
    // url racine du client
    var rootURL: NSURL?
    
    init() {}
    
    convenience init(url: NSURL?) {
        self.init()
        if let theUrl = url {
            self.rootURL = theUrl
        }
    }
    
    /*public class var sharedClient: FIONetworkHTTPClient {
        struct Singleton {
            static let instance = FIONetworkHTTPClient()
        }
        return Singleton.instance
    }*/
    
    public typealias completionWithTuples = ((String, String, String)->())
    public typealias functionSetting = (String, String, completionWithTuples) -> ()
    
    public subscript (url: String) -> functionSetting {
        get {
            var res: functionSetting = { (method: String, param: String, completion: completionWithTuples) in
                completion(method, param, url)
            }
            return res
        }
    }
    
    public func progressHandler(handler: (()->())) {
        
    }
    
    public func downloadImage(url: String) -> UIImage {
        let url = NSURL(string: url)
        let data = NSData(contentsOfURL: url!)
        let image = UIImage(data: data!)
        return image!
    }
    
}