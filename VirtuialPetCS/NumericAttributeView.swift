//
//  StatusView.swift
//  VirtuialPetCS
//
//  Created by Corban Swain on 2/8/17.
//  Copyright © 2017 CorbanSwain. All rights reserved.
//

import UIKit

class NumericAttributeView: UIView {
    
    @IBOutlet weak var displayView: DisplayView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    var displayViewColor = UIColor.darkGray
    
    var attribute: NumericIntAttribute! {
        didSet {
            titleLabel.text = attribute.title
        }
    }

    
    func update(animate: Bool = true) {
        valueLabel.text = String(attribute.value)
        if animate {
            if let flashColor = attribute.status.signalColor {
                displayView.color = flashColor
            }
            displayView.animateColor(to: displayViewColor)
            displayView.animateValue(to: attribute.valueFraction)
        } else {
            displayView.color = displayViewColor
            displayView.value = attribute.valueFraction
        }
    }
}

extension NumericIntAttribute.numericChange {
    var signalColor: UIColor? {
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

extension DisplayView {
    public func animateColor(to color: UIColor) {
        UIView.animate(withDuration: 0.5, animations: { self.color = color })
    }
}

extension UIView {
    
    @discardableResult   // 1
    func fromNib<T : UIView>() -> T? {   // 2
        guard let view = Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?[0] as? T else {    // 3
            // xib not loaded, or it's top view is of the wrong type
            return nil
        }
        self.addSubview(view)     // 4
        view.translatesAutoresizingMaskIntoConstraints = false   // 5
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view":self]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view":self]))
        
        return view   // 7
    }
}
