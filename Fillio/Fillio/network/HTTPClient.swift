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
    var body: String
    init(url: String, body: String) {
        self.url = url
        self.body = body
    }
}

class FIONetworkHTTPClient {
    
    var queue = FIONetworkHTTPClientQueue()
    
    class var sharedInstance: FIONetworkHTTPClient {
        struct Singleton {
            static let instance = FIONetworkHTTPClient()
        }
        return Singleton.instance
    }
    
    func response() -> (AnyObject) {
        
    }
    
    func getRequest(url: String, body: String) {
        queue.stack.append(HTTPRequest(url: url, body: body))
    }
    
    func postRequest(url: String, body: String) {
        //return nil
    }
    
    func downloadImage(url: String) -> UIImage {
        let url = NSURL(string: url)
        let data = NSData(contentsOfURL: url!)
        let image = UIImage(data: data!)
        return image!
    }
    
}