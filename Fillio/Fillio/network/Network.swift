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
    
    var clients = [String:FIONetworkClient]()
    
    private init() {
        clients[FIONetwork.DEFAULT_CLIENT_ID] = FIONetworkClient()
    }
    
    /// This method create/get a client with a root url
    public class func clientWithRootUrl(rootUrl: String) -> FIONetworkClient {
        if let client = FIONetwork.instance.clients[rootUrl] {
            return client
        } else {
            FIONetwork.instance.clients[rootUrl] = FIONetworkClient(rootUrl: rootUrl)
            return FIONetwork.instance.clients[rootUrl]!
        }
    }
    
    public class var defaultClient: FIONetworkClient {
        return FIONetwork.instance.clients[DEFAULT_CLIENT_ID]!
    }
    
}