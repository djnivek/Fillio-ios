//
//  MKQueue.swift
//  MKMiniLib
//
//  Created by Kévin MACHADO on 19/03/2015.
//  Copyright (c) 2015 Kévin MACHADO. All rights reserved.
//

import Foundation

public struct MKQueue<T> {
    
    var stack = [T]()
    
    public init() {}
    
    public func peek() -> T? {
        return stack.first
    }
    
    public mutating func add(item: T) {
        stack.append(item)
    }
}