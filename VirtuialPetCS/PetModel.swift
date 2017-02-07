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

class Pet {
    let species: animalSpecies
    
    static let MIN_JOY = 0, MAX_JOY = 100
    private(set) var joyLevel: Int = 0 {
        didSet {
            if joyLevel > Pet.MAX_JOY {
                joyLevel = Pet.MAX_JOY
            } else if joyLevel < Pet.MIN_JOY {
                joyLevel = Pet.MIN_JOY
            }
        }
    }
    var joyFraction: CGFloat {
        get {
            return CGFloat(joyLevel) / CGFloat(Pet.MAX_JOY)
        }
    }
    
    static let MIN_FOOD = 0, MAX_FOOD = 100
    private(set) var foodLevel: Int = 0 {
        didSet {
            if foodLevel > Pet.MAX_FOOD {
                foodLevel = Pet.MAX_FOOD
            } else if foodLevel < Pet.MIN_FOOD {
                foodLevel = Pet.MIN_FOOD
            }
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
    
    init(_ species: animalSpecies) {
        self.species = species
    }
    
    func playWith(by amount: Int = 10) {
        let playLeft = foodLevel * 5 / 4
        if amount > playLeft {
            joyLevel += playLeft
            foodLevel = 0
        }
        else {
            joyLevel += amount
            foodLevel -= amount * 4 / 5
        }
    }
    
    func feed(by amount: Int = 10) {
        foodLevel += amount
    }
}
