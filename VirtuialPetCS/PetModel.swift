//
//  PetModel.swift
//  VirtuialPetCS
//
//  Created by Corban Swain on 2/7/17.
//  Copyright © 2017 CorbanSwain. All rights reserved.
//

import Foundation
import UIKit

public enum animalSpecies: String {
    case bird, bunny, cat, dog, fish
    
    var image: UIImage {
        get {
            switch self {
            case .bird:
                return #imageLiteral(resourceName: "bird")
            case .bunny:
                return #imageLiteral(resourceName: "bunny")
            case .cat:
                return #imageLiteral(resourceName: "cat")
            case .dog:
                return #imageLiteral(resourceName: "dog")
            case .fish:
                return #imageLiteral(resourceName: "fish")
            }
        }
    }
    
    var favoriteColor: UIColor {
        get {
            switch self {
            case .bird:
                return .green
            case .bunny:
                return .red
            case .cat:
                return .brown
            case .dog:
                return .cyan
            case .fish:
                return .orange
            }
        }
    }
}

enum valueStatus {
    case increased, decreased, maxedOut, minedOut, same
    
    static func provideStatus(from oldValue: Int,
                       to newValue: Int,
                       max: Int,
                       min: Int) -> (valueStatus) {
        if oldValue < newValue { return .increased }
        else if oldValue > newValue { return .decreased }
        else if oldValue == min { return .minedOut }
        else if oldValue == max { return .maxedOut }
        else { return .same }
    }
}

class Pet {
    let species: animalSpecies
    
    static let MIN_JOY = 0, MAX_JOY = 100
    var joyLevelStatus = valueStatus.minedOut
    private(set) var joyLevel: Int = 0 {
        didSet(oldJoyLevel) {
            if joyLevel > Pet.MAX_JOY {
                joyLevel = Pet.MAX_JOY
            } else if joyLevel < Pet.MIN_JOY {
                joyLevel = Pet.MIN_JOY
            }
            joyLevelStatus = valueStatus.provideStatus(from: oldJoyLevel,
                                                       to: joyLevel,
                                                       max: Pet.MAX_JOY,
                                                       min: Pet.MIN_JOY)
        }
    }
    var joyDecrement = 0;
    var joyFraction: CGFloat {
        get {
            return CGFloat(joyLevel) / CGFloat(Pet.MAX_JOY)
        }
    }
    
    static let MIN_FOOD = 0, MAX_FOOD = 100
    var foodLevelStatus = valueStatus.minedOut
    private(set) var foodLevel: Int = 0 {
        didSet(oldFoodLevel) {
            if foodLevel > Pet.MAX_FOOD {
                foodLevel = Pet.MAX_FOOD
            } else if foodLevel < Pet.MIN_FOOD {
                foodLevel = Pet.MIN_FOOD
            }
            foodLevelStatus = valueStatus.provideStatus(from: oldFoodLevel,
                                                        to: foodLevel,
                                                        max: Pet.MAX_FOOD,
                                                        min: Pet.MIN_FOOD)
            
        }
    }
    var foodLevelFraction: CGFloat {
        get {
            return CGFloat(foodLevel) / CGFloat(Pet.MAX_FOOD)
        }
    }
    
    lazy var image: UIImage = {
        return self.species.image
    }()
    
    private var metabolismTimer: Timer!
    private var didJustMetabolize = false
    var hasSpentFood: Bool {
        get {
            if didJustMetabolize {
                didJustMetabolize = false
                return true
            } else {
                return false
            }
        }
    }
    
    private var hungerTimer: Timer!
    private var didJustSuffer = false
    var hasSuffered: Bool {
        get {
            if didJustSuffer {
                didJustSuffer = false
                return true
            } else {
                return false
            }
        }
    }
    
    
    init(_ species: animalSpecies) {
        self.species = species
    }
    
    func startTimers() {
        metabolismTimer = Timer.scheduledTimer(timeInterval: 3,
                                               target: self,
                                               selector: #selector(metaboliseFood),
                                               userInfo: nil,
                                               repeats: true)
        hungerTimer = Timer.scheduledTimer(timeInterval: 8,
                                           target: self,
                                           selector: #selector(checkForHunger),
                                           userInfo: nil,
                                           repeats: true)

    }
    
    func playWith(by amount: Int = 10) {
        let playLeft = foodLevel * 5 / 4
        if amount > playLeft {
            joyLevel += playLeft
            foodLevel = 0
        }
        else {
            joyLevel += amount
            if joyLevelStatus != .maxedOut
            {
                foodLevel -= amount * 4 / 5
            } else {
                foodLevelStatus = .same
            }
        }
    }
    
    func feed(by amount: Int = 10) {
        if amount > 0 && metabolismTimer == nil { startTimers() }
        foodLevel += amount
    }
    
    @objc func metaboliseFood() {
        foodLevel -= 2
        didJustMetabolize = true
    }
    
    @objc func checkForHunger() {
        switch foodLevel {
        case 30...100:
            joyDecrement = 0
            return
        case 20..<30:
            joyDecrement = 2
        case 10..<20:
            joyDecrement = 5
        case 0..<10:
            joyDecrement = 8
        default:
            print("ERROR: foodLevel out of bounds")
            return
        }
        didJustSuffer = true
        joyLevel -= joyDecrement
    }
}
