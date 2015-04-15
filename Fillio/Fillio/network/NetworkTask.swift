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
    func Task(task: FIONetworkTask, didReceiveResponse response: AnyObject)
    
    /// Tells the delegate that a error occurred (required)
    func Task(task: FIONetworkTask, didFailedWithError error: NSError)
}

public class FIONetworkTask {
    
    // MARK: - Properties
    
    // MARK: Params
    
    /// The params given for task
    //private var param: [String: AnyObject]?
    
    // MARK: Others
    
    /// The HTTP method of the task
    var method: HTTPMethod = .GET(nil)
    
    /// The url for the task
    public let url: String
    
    /// The session task associated to self
    var sessionTask: NSURLSessionTask?
    
    /// The blocks struct that tells callback on completion
    public var blocks: CompletionBlock
    
    var delegate: FIONetworkTaskDelegate?
    
    // MARK: Computed properties
    
    public var response: FIONetworkTaskResponse? {
        didSet {
            
            if let theDelegate = self.delegate {
                if let resp = response {
                    if resp.isFailed {
                        theDelegate.Task(self, didFailedWithError: resp.error!)
                    } else {
                        theDelegate.Task(self, didReceiveResponse: resp.data)
                    }
                }
            }
        }
    }
    
    /// The computed request of the task
    ///
    /// This request adds automatically `HTTPMethod` and `Body`
    ///
    /// - GET Methods contains url appended with params
    /// - POST Methods contains body with params encoded to JSON
    var request: NSMutableURLRequest? {
        if let theURL = NSURL(string: self.url) {
            let req = NSMutableURLRequest(URL: theURL)
            switch method {
            case .GET(let dictionary):
                req.HTTPMethod = "GET"
                if let dict = dictionary {
                    var urlMutable = self.url
                    let string = RequestParams.RequestParamFromDictionary(dict)
                    urlMutable.appendUrl(string)
                    req.URL = NSURL(string: urlMutable)
                }
            case .POST(let dictionary):
                req.HTTPMethod = "POST"
                if let dict = dictionary {
                    var err: NSError?
                    req.HTTPBody = NSJSONSerialization.dataWithJSONObject(dict, options: NSJSONWritingOptions.allZeros, error: &err)
                    req.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    req.addValue("application/json", forHTTPHeaderField: "Accept")
                    //var boundary = "Boundary+\(arc4random())\(arc4random())"
                    /*if parameters != nil {
                        request.HTTPBody = dataFromParameters(parameters!,boundary: boundary)
                    }*/
                    /*if request.valueForHTTPHeaderField(contentTypeKey) == nil {
                        request.setValue("multipart/form-data; boundary=\(boundary)",
                            forHTTPHeaderField:contentTypeKey)
                    }*/
                }
            case .PUT:
                req.HTTPMethod = "PUT"
            case .DELETE:
                req.HTTPMethod = "DELETE"
            default:
                req.HTTPMethod = "GET"
            }
            return req
        }
        return nil
    }
    
    // MARK: Functions
    
    /// The completion handler called when the load request is complete (session.dataTaskWithRequest).
    ///
    /// Should be set on a block usage rather than delegate.
    /// Both can be used
    func completionHandler(data: NSData!, response: NSURLResponse!, error: NSError!) -> Void {
        if let d = data {
            if let r = response {
                self.response = FIONetworkTaskResponse(response: r, data: d)
            }
        }
        if let e = error {
            self.response = FIONetworkTaskResponse(error: e)
        }
    }
    
    init(method: HTTPMethod?, url: String) {
        if let m = method {
            self.method = m
        }
        self.url = url
        self.blocks = CompletionBlock(nil, nil, nil)
    }
}

// MARK: - State

extension FIONetworkTask {
    
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

// MARK: - Completion Handler

extension FIONetworkTask {
    
    public typealias successHandlerParam = (AnyObject)
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
}

// MARK: - RequestParams

class RequestParams {
    class func RequestParamFromDictionary(dictionary: [String: AnyObject]) -> String {
        
        var string: String = "?"
        var flagCharToAdd = false
        for key in dictionary.keys {
            if flagCharToAdd {
                string += "&"
            }
            flagCharToAdd = true
            if let val: AnyObject = dictionary[key] {
                string += "\(key)=\(val)"
            }
            
        }
        
        return string
    }
}