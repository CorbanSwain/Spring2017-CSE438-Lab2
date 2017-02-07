//
//  ToddsView.swift
//  VirtuialPetCS
//
//  Created by Corban Swain on 2/6/17.
//  Copyright © 2017 CorbanSwain. All rights reserved.
//

import UIKit

class ToddsView: UIView {


    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        let bounds = self.bounds
        UIColor.blue.set()
        UIRectFill(bounds)
        
        let myShape = CGRect(x: 40, y:30, width: 20, height: 100)
        UIColor.red.set()
        UIRectFill(myShape)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Todd's View touching!")
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Todd's moving!")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Todd's done!")
    }
}
