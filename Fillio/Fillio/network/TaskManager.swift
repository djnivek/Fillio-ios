//
//  TaskManager.swift
//  Fillio
//
//  Created by Kévin MACHADO on 25/03/2015.
//  Copyright (c) 2015 Kévin MACHADO. All rights reserved.
//

import Foundation

protocol FIONetworkTaskManagerDelegate {
    func didReceiveResponse(response: NSURLResponse, forTask: NSURLSessionTask)
    func didUploadProgress(progress:
}

class FIONetworkTaskManager {
    
    /// stack of client tasks
    var tasks = [NSURLSessionTask]()
    
    
}