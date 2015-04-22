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
    func Task(task: FIONetworkTask, didReceiveResponse response: FIONetworkBridgeResponse)
    
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
                    let string = RequestParams.toGET(dict)
                    urlMutable.appendUrl(string)
                    req.URL = NSURL(string: urlMutable)
                }
            case .POST(let dictionary):
                req.HTTPMethod = "POST"
                if let dict = dictionary {
                    var err: NSError?
                    let params = RequestParams.toPOST(dict)
                    if req.valueForHTTPHeaderField("Content-Type") == nil {
                        req.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                    }
                    req.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
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
    
    /// The completion blocks of the task
    ///
    /// - Success: The completion block called when the task finished
    /// - Fail: The completion block called when a error occured on the task
    /// - Complete: The completion block call when Success or Fail block has been called. Complete can have multiple blocks !
    public struct CompletionBlock {
        
        /// The alias of the complete block
        typealias completeBlock = (FIONetworkBridgeResponse?, NSError?) -> ()
        
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
        var completionSuccessBlock: ((FIONetworkBridgeResponse) -> ())?
        
        /// The optional block called on fail
        var completionFailBlock: ((NSError?) -> ())?
        
        /**
        Function that call all completionBlocks set
        
        :discuss: We can set multiple completionBlock so we need to call them with only one function
        
        :param: response The optional response
        :param: data The optional data
        :param: error The optional error
        */
        public mutating func AllCompletionBlock(response: FIONetworkBridgeResponse?,_ error: NSError?) {
            for block in completionBlocks {
                block(response, error)
            }
        }
        
        /**
        
        The function with completionBlock that is called when success or fail block has been called
        
        :param: block A handler that the class can call
        */
        public mutating func Complete(block: (FIONetworkBridgeResponse?, NSError?)->()) {
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
        public mutating func Success(block: (FIONetworkBridgeResponse)->()) {
            self.completionSuccessBlock = block
        }
        
        init(_ completionBlock:((FIONetworkBridgeResponse?, NSError?) -> ())?, _ completionSuccessBlock:((AnyObject?) -> ())?, _ completionFailBlock:((NSError?) -> ())?) {
            
        }
    }
}

// MARK: - RequestParams

class RequestParams {
    
    class func toString(dictionary: [String: AnyObject], prefix: String?) -> String {
        var components: [(String, String)] = []
        for key in sorted(Array(dictionary.keys), <) {
            let value: AnyObject! = dictionary[key]
            components += self.queryComponents(key, value)
        }
        
        if let p = prefix {
            return p+join("&", components.map{"\($0)=\($1)"} as [String])
        }
        
        return join("&", components.map{"\($0)=\($1)"} as [String])
    }
    
    /// The class method that return params formated to get method
    ///
    /// Example : ?action=test&id=12
    class func toGET(dictionary: [String: AnyObject]) -> String {
        return self.toString(dictionary, prefix: "?")
    }
    
    /// The class method that return params formated to post method
    ///
    /// Example : action=test&id=12
    class func toPOST(dictionary: [String: AnyObject]) -> String {
        return self.toString(dictionary, prefix: nil)
    }
    
    class func queryComponents(key: String, _ value: AnyObject) -> [(String, String)] {
        var components: [(String, String)] = []
        if let dictionary = value as? [String: AnyObject] {
            for (nestedKey, value) in dictionary {
                components += queryComponents("\(key)[\(nestedKey)]", value)
            }
        } else if let array = value as? [AnyObject] {
            for value in array {
                components += queryComponents("\(key)[]", value)
            }
        } else {
            components.extend([(escape(key), escape("\(value)"))])
        }
        
        return components
    }
    
    class func escape(string: String) -> String {
        let legalURLCharactersToBeEscaped: CFStringRef = ":&=;+!@#$()',*"
        return CFURLCreateStringByAddingPercentEscapes(nil, string, nil, legalURLCharactersToBeEscaped, CFStringBuiltInEncodings.UTF8.rawValue) as String
    }
}