//
//  ViewController.swift
//  VirtuialPetCS
//
//  Created by Corban Swain on 2/6/17.
//  Copyright © 2017 CorbanSwain. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var petImageView: UIImageView!
    @IBOutlet weak var petView: UIView!
    
    @IBOutlet weak var foodLevelLabel: UILabel!
    @IBOutlet weak var foodLevelDisplayView: DisplayView!
    
    @IBOutlet weak var happinessLabel: UILabel!
    @IBOutlet weak var happinessDisplayView: DisplayView!
    
    @IBOutlet var animalButtons: [UIBarButtonItem]!
    
    let pets = [Pet(.dog),
                Pet(.bird),
                Pet(.cat),
                Pet(.bunny),
                Pet(.fish)]
    var currentPet: Pet!
    var currentTag: Int = 0
    
    var checkTimer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkTimer = Timer.scheduledTimer(timeInterval: 1,
                                          target: self,
                                          selector: #selector(ViewController.checkPetChanges),
                                          userInfo: nil,
                                          repeats: true)
        
        for button in animalButtons {
            button.tintColor = .gray
            button.action = #selector(ViewController.changePetView(sender:))
        }
        currentPet = pets[currentTag]
        animalButtons[currentTag].tintColor = .blue
        updateAllPetView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func feedButtonPressed(_ sender: UIButton) {
        currentPet.feed(by: 5)
        updateFoodView()
    }
    
    @IBAction func playButtonPressed(_ sender: UIButton) {
        currentPet.playWith(by: 5)
        updateHappinessView()
        updateFoodView()
    }
    
    func updatePetPhoto() {
        petImageView.image = currentPet.image
        petView.backgroundColor = currentPet.species.favoriteColor
    }
    
    func updateFoodView() {
        if let newColor = currentPet.foodLevelStatus.color {
            foodLevelDisplayView.color = newColor
        }
        foodLevelLabel.text = String(currentPet.foodLevel)
        switch currentPet.foodLevel {
        case 0...5:
            foodLevelDisplayView.animateColor(to: .red)
        case 95...100:
            foodLevelDisplayView.animateColor(to: .green)
        default:
            foodLevelDisplayView.animateColor(to: .gray)
        }
        foodLevelDisplayView.animateValue(to: currentPet.foodLevelFraction)
    }
    
    func updateHappinessView() {
        if let newColor = currentPet.joyLevelStatus.color {
            happinessDisplayView.color = newColor
        }
        happinessLabel.text = String(currentPet.joyLevel)
        switch currentPet.joyLevel {
        case 0...5:
            happinessDisplayView.animateColor(to: .red)
        case 95...100:
            happinessDisplayView.animateColor(to: .green)
        default:
            happinessDisplayView.animateColor(to: .gray)
        }
        happinessDisplayView.animateValue(to: currentPet.joyFraction)
    }
    
    func updateAllPetView() {
        updateHappinessView()
        updateFoodView()
        updatePetPhoto()
    }
    
    func changePetView(sender: UIBarButtonItem) {
        animalButtons[currentTag].tintColor = .gray
        currentTag = sender.tag
        currentPet = pets[currentTag]
        sender.tintColor = .blue
        updateAllPetView()
    }
    
    func checkPetChanges() {
        if currentPet.hasSpentFood {
            updateFoodView()
        }
        if currentPet.hasSuffered {
            updateHappinessView()
        }
    }
}

extension valueStatus {
    var color: UIColor? {
        switch self {
        case .decreased,
             .minedOut:
            return .red
        case .increased,
             .maxedOut:
            return .green
        case .same:
            return nil
        }
    }
}

