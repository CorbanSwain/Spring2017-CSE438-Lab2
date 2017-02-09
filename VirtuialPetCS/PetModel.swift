//
//  PetModel.swift
//  VirtuialPetCS
//
//  Created by Corban Swain on 2/7/17.
//  Copyright © 2017 CorbanSwain. All rights reserved.
//

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
                return .purple
            case .bunny:
                return .yellow
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

protocol PetMessageSender: class {
    func printPetMessage(_ message: String)
}

class Pet {
    let species: animalSpecies
    
    var joyLevel = NumericIntAttribute(title: "Happiness",
                                       incrementValue: 5,
                                       decrementValue: 0)
    var foodLevel = NumericIntAttribute(title: "Food Level",
                                        incrementValue: 5,
                                        decrementValue: 2)
    
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
    
    private var messageTimer: Timer!
    weak var delegate: PetMessageSender? {
        didSet { updatePetMessage() }
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
        
        messageTimer = Timer.scheduledTimer(timeInterval: 1,
                                           target: self,
                                           selector: #selector(updatePetMessage),
                                           userInfo: nil,
                                           repeats: true)

    }
    
    func playWith() {
        let playLeft = foodLevel.value * 5 / 4
        if joyLevel.incrementValue > playLeft {
            joyLevel.increment(by: playLeft)
            foodLevel.zero()
        }
        else {
            joyLevel.increment()
            if joyLevel.status != .maxedOut
            {
                foodLevel.decrement(by: joyLevel.incrementValue * 4 / 5)
            } else {
                foodLevel.status = .same
            }
        }
    }
    
    func feed() {
        if foodLevel.incrementValue > 0 && metabolismTimer == nil { startTimers() }
        foodLevel.increment()
    }
    
    @objc func metaboliseFood() {
        foodLevel.decrement()
        didJustMetabolize = true
    }
    
    @objc func checkForHunger() {
        switch foodLevel.value {
        case 30...100:
            joyLevel.decrementValue = 0
            return
        case 20..<30:
            joyLevel.decrementValue = 2
        case 10..<20:
            joyLevel.decrementValue = 5
        case 0..<10:
            joyLevel.decrementValue = 8
        default:
            print("ERROR: foodLevel out of bounds")
            return
        }
        didJustSuffer = true
        joyLevel.decrement()
    }
    
    @objc func updatePetMessage() {
        if !didJustMetabolize {
            if foodLevel.value < 20 {
                if foodLevel.value < 10 {
                    delegate?.printPetMessage("Feed me!")
                } else {
                    delegate?.printPetMessage("Food?")
                }
            } else  if foodLevel.value > 65 && joyLevel.value < 20 {
                delegate?.printPetMessage("Lets Play!")
            } else {
                delegate?.printPetMessage("")
            }
        }
    }
    
    
}
