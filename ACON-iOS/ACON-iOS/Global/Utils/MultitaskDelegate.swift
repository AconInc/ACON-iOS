//
//  MultitaskDelegate.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/11/25.
//

import Foundation

class MulticastDelegate<T> {
    
    // MARK: - Multicast Design Pattern

    private let delegates: NSHashTable<AnyObject> = NSHashTable.weakObjects()
    
    func add(_ delegate: T) {
        delegates.add(delegate as AnyObject)
    }
    
    func remove(_ delegateToRemove: T) {
        delegates.allObjects.forEach { delegate in
            if delegate === delegateToRemove as AnyObject {
                delegates.remove(delegate)
            }
        }
    }
    
    func invoke(_ invocation: (T) -> Void) {
        delegates.allObjects.forEach { delegate in
            if let delegate = delegate as? T {
                invocation(delegate)
            }
        }
    }
}
