//
//  HTTPClientQueue.swift
//  Fillio
//
//  Created by Kévin MACHADO on 09/03/2015.
//  Copyright (c) 2015 Kévin MACHADO. All rights reserved.
//

import Foundation

class FIONetworkHTTPClientQueue {
    var stack: [(HTTPRequest -> HTTPResponse)]
    
    init() {
        self.stack = []
    }
}