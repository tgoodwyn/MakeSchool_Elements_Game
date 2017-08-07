//
//  ElementChange.swift
//  theGame2
//
//  Created by Tyler Goodwyn on 8/7/17.
//  Copyright © 2017 Tyler Goodwyn. All rights reserved.
//

import Foundation
import SpriteKit

class ElementChange: SKLabelNode {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(position: CGPoint, text: String) {
        super.init()
        self.position = position
        self.text = text
        self.fontColor = .white
        self.isHidden = true
    }
}
