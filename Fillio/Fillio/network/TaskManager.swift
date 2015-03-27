//
//  TaskManager.swift
//  Fillio
//
//  Created by Kévin MACHADO on 25/03/2015.
//  Copyright (c) 2015 Kévin MACHADO. All rights reserved.
//

import Foundation

protocol FIONetworkTaskManagerDelegate {
    func didReceiveResponse(response: NSURLResponse, withinSession session: NSURLSession, forTask task: NSURLSessionTask)
    func didUploadProgress(withinSession session: NSURLSession, forTask task: NSURLSessionTask, withProgress progress: NSProgress)
    func downloadProgress(withinSession session: NSURLSession, forTask task: NSURLSessionTask, withProgress progress: NSProgress)
}

class FIONetworkTaskManager: NSObject, NSURLSessionDelegate, NSURLSessionDownloadDelegate, NSURLSessionTaskDelegate {
    
    /// The client session, sharedSession by default
    var session: NSURLSession = NSURLSession.sharedSession()
    
    /// stack of client tasks
    var tasks = [NSURLSessionTask]()
    
    func addTaskToQueue(task: FIONetworkTask) {
        if let request = task.request {
            var theTask = session.dataTaskWithRequest(request)
            tasks.append(theTask)
        }
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        
    }
    
    //URLS
}