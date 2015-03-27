//
//  HTTPTask.swift
//  Fillio
//
//  Created by Kévin MACHADO on 25/03/2015.
//  Copyright (c) 2015 Kévin MACHADO. All rights reserved.
//

import Foundation

class FIONetworkTask {
    
    private(set) var param: String
    
    private(set) var url: String
    
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
    
}