//
//  HttpServer.swift
//  Fillio
//
//  Created by Kévin MACHADO on 09/03/2015.
//  Copyright (c) 2015 Kévin MACHADO. All rights reserved.
//

import UIKit

struct HTTPRequest {
    var url: String
    var params: NSDictionary
    init(url: String, params: NSDictionary) {
        self.url = url
        self.params = params
    }
}

class FIONetworkHTTPClient {
    
    var queue = FIONetworkHTTPClientQueue()
    
    class var sharedClient: FIONetworkHTTPClient {
        struct Singleton {
            static let instance = FIONetworkHTTPClient()
        }
        return Singleton.instance
    }
    
    /*func response() -> (AnyObject) {
        
    }*/
    
    func getRequest(url: String, body: String) {
        queue.stack.append(HTTPRequest(url: url, params: params))
    }
    
    func postRequest(url: String, params: NSDictionary, success: (()->()), failure:((NSError)->())) {
        queue.stack.append(HTTPRequest(url: url, params: params))
        success()
    }
    
    func downloadImage(url: String) -> UIImage {
        let url = NSURL(string: url)
        let data = NSData(contentsOfURL: url!)
        let image = UIImage(data: data!)
        return image!
    }
    
}