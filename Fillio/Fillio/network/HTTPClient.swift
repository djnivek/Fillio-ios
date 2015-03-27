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
    
    /// configuration destinée à la session
    public var config: FIONetworkClientConfiguration = FIONetworkClientConfiguration() {
        didSet(newConfig) {
            resetSessionWithConfig(newConfig)
        }
    }
    
    /// The manager of client tasks. Underlying the session and task.
    var taskManager = FIONetworkTaskManager()
    
    /// file d'attente (?)
    //var queue = FIONetworkHTTPClientQueue()
    
    /// The root url for the client
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
    
    public typealias completionWithTuples = ((String, String)-> Void)
    public typealias functionSetting = (String, completionWithTuples) -> Void
    
    public subscript (url: String) -> functionSetting {
        get {
            var res: functionSetting = { (param: String, completion: completionWithTuples) in
                completion(param, url)
                self.queueTaskWithinSession(param, url: url)
            }
            return res
        }
    }
    
    // MARK: - Session
    
    private func resetSessionWithConfig(config: FIONetworkClientConfiguration) {
        println("Session changed with new configuration")
        taskManager.session = NSURLSession(configuration: config.sessionConfig, delegate: taskManager, delegateQueue: nil)
    }
    
    func didChangedSessionConfig(config: FIONetworkClientConfiguration) {
        resetSessionWithConfig(config)
    }
    
    // MARK: -
    
    public func progressHandler(handler: (()->())) {
        
    }
    
    private func queueTaskWithinSession(param: String, url: String) {
        var task = FIONetworkTask(param: param, url: url)
        taskManager.addTaskToQueue(task)
    }
    
    public func downloadImage(url: String) -> UIImage {
        let url = NSURL(string: url)
        let data = NSData(contentsOfURL: url!)
        let image = UIImage(data: data!)
        return image!
    }
    
}