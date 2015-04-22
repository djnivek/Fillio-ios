//
//  NetworkBridgeResponse.swift
//  Fillio
//
//  Created by Kévin MACHADO on 21/04/2015.
//  Copyright (c) 2015 Kévin MACHADO. All rights reserved.
//

public class FIONetworkBridgeResponse {
    
    public var string: String?
    public var object: FIONetworkResultObject?
    
    public init(string: String?, object: FIONetworkResultObject?) {
        self.string = string ?? object?.description
        self.object = object
    }
    
}