//
//  MainMenu.swift
//  theGame2
//
//  Created by Tyler Goodwyn on 7/31/17.
//  Copyright © 2017 Tyler Goodwyn. All rights reserved.
//

import Foundation
import SpriteKit

class TutorialScene: SKScene {
    
    
    
    var fire: MSButtonNode!
    var earth: MSButtonNode!
    var metal: MSButtonNode!
    var wood: MSButtonNode!
    var water: MSButtonNode!
    
    
    
    override func didMove(to view: SKView) {
        
        self.anchorPoint = CGPoint(x: 0, y: 0)
        
    
        fire = childNode(withName: "fire") as! MSButtonNode
        earth = childNode(withName: "earth") as! MSButtonNode
        metal = childNode(withName: "metal") as! MSButtonNode
        wood = childNode(withName: "wood") as! MSButtonNode
        water = childNode(withName: "water") as! MSButtonNode
        
        let distance: CGFloat = 350
        
        wood.position =
            CGPoint(x: size.width / 2,
                    y: size.height / 2  + distance - 50)
        fire.position =
            CGPoint(x: wood.position.x + distance * sin(54 * .pi / 180),
                    y: wood.position.y - distance * cos(54 * .pi / 180))
        earth.position =
            CGPoint(x: fire.position.x - distance * cos(72 * .pi / 180),
                    y: fire.position.y - distance * sin(72 * .pi / 180))
        metal.position =
            CGPoint(x: earth.position.x - distance,
                    y: earth.position.y)
        water.position =
            CGPoint(x: metal.position.x - distance * sin(18 * .pi / 180),
                    y: metal.position.y + distance * cos(18 * .pi / 180))
        
        
        wood.selectedHandler = {
            SKTransition.flipVertical(withDuration: 0)
            
            let tutorial = WoodTutorial1(fileNamed: "WoodTutorial1")
            tutorial?.scaleMode = .aspectFill
            view.presentScene(tutorial)
        }
        
        fire.selectedHandler = {
            SKTransition.flipVertical(withDuration: 0)
            
            let tutorial = WoodTutorial1(fileNamed: "WoodTutorial1")
            tutorial?.scaleMode = .aspectFill
            view.presentScene(tutorial)
        }
        
        earth.selectedHandler = {
            SKTransition.flipVertical(withDuration: 0)
            
            let tutorial = WoodTutorial1(fileNamed: "WoodTutorial1")
            tutorial?.scaleMode = .aspectFill
            view.presentScene(tutorial)
        }
        
        metal.selectedHandler = {
            SKTransition.flipVertical(withDuration: 0)
            
            let tutorial = WoodTutorial1(fileNamed: "WoodTutorial1")
            tutorial?.scaleMode = .aspectFill
            view.presentScene(tutorial)
        }
        
        water.selectedHandler = {
            SKTransition.flipVertical(withDuration: 0)
            
            let tutorial = WoodTutorial1(fileNamed: "WoodTutorial1")
            tutorial?.scaleMode = .aspectFill
            view.presentScene(tutorial)
        }
        
    }
    
    
    
    
    
    
}
