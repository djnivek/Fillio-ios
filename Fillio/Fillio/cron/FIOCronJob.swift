//
//  FIOCronJob.swift
//  Fillio
//
//  Created by Kévin MACHADO on 03/04/2015.
//  Copyright (c) 2015 Kévin MACHADO. All rights reserved.
//

import Foundation

class FIOCronJob {
    
    /// The function that take a param `Any?` and return and `Any?`
    typealias anyAnyFunction = ((AnyObject?) -> AnyObject?)
    
    /// The function that do the job
    ///
    /// The function could, if needed, get a param `Any` and return and `Any`
    var methodAction: anyAnyFunction?
    
}