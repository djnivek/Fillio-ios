//
//  HttpServer.swift
//  Fillio
//
//  Created by Kévin MACHADO on 09/03/2015.
//  Copyright (c) 2015 Kévin MACHADO. All rights reserved.
//

import UIKit

public class FIONetworkHTTPClient: FIONetworkClientConfigurationDelegate, FIONetworkTaskManagerDelegate {
    
    /// configuration destinée à la session
    public var config: FIONetworkClientConfiguration = FIONetworkClientConfiguration() {
        didSet(newConfig) {
            resetSessionWithConfig(newConfig)
        }
    }
    
    /// The manager of client tasks. Underlying the session and task.
    lazy var taskManager: FIONetworkTaskManager = FIONetworkTaskManager(client: self, delegate: self)
    
    /// The root url for the client
    var rootURL: NSURL?
    
    init() {
        //self.taskManager = FIONetworkTaskManager(client: self, delegate: self)
        config.delegate = self
    }
    
    convenience init(url: NSURL) {
        self.init()
        self.rootURL = url
    }
    
    public typealias completionWithTuples = ((NSURLResponse?, NSData?, NSError?)-> Void)?
    public typealias functionSetting = (String, completionWithTuples) -> FIONetworkTask
    
    public subscript (url: String) -> functionSetting {
        get {
            var res: functionSetting = { (param: String, completion: completionWithTuples) in
                
                // create task with elements
                var task = FIONetworkTask(param: param, url: url)
                
                if let block = completion {
                    task.blocks.completionBlock = block
                }
                
                // insert task into the taskManager
                self.queueTask(task)
                
                return task
            }
            return res
        }
    }
    
    // MARK: - Session
    
    // MARK: Config
    
    private func resetSessionWithConfig(config: FIONetworkClientConfiguration) {
        println("Session changed with new configuration")
        taskManager.session = NSURLSession(configuration: config.sessionConfig, delegate: taskManager, delegateQueue: nil)
    }
    
    func didChangedSessionConfig(config: FIONetworkClientConfiguration) {
        resetSessionWithConfig(config)
    }
    
    // MARK: Delegate
    
    func Task(task: FIONetworkTask, didReceiveResponse response: NSURLResponse?, data: NSData?, withinSession session: NSURLSession) {
        
        task.blocks.AllCompletionBlock(response, data, nil)
        
        if let completionSuccess = task.blocks.completionSuccessBlock {
            completionSuccess(response, data)
        }
    }
    
    func Task(task: FIONetworkTask, didFailedWithError error: NSError, withinSession session: NSURLSession) {
        task.blocks.AllCompletionBlock(nil, nil, error)
        if let completionFail = task.blocks.completionFailBlock {
            completionFail(error)
        }
    }
    
    // MARK: -
    
    private func queueTask(task: FIONetworkTask) {
        taskManager.addTaskToQueue(task)
    }
    
    public func downloadImage(url: String) -> UIImage {
        let url = NSURL(string: url)
        let data = NSData(contentsOfURL: url!)
        let image = UIImage(data: data!)
        return image!
    }
    
}