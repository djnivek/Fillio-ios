//
//  TaskManager.swift
//  Fillio
//
//  Created by Kévin MACHADO on 25/03/2015.
//  Copyright (c) 2015 Kévin MACHADO. All rights reserved.
//

import Foundation

// MARK: - TaskManager Delegate -

protocol FIONetworkTaskManagerDelegate {
    
    /// Tells the delegate that a response has received from the task (required)
    func Task(task: FIONetworkTask, didReceiveResponse response: AnyObject, withinSession session: NSURLSession)
    
    /// Tells the delegate that a error occurred (required)
    func Task(task: FIONetworkTask, didFailedWithError error: NSError, withinSession session: NSURLSession)
    
    /*func didUploadProgress(withinSession session: NSURLSession, forTask task: NSURLSessionTask, withProgress progress: NSProgress)
    func downloadProgress(withinSession session: NSURLSession, forTask task: NSURLSessionTask, withProgress progress: NSProgress)*/
}

// MARK: - TaskManager -

class FIONetworkTaskManager: NSObject {
    
    /// The client session provided to all tasks for this client
    ///
    /// By default, defaultSessionConfiguration is set
    ///
    /// The delegate is `self`
    lazy var session: NSURLSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: self, delegateQueue: nil)
    
    /// The delegate
    //var delegate: FIONetworkTaskManagerDelegate?
    
    /// The stack of tasks
    private var tasks = [FIONetworkTask]()
    
    /// The client provided to the taskManager
    unowned let ownClient: FIONetworkClient
    
    init(client: FIONetworkClient) {
        self.ownClient = client
    }
    
    /// This method add the task within the session and start/idle it depending on the configuration
    ///
    /// :param: task The task to add within the session
    ///
    /// :returns: `YES` if the task was added
    func addTaskToQueue(task: FIONetworkTask) -> Bool {
        
        // set delegate
        task.delegate = self
        
        // Add task to session
        if let request = task.request {
            
            var theTask: NSURLSessionTask?
            
            switch task.taskType {
            case .Request:
                let theTask: NSURLSessionTask = session.dataTaskWithRequest(request, completionHandler: task.didRequestComplete)
            case .Upload:
                let taskUpload = task as! FIONetworkTaskUpload
                switch taskUpload.uploadable {
                case .Data(let data):
                    let theTask: NSURLSessionTask = session.uploadTaskWithRequest(request, fromData: data)
                case .File(let fileURL):
                    let theTask: NSURLSessionTask = session.uploadTaskWithRequest(request, fromFile: fileURL)
                }
            default:
                theTask = nil
            }
            
            // add sessionTask to the task
            if let t = theTask {
                task.sessionTask = t
                
                // insert task to stack
                tasks.append(task)
                
                // start the task if required by the client
                if ownClient.config.autostartTask {
                    t.resume()
                }
                return true
            }
        }
        return false
    }
    
    
}

extension FIONetworkTaskManager: FIONetworkTaskDelegate {

    // MARK: - NetworkTask Delegate -
    
    func Task(task: FIONetworkTask, didFailedWithError error: NSError) {
        
        // call all block
        task.blocks.AllCompletionBlock(nil, error)
        if let completionFail = task.blocks.completionFailBlock {
            completionFail(error)
        }
        
        //  call delegate **************** needed ***************
        //  *                                                   *
        //  ***************** no delegate yet ! *****************
        //  ***************** no delegate yet ! *****************
        //  *                                                   *
        //  ************* needed ****************** call delegate
        
        
    }
    
    func Task(task: FIONetworkTask, didReceiveResponse response: FIONetworkBridgeResponse) {
        
        // call all block
        task.blocks.AllCompletionBlock(response, nil)
        if let completionSuccess = task.blocks.completionSuccessBlock {
            completionSuccess(response)
        }
        
        //  call delegate **************** needed ***************
        //  *                                                   *
        //  ***************** no delegate yet ! *****************
        //  ***************** no delegate yet ! *****************
        //  *                                                   *
        //  ************* needed ****************** call delegate
        
        
    }
}

// MARK: - Session Task Upload Delegate -

extension FIONetworkTaskManager: NSURLSessionTaskDelegate {//, NSURLSessionDownloadDelegate {
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        println("didCompleteWithError")
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        println("didReceiveBodyData")
    }
}