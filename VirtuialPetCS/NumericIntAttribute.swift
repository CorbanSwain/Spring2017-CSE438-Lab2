//
//  NumericIntAttribute.swift
//  VirtuialPetCS
//
//  Created by Corban Swain on 2/8/17.
//  Copyright © 2017 CorbanSwain. All rights reserved.
//

import UIKit

class NumericIntAttribute {
    
    public enum numericChange {
        case increased, decreased, maxedOut, minedOut, same
        
        static func provideChange(from oldValue: Int,
                                  to newValue: Int,
                                  max: Int,
                                  min: Int) -> (numericChange) {
            if oldValue < newValue { return .increased }
            else if oldValue > newValue { return .decreased }
            else if oldValue == min { return .minedOut }
            else if oldValue == max { return .maxedOut }
            else { return .same }
        }
    }
    
    var status = numericChange.same
    var title: String
    let MAX: Int = 100
    let MIN: Int = 0
    var value: Int = 0 {
        didSet {
            if value > MAX {
                value = MAX
            } else if value < MIN {
                value = MIN
            }
            status = numericChange.provideChange(from: oldValue, to: value, max: MAX, min: MIN)
        }
    }
    var valueFraction: CGFloat {
        get {
            return CGFloat(value - MIN) / CGFloat(MAX)
        }
    }
    
    var decrementValue: Int = 1
    var incrementValue: Int = 1
    
    init(title: String) {
        self.title = title
    }
    
    convenience init(title: String, incrementValue: Int, decrementValue: Int) {
        self.init(title: title)
        self.incrementValue = incrementValue
        self.decrementValue = decrementValue
    }
    
    func increment(by x: Int) {
        value += x
    }
    
    func increment() {
        value += incrementValue
    }
    
    func decrement(by x: Int) {
        value -= x
    }
    
    func decrement() {
        value -= decrementValue
    }
    
    func zero() {
        value = 0
    }
}
