//
//  TaskManager.swift
//  Fillio
//
//  Created by Kévin MACHADO on 25/03/2015.
//  Copyright (c) 2015 Kévin MACHADO. All rights reserved.
//

import Foundation

protocol FIONetworkTaskManagerDelegate {
    func didReceiveResponse(response: NSURLResponse?, withinSession session: NSURLSession, forTask task: FIONetworkTask)
    func didUploadProgress(withinSession session: NSURLSession, forTask task: NSURLSessionTask, withProgress progress: NSProgress)
    func downloadProgress(withinSession session: NSURLSession, forTask task: NSURLSessionTask, withProgress progress: NSProgress)
}

class FIONetworkTaskManager: NSObject, NSURLSessionDelegate, NSURLSessionDownloadDelegate, NSURLSessionTaskDelegate {
    
    /// The client session, sharedSession by default
    var session: NSURLSession = NSURLSession.sharedSession()
    
    /// The delegate
    var delegate: FIONetworkTaskManagerDelegate?
    
    /// The stack of tasks
    private var tasks = [FIONetworkTask]()
    
    /// The client provided to the taskManager
    unowned let ownClient: FIONetworkHTTPClient
    
    init(client: FIONetworkHTTPClient, delegate: FIONetworkTaskManagerDelegate) {
        self.ownClient = client
        self.delegate = delegate
    }
    
    func addTaskToQueue(task: FIONetworkTask) {
        
        // Add task to session
        if let request = task.request {
            let theTask: NSURLSessionTask = session.dataTaskWithRequest(request, completionHandler: {
                (data, response, error) in
                if let myDelegate = self.delegate {
                    myDelegate.didReceiveResponse(response, withinSession: self.session, forTask: task)
                }
            })
            
            // add sessionTask to the task
            task.sessionTask = theTask
            
            // insert task to stack
            tasks.append(task)
            
            // start the task if required by the client
            if ownClient.config.autostartTask {
                theTask.resume()
            }
        }
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, willPerformHTTPRedirection response: NSHTTPURLResponse, newRequest request: NSURLRequest, completionHandler: (NSURLRequest!) -> Void) {
        println("willPerform")
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        println("didFinishDownloading")
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        println("didCompleteWithError")
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        println("didReceiveBodyData")
    }
    
    //URLS
}