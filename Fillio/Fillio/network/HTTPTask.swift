//
//  HTTPTask.swift
//  Fillio
//
//  Created by Kévin MACHADO on 25/03/2015.
//  Copyright (c) 2015 Kévin MACHADO. All rights reserved.
//

import Foundation

public class FIONetworkTask {
    
    /// The params given for task
    let param: String
    
    /// The url for the task
    let url: String
    
    /// The session task associated to self
    var sessionTask: NSURLSessionTask?
    
    /// The optional completionBlock called at the end
    var completionBlock: ((String, String) -> ())?
    
    private var secondTestCompletionBlock: (() -> Void)?
    
    var request: NSURLRequest? {
        if let theURL = NSURL(string: self.url) {
            return NSURLRequest(URL: theURL)
        }
        return nil
    }
    
    init(param: String, url: String) {
        self.param = param
        self.url = url
    }
    
    // MARK: - Block State
    
    public var progress: NSProgress? {
        return nil
    }
    
    public func didTestCompletionBlock(block: ()->()) {
        self.secondTestCompletionBlock = block
    }
    
    public func didComplete(block: (String, String)->()) {
        self.completionBlock = block
    }
    
    // MARK: - Controlling the Task State
    
    public func resume() {
        if let task = sessionTask {
            task.resume()
        }
    }
}