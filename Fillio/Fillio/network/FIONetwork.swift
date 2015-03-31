//
//  FIONetwork.swift
//  Fillio
//
//  Created by Kévin MACHADO on 23/03/2015.
//  Copyright (c) 2015 Kévin MACHADO. All rights reserved.
//

import Foundation

public class FIONetwork {
    
    private class var DEFAULT_CLIENT_ID: String {
        return "-the-default-client-2201"
    }
    
    private class var instance: FIONetwork {
        struct Singleton {
            static var instance = FIONetwork()
        }
        return Singleton.instance
    }
    
    var clients = [String:FIONetworkHTTPClient]()
    
    private init() {
        clients[FIONetwork.DEFAULT_CLIENT_ID] = FIONetworkHTTPClient()
    }
    
    public class func clientWithRootUrl(rootUrl: NSString) -> FIONetworkHTTPClient {
        if let client = FIONetwork.instance.clients[rootUrl] {
            return client
        } else {
            if let url = NSURL(string: rootUrl) {
                FIONetwork.instance.clients[rootUrl] = FIONetworkHTTPClient(url: url)
            }
        }
        return FIONetworkHTTPClient()
    }
    
    public class var defaultClient: FIONetworkHTTPClient {
        return FIONetwork.instance.clients[DEFAULT_CLIENT_ID]!
    }
    
}