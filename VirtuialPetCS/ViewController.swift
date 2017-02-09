//
//  ViewController.swift
//  VirtuialPetCS
//
//  Created by Corban Swain on 2/6/17.
//  Copyright © 2017 CorbanSwain. All rights reserved.
//

import UIKit

class ViewController: UIViewController, PetMessageSender {

    @IBOutlet weak var petImageView: UIImageView!
    @IBOutlet weak var petView: UIView!
    
    @IBOutlet weak var foodLevelSuperview: UIView!
    @IBOutlet weak var happinessSuperview: UIView!
    
    @IBOutlet weak var petMessageLabel: UILabel!
    
    var foodLevelView: NumericAttributeView!
    var happinessView: NumericAttributeView!
    
    @IBOutlet var animalButtons: [UIBarButtonItem]!
    
    let pets = [Pet(.dog),
                Pet(.bird),
                Pet(.cat),
                Pet(.bunny),
                Pet(.fish)]
    
    var currentPet: Pet! {
        didSet(oldPet) {
            if let pet = oldPet { pet.delegate = nil }
            foodLevelView.attribute = currentPet.foodLevel
            happinessView.attribute = currentPet.joyLevel
            currentPet.delegate = self
            let favColor = currentPet.species.favoriteColor.withAlphaComponent(0.3)
            foodLevelView.displayViewColor = favColor
            happinessView.displayViewColor = favColor
        }
    }
    var currentTag: Int = 0 {
        didSet(oldTag) {
            currentPet = pets[currentTag]
            animalButtons[oldTag].tintColor = .gray
            animalButtons[currentTag].tintColor = .blue
        }
    }
    
    var checkTimer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        petMessageLabel.text = ""
        checkTimer = Timer.scheduledTimer(timeInterval: 1,
                                          target: self,
                                          selector: #selector(ViewController.checkPetChanges),
                                          userInfo: nil,
                                          repeats: true)
        
        for button in animalButtons {
            button.tintColor = .gray
            button.action = #selector(ViewController.changePetView(sender:))
        }
        
        foodLevelView = Bundle.main.loadNibNamed("NumericAttributeView", owner: self, options: nil)?.first as! NumericAttributeView?
        print("...done")
        
        foodLevelSuperview.addSubview(foodLevelView as UIView)
        foodLevelView.translatesAutoresizingMaskIntoConstraints = false
        foodLevelSuperview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view":foodLevelView]))
        foodLevelSuperview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view":foodLevelView]))
        
        
        happinessView = Bundle.main.loadNibNamed("NumericAttributeView", owner: self, options: nil)?.first as! NumericAttributeView
        happinessSuperview.addSubview(happinessView as UIView)
        happinessView.translatesAutoresizingMaskIntoConstraints = false
        happinessSuperview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": happinessView]))
        happinessSuperview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": happinessView]))
        
        currentPet = pets[currentTag]
        updateAllPetView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func feedButtonPressed(_ sender: UIButton) {
        currentPet.feed()
        foodLevelView.update()
    }
    
    @IBAction func playButtonPressed(_ sender: UIButton) {
        currentPet.playWith()
        happinessView.update()
        foodLevelView.update()
    }
    
    func updatePetPhoto() {
        petImageView.image = currentPet.image
        petView.backgroundColor = currentPet.species.favoriteColor
    }
    
    
    func updateAllPetView(animate: Bool = true) {
        happinessView.update(animate: animate)
        foodLevelView.update(animate: animate)
        updatePetPhoto()
    }
    
    func changePetView(sender: UIBarButtonItem) {
        currentTag = sender.tag
        updateAllPetView(animate: false)
    }
    
    func checkPetChanges() {
        if currentPet.hasSpentFood {
            foodLevelView.update()
        }
        if currentPet.hasSuffered {
            happinessView.update()
        }
    }
    
    func printPetMessage(_ message: String) {
        petMessageLabel.text = message
    }
}
