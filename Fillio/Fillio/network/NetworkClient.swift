//
//  HttpServer.swift
//  Fillio
//
//  Created by Kévin MACHADO on 09/03/2015.
//  Copyright (c) 2015 Kévin MACHADO. All rights reserved.
//

import UIKit

extension String {
    /**
        The method append `x` to `self` by adding backslash beetween them if needed
    
        :param: The string to append
        :example: self = 'www.google.com', string = test -> self = "www.google.com/test"
    */
    mutating func appendUrl(x: String) {
        var imX = x
        // delete prefix '/' if `x` have it
        if imX.hasPrefix("/") {
            let range = imX.rangeOfString("/", options: NSStringCompareOptions.LiteralSearch, range: nil, locale: nil)
            if let t = range {
                imX.removeRange(t)
            }
        }
        
        // add '/' if needed
        if self.hasSuffix("/") {
            self.extend(imX)
        } else {
            self.extend("/\(imX)")
        }
        println(self)
    }
}

public enum Uploadable {
    case Data(NSData)
    case File(NSURL)
}

/// This class manage client
///
/// Each client can have
///
/// - Proper url
/// - Proper config (see FIONetworkHTTPClientConfiguration )
/// - TaskManager
///
/// The client underly the taskManager logic
public class FIONetworkClient: FIONetworkClientConfigurationDelegate {
    
    /// configuration destinée à la session
    public var config: FIONetworkClientConfiguration = FIONetworkClientConfiguration() {
        didSet(newConfig) {
            resetSessionWithConfig(newConfig)
        }
    }
    
    /// The manager of client tasks. Underlying the session and task.
    lazy var taskManager: FIONetworkTaskManager = FIONetworkTaskManager(client: self)
    
    /// This struct provide a client url
    public struct URL {
        
        /// The absolute url like http://www.google.com/test.php
        var absolute: String? {
            // initialize url with the new absolute
            didSet {
                if let str = absolute {
                    url = NSURL(string: str)
                }
            }
        }
        
        /// The initialized url from absolute
        private var url: NSURL?
        
        /**
            The computed path from url
        
            :returns: Optional string like test.php for http://www.google.com/test.php
        */
        private var path: String? {
            return url?.path
        }
        
        /**
            The computed host from url
        
            :returns: Optional string like www.google.fr for http://www.google.com/test.php
        */
        private var host: String? {
            return url?.host
        }
        
        /**
            The computed port from url
        
            :returns: Optional string like 8888 for http://locahost:8888/test.php
        */
        private var port: String? {
            return url?.port?.stringValue
        }
        
        /**
            The computed scheme from url
        
            :returns: Optional string like http for http://www.google.com/test.php
        */
        private var scheme: String? {
            return url?.scheme
        }
        
        /// The boolean that test if the url is valid
        ///
        /// The url is valid if scheme and host has been set
        var isValid: Bool {
            if let s = scheme {
                if let h = host {
                    return true
                }
            }
            return false
        }
        
        /// The empty initializer
        init() {}
        
        func absoluteUrlWithPath(path: String?) -> String {
            // create task with elements
            var theFullUrl = ""
            if self.isValid {
                if let scheme = self.scheme {
                    if let host = self.host {
                        theFullUrl = scheme+"://"+host
                        if let port = self.port {
                            theFullUrl += ":"+port
                        }
                        if let rootPath = self.path {
                            if rootPath != "/" {
                                theFullUrl += "/"+rootPath
                            }
                            if let p = path {
                                theFullUrl.appendUrl(p)
                            }
                        }
                    }
                }
            } else {
                if let p = path {
                    theFullUrl += p
                }
            }
            return theFullUrl
        }
    }
    
    /// The optional client url
    public var url: URL?
    
    init() {
        config.delegate = self
        self.url = URL()
    }
    
    convenience init(rootUrl: String) {
        self.init()
        self.url?.absolute = rootUrl
        self.taskManager = FIONetworkTaskManager(client: self)
    }
    
    public typealias completionWithTuples = ((FIONetworkBridgeResponse?, NSError?)-> Void)
    public typealias functionSetting = (HTTPMethod?, completionWithTuples?) -> FIONetworkTask
    
    public subscript (path: String) -> functionSetting {
        get {
            var res: functionSetting = {
                (method: HTTPMethod?, completion: completionWithTuples?) in
                
                // create task with elements
                var theFullUrl = self.url?.absoluteUrlWithPath(path) ?? path
                
                var task = FIONetworkTask(method: method, url: theFullUrl)
                
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
    
    // MARK: -
    
    private func queueTask(task: FIONetworkTask) {
        taskManager.addTaskToQueue(task)
    }
    
}

extension FIONetworkClient {
    
    /// Return the url from the path
    ///
    /// :discuss:
    ///
    /// - If path and url is not nil, it return both appended
    /// - If path is nil, it return the url
    /// - If path and url are nil, it return an empty string
    private func absoluteUrlForPath(path: String?) -> String {
        var url: String = ""
        if let abso = self.url?.absoluteUrlWithPath(path) {
            url = abso
        } else if let p = path {
            url = p
        } else {
            url = ""
        }
        return url
    }
    
    public func downloadImage(url: String) -> UIImage {
        let url = NSURL(string: url)
        let data = NSData(contentsOfURL: url!)
        let image = UIImage(data: data!)
        return image!
    }
    
    public func get(params: [String: AnyObject]?, path: String?) -> FIONetworkTask {
        
        var url = self.absoluteUrlForPath(path)
        
        var task = FIONetworkTask(method: .GET(params), url: url)
        
        // insert task into the taskManager
        self.queueTask(task)
        
        return task
    }
    
    public func post(params: [String: AnyObject]?, path: String?) -> FIONetworkTask {
        
        var url = self.absoluteUrlForPath(path)
        
        var task = FIONetworkTask(method: .POST(params), url: url)
        
        // insert task into the taskManager
        self.queueTask(task)
        
        return task
    }
    
    public func upload(upload uploadable: Uploadable, path: String?, completionHandler: completionWithTuples?) {
        
        var url = self.absoluteUrlForPath(path)
        
        var task =
        
    }
    
    public func download(completionHandler: completionWithTuples?) {
        
    }
}