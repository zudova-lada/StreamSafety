//
//  ISS-Collection.swift
//  StramSafetyCollection
//
//  Created by Лада on 12/11/2019.
//  Copyright © 2019 Лада. All rights reserved.
//

import UIKit

class ISSCollection<T> {
    
    private var array: [T] = []
    private let queue = DispatchQueue(label: "MyQueue.queue", attributes: .concurrent)
    
    var count: Int {
        var count = 0
        
        self.queue.sync {
            count = self.array.count
        }
        
        return count
    }
    
    func AppendElement(element: T) {
        self.queue.async(flags: .barrier) {
            self.array.append(element)
        }
    }

    func RemoveElem(at index: Int) {
        self.queue.async(flags: .barrier) {
            self.array.remove(at: index)
        }
    }
    
    subscript(index: Int) -> T {
        set {
            self.queue.async(flags:.barrier) {
                self.array[index] = newValue
            }
        }
        get {
            var element: T!
            self.queue.sync {
                element = self.array[index]
            }
            
            return element
        }
    }
}
