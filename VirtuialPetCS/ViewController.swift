//
//  ViewController.swift
//  VirtuialPetCS
//
//  Created by Corban Swain on 2/6/17.
//  Copyright © 2017 CorbanSwain. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var animalButtons: [UIBarButtonItem]!
    @IBOutlet weak var petImageView: UIImageView!
    @IBOutlet weak var petView: UIView!
    
    @IBOutlet weak var foodLevelLabel: UILabel!
    @IBOutlet weak var foodLevelDisplayView: DisplayView!
    
    @IBOutlet weak var happinessLabel: UILabel!
    @IBOutlet weak var happinessDisplayView: DisplayView!
    
    let pets = [Pet(.dog),
                Pet(.bird),
                Pet(.cat),
                Pet(.bunny),
                Pet(.fish)]
    var currentPet: Pet!
    var currentTag: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        foodLevelLabel.text = String(currentPet.foodLevel)
        foodLevelDisplayView.animateValue(to: currentPet.foodLevelFraction)
    }
    
    func updateHappinessView() {
        happinessLabel.text = String(currentPet.joyLevel)
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
}

