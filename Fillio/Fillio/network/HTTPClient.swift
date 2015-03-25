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

public class FIONetworkHTTPClient: FIONetworkClientConfigurationDelegate {
    
    /// session pour le client
    var session = NSURLSession()
    
    /// configuration destinée à la session
    public var config: FIONetworkClientConfiguration = FIONetworkClientConfiguration() {
        didSet(newConfig) {
            session = NSURLSession(configuration: newConfig.sessionConfig)
            println("Session changed with new configuration")
        }
    }
    
    /// client's tasks
    var taskManager = FIONetworkTaskManager()
    
    /// file d'attente (?)
    var queue = FIONetworkHTTPClientQueue()
    
    /// url racine du client
    var rootURL: NSURL?
    
    init() {
        config.delegate = self
    }
    
    convenience init(url: NSURL?) {
        self.init()
        if let theUrl = url {
            self.rootURL = theUrl
        }
    }
    
    func didChangedSessionConfig(config: FIONetworkClientConfiguration) {
        println("Session changed with new configuration")
        session = NSURLSession(configuration: config.sessionConfig)
    }
    
    public typealias completionWithTuples = ((String, String, String)->())
    public typealias functionSetting = (String, String, completionWithTuples) -> ()
    
    public subscript (url: String) -> functionSetting {
        get {
            var res: functionSetting = { (method: String, param: String, completion: completionWithTuples) in
                completion(method, param, url)
                self.queueTaskWithinSession(method: method, param: param, url: url)
            }
            return res
        }
    }
    
    public func progressHandler(handler: (()->())) {
        
    }
    
    private func queueTaskWithinSession(#method: String, param: String, url: String) {
        
    }
    
    public func downloadImage(url: String) -> UIImage {
        let url = NSURL(string: url)
        let data = NSData(contentsOfURL: url!)
        let image = UIImage(data: data!)
        return image!
    }
    
}