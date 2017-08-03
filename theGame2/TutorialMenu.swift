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
    
    
    
    var fire: SKSpriteNode!
    var earth: SKSpriteNode!
    var metal: SKSpriteNode!
    var wood: SKSpriteNode!
    var water: SKSpriteNode!
    
    
    
    override func didMove(to view: SKView) {
        
        self.anchorPoint = CGPoint(x: 0, y: 0)
        
    
        fire = childNode(withName: "fire") as! SKSpriteNode
        earth = childNode(withName: "earth") as! SKSpriteNode
        metal = childNode(withName: "metal") as! SKSpriteNode
        wood = childNode(withName: "wood") as! SKSpriteNode
        water = childNode(withName: "water") as! SKSpriteNode
        
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
        
    }
    
    
    
    
    
    
}
