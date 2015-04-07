//
//  HTTPTask.swift
//  Fillio
//
//  Created by Kévin MACHADO on 25/03/2015.
//  Copyright (c) 2015 Kévin MACHADO. All rights reserved.
//

import Foundation

public protocol FIONetworkTaskDelegate {
    /// Tells the delegate that a response has received from the task (required)
    func Task(task: FIONetworkTask, didReceiveResponse response: AnyObject, withinSession session: NSURLSession)
    
    /// Tells the delegate that a error occurred (required)
    func Task(task: FIONetworkTask, didFailedWithError error: NSError, withinSession session: NSURLSession?)
}

public class FIONetworkTask {

    public typealias successHandlerParam = (AnyObject?)
    public typealias completeHandlerParam = (AnyObject?, NSError?)
    
    /// The completion blocks of the task
    ///
    /// - Success: The completion block called when the task finished
    /// - Fail: The completion block called when a error occured on the task
    /// - Complete: The completion block call when Success or Fail block has been called. Complete can have multiple blocks !
    public struct CompletionBlock {
        
        /// The alias of the complete block
        typealias completeBlock = (completeHandlerParam) -> ()
        
        /// The list of the complete block
        private var completionBlocks = [completeBlock]()
        
        /// The optional completionBlock called at the end
        var completionBlock: completeBlock? {
            get {
                return nil
            }
            set {
                if let val = newValue {
                    completionBlocks.append(val)
                }
            }
        }
        
        /// The optional block called on success
        var completionSuccessBlock: ((successHandlerParam) -> ())?
        
        /// The optional block called on fail
        var completionFailBlock: ((NSError?) -> ())?
        
        /**
            Function that call all completionBlocks set
        
            :discuss: We can set multiple completionBlock so we need to call them with only one function

            :param: response The optional response
            :param: data The optional data
            :param: error The optional error
        */
        public mutating func AllCompletionBlock(response: AnyObject?,_ error: NSError?) {
            for block in completionBlocks {
                block(response, error)
            }
        }
        
        /**
        
            The function with completionBlock that is called when success or fail block has been called
        
            :param: block A handler that the class can call
        */
        public mutating func Complete(block: (completeHandlerParam)->()) {
            self.completionBlock = block
        }
        
        /**
        
            The function with completionBlock that is called when the task failed
        
            :param: block A handler that the class can call
        */
        public mutating func Fail(block: (NSError?)->()) {
            self.completionFailBlock = block
        }
        
        /**
        
            The function with completionBlock that is called when the task succeed
        
            :param: block A handler that the class can call
        */
        public mutating func Success(block: (successHandlerParam)->()) {
            self.completionSuccessBlock = block
        }
        
        init(_ completionBlock:((AnyObject?, NSError?) -> ())?, _ completionSuccessBlock:((AnyObject?) -> ())?, _ completionFailBlock:((NSError?) -> ())?) {
            
        }
    }
    
    /// The params given for task
    let param: String
    
    /// The url for the task
    public let url: String
    
    /// The session task associated to self
    var sessionTask: NSURLSessionTask?
    
    /// The blocks struct that tells callback on completion
    public var blocks: CompletionBlock
    
    var delegate: FIONetworkTaskDelegate?
    
    public var response: FIONetworkTaskResponse? {
        didSet {
            if let theDelegate = self.delegate {
                if let resp = response {
                    if resp.isFailed {
                        //theDelegate.Task(self, didFailedWithError: resp.error!, withinSession: self.sessionTask!)
                    } else {
                        //theDelegate.Task(self, didReceiveResponse: resp.data, withinSession: self.sessionTask!)
                    }
                }
            }
        }
    }
    
    /// The completion handler called when the load request is complete (session.dataTaskWithRequest).
    ///
    /// Should be set on a block usage rather than delegate.
    /// Both can be used
    func completionHandler(data: NSData!, response: NSURLResponse!, error: NSError!) -> Void {
        self.response = FIONetworkTaskResponse(response: response, data: data)
    }
    
    //private func
    
    /// The computed request of the task
    var request: NSURLRequest? {
        if let theURL = NSURL(string: self.url) {
            return NSURLRequest(URL: theURL)
        }
        return nil
    }
    
    init(param: String, url: String) {
        self.param = param
        self.url = url
        self.blocks = CompletionBlock(nil, nil, nil)
    }
    
    // MARK: - Block State
    
    public var progress: NSProgress? {
        return nil
    }
    
    // MARK: - Controlling the Task State
    
    public func resume() {
        if let task = sessionTask {
            task.resume()
        }
    }
}