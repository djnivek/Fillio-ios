//
//  HTTPClientQueue.swift
//  Fillio
//
//  Created by Kévin MACHADO on 09/03/2015.
//  Copyright (c) 2015 Kévin MACHADO. All rights reserved.
//

import Foundation
import MKMiniLib

struct FIONetworkHTTPClientQueue {
    
    typealias CompletionHandler = () -> ()
    
    typealias Request = (HTTPRequest, CompletionHandler)
    private var queue = MKQueue<Request>()
    
    private var next: Request? {
        return queue.peek()
    }
    
    mutating func append(request: HTTPRequest, withCompletion completion: CompletionHandler) {
        queue.add((request, completion))
    }
}