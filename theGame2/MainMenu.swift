//
//  MainMenu.swift
//  theGame2
//
//  Created by Tyler Goodwyn on 7/31/17.
//  Copyright © 2017 Tyler Goodwyn. All rights reserved.
//

import Foundation
import SpriteKit

class MainMenu: SKScene {
    
    var buttonNode: MSButtonNode!
    
    var fire: SKSpriteNode!
    var earth: SKSpriteNode!
    var metal: SKSpriteNode!
    var wood: SKSpriteNode!
    var water: SKSpriteNode!
    
    var tutorialButton: MSButtonNode!
    
    override func didMove(to view: SKView) {
        
        self.anchorPoint = CGPoint(x: 0, y: 0)
        tutorialButton = childNode(withName: "tutorialButton") as! MSButtonNode
        buttonNode = childNode(withName: "buttonNode") as! MSButtonNode
        fire = childNode(withName: "fire") as! SKSpriteNode
        earth = childNode(withName: "earth") as! SKSpriteNode
        metal = childNode(withName: "metal") as! SKSpriteNode
        wood = childNode(withName: "wood") as! SKSpriteNode
        water = childNode(withName: "water") as! SKSpriteNode
        
        let distance: CGFloat = 350
        
        wood.position =
            CGPoint(x: size.width / 2,
                    y: size.height / 2  + distance - 100)
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
        
        tutorialButton.selectedHandler = {
            
            SKTransition.flipVertical(withDuration: 0)
            
            let tutorial = TutorialScene(fileNamed: "TutorialMenu")
            tutorial?.scaleMode = .aspectFill
            view.presentScene(tutorial)
        }
        
        buttonNode.selectedHandler = {
            
            SKTransition.flipVertical(withDuration: 0)
            
            let tutorial = GemScene(fileNamed: "GemScene")
            tutorial?.scaleMode = .aspectFill
            view.presentScene(tutorial)
        }
    }
    
    
    
    
    
    
    
}
