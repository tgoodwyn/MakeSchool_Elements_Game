//
//  ReferenceScene.swift
//  theGame2
//
//  Created by Tyler Goodwyn on 7/26/17.
//  Copyright © 2017 Tyler Goodwyn. All rights reserved.
//

import Foundation
import SpriteKit

class ReferenceScene: SKScene {
    
    var supportNode1: SKShapeNode!
    var supportNode2: SKShapeNode!
    var supportNode3: SKShapeNode!
    var supportNode4: SKShapeNode!
    var supportNode5: SKShapeNode!
    
    var attackNode1: SKShapeNode!
    var attackNode2: SKShapeNode!
    var attackNode3: SKShapeNode!
    var attackNode4: SKShapeNode!
    var attackNode5: SKShapeNode!
    
    var arrowSupport1: SKSpriteNode!
    var arrowSupport2: SKSpriteNode!
    var arrowSupport3: SKSpriteNode!
    var arrowSupport4: SKSpriteNode!
    var arrowSupport5: SKSpriteNode!
    
    var arrowAttack1: SKSpriteNode!
    var arrowAttack2: SKSpriteNode!
    var arrowAttack3: SKSpriteNode!
    var arrowAttack4: SKSpriteNode!
    var arrowAttack5: SKSpriteNode!
    
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0, y:0)
        supportNode1 = childNode(withName: "supportNode1") as! SKShapeNode!
        supportNode2 = childNode(withName: "supportNode2") as! SKShapeNode!
        supportNode3 = childNode(withName: "supportNode3") as! SKShapeNode!
        supportNode4 = childNode(withName: "supportNode4") as! SKShapeNode!
        supportNode5 = childNode(withName: "supportNode5") as! SKShapeNode!
        
        attackNode1 = childNode(withName: "attackNode1") as! SKShapeNode!
        attackNode2 = childNode(withName: "attackNode2") as! SKShapeNode!
        attackNode3 = childNode(withName: "attackNode3") as! SKShapeNode!
        attackNode4 = childNode(withName: "attackNode4") as! SKShapeNode!
        attackNode5 = childNode(withName: "attackNode5") as! SKShapeNode!
     
        arrowSupport1 = childNode(withName: "arrowSupport1") as! SKSpriteNode
        arrowSupport2 = childNode(withName: "arrowSupport2") as! SKSpriteNode
        arrowSupport3 = childNode(withName: "arrowSupport3") as! SKSpriteNode
        arrowSupport4 = childNode(withName: "arrowSupport4") as! SKSpriteNode
        arrowSupport5 = childNode(withName: "arrowSupport5") as! SKSpriteNode
        
        arrowAttack1 = childNode(withName: "arrowAttack1") as! SKSpriteNode
        arrowAttack2 = childNode(withName: "arrowAttack2") as! SKSpriteNode
        arrowAttack3 = childNode(withName: "arrowAttack3") as! SKSpriteNode
        arrowAttack4 = childNode(withName: "arrowAttack4") as! SKSpriteNode
        arrowAttack5 = childNode(withName: "arrowAttack5") as! SKSpriteNode
        
   
        
        let distance: CGFloat = 275
        
        supportNode1.position =
            CGPoint(x: size.width / 4,
                    y: size.height / 2  + distance - 100)
        supportNode2.position =
            CGPoint(x: supportNode1.position.x + distance * sin(54 * .pi / 180),
                    y: supportNode1.position.y - distance * cos(54 * .pi / 180))
        supportNode3.position =
            CGPoint(x: supportNode2.position.x - distance * cos(72 * .pi / 180),
                    y: supportNode2.position.y - distance * sin(72 * .pi / 180))
        supportNode4.position =
            CGPoint(x: supportNode3.position.x - distance,
                    y: supportNode3.position.y)
        supportNode5.position =
            CGPoint(x: supportNode4.position.x - distance * sin(18 * .pi / 180),
                    y: supportNode4.position.y + distance * cos(18 * .pi / 180))
        
        attackNode1.position =
            CGPoint(x: size.width * 3 / 4,
                    y: size.height / 2 + distance - 100)
        attackNode2.position =
            CGPoint(x: attackNode1.position.x + distance * sin(54 * .pi / 180),
                    y: attackNode1.position.y - distance * cos(54 * .pi / 180))
        attackNode3.position =
            CGPoint(x: attackNode2.position.x - distance * cos(72 * .pi / 180),
                    y: attackNode2.position.y - distance * sin(72 * .pi / 180))
        attackNode4.position =
            CGPoint(x: attackNode3.position.x - distance,
                    y: attackNode3.position.y)
        attackNode5.position =
            CGPoint(x: attackNode4.position.x - distance * sin(18 * .pi / 180),
                    y: attackNode4.position.y + distance * cos(18 * .pi / 180))
        
        // Support arrow positions and rotations
        arrowSupport1.position = CGPoint(x: supportNode1.position.x + ((supportNode2.position.x - supportNode1.position.x) / 2 ), y: supportNode2.position.y + ((supportNode1.position.y - supportNode2.position.y) / 2))
        arrowSupport1.zRotation = (-45 * CGFloat.pi) / 180
        arrowSupport2.position = CGPoint(x: supportNode2.position.x - ((supportNode2.position.x - supportNode3.position.x) / 2 ), y: supportNode2.position.y - ((supportNode2.position.y - supportNode3.position.y) / 2))
        arrowSupport2.zRotation = (-135 * CGFloat.pi) / 180
        arrowSupport3.position = CGPoint(x: supportNode4.position.x + ((supportNode3.position.x - supportNode4.position.x) / 2 ), y: supportNode4.position.y)
        arrowSupport3.zRotation = (-180 * CGFloat.pi) / 180
        arrowSupport4.position = CGPoint(x: supportNode5.position.x + ((supportNode4.position.x - supportNode5.position.x) / 2 ), y: supportNode5.position.y - ((supportNode5.position.y - supportNode4.position.y) / 2))
        arrowSupport4.zRotation = (135 * CGFloat.pi) / 180
        arrowSupport5.position = CGPoint(x: supportNode5.position.x + ((supportNode1.position.x - supportNode5.position.x) / 2 ), y: supportNode5.position.y + ((supportNode1.position.y - supportNode5.position.y) / 2))
        arrowSupport5.zRotation = (45 * CGFloat.pi) / 180
        
        // Attack arrows positions and rotations
        arrowAttack1.position = CGPoint(x: attackNode1.position.x + ((attackNode2.position.x - attackNode1.position.x) / 2 ), y: attackNode2.position.y + ((attackNode1.position.y - attackNode2.position.y) / 2))
        arrowAttack1.zRotation = (-45 * CGFloat.pi) / 180
        arrowAttack2.position = CGPoint(x: attackNode2.position.x - ((attackNode2.position.x - attackNode3.position.x) / 2 ), y: attackNode2.position.y - ((attackNode2.position.y - attackNode3.position.y) / 2))
        arrowAttack2.zRotation = (-135 * CGFloat.pi) / 180
        arrowAttack3.position = CGPoint(x: attackNode4.position.x + ((attackNode3.position.x - attackNode4.position.x) / 2 ), y: attackNode4.position.y)
        arrowAttack3.zRotation = (-180 * CGFloat.pi) / 180
        arrowAttack4.position = CGPoint(x: attackNode5.position.x + ((attackNode4.position.x - attackNode5.position.x) / 2 ), y: attackNode5.position.y - ((attackNode5.position.y - attackNode4.position.y) / 2))
        arrowAttack4.zRotation = (135 * CGFloat.pi) / 180
        arrowAttack5.position = CGPoint(x: attackNode5.position.x + ((attackNode1.position.x - attackNode5.position.x) / 2 ), y: attackNode5.position.y + ((attackNode1.position.y - attackNode5.position.y) / 2))
        arrowAttack5.zRotation = (45 * CGFloat.pi) / 180
        
        
    }
    
}
