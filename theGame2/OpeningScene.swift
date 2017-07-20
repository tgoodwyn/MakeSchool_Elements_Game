
//  GameScene.swift
//  theGame
//
//  Created by Tyler Goodwyn on 7/16/17.
//  Copyright © 2017 Tyler Goodwyn. All rights reserved.
//

import SpriteKit
import Foundation

class OpeningScene: SKScene, SKPhysicsContactDelegate {
    

    var objectGrabbed: SKShapeNode!
    var objectMovable:Bool = true
    
    // large, selectable pentagon nodes
    var fireNode: SKShapeNode!
    var waterNode: SKShapeNode!
    var earthNode: SKShapeNode!
    var metalNode: SKShapeNode!
    var woodNode: SKShapeNode!
    
    // smaller pentagon nodes
    var top: SKShapeNode!
    var sideRight: SKShapeNode!
    var sideLeft: SKShapeNode!
    var bottomRight: SKShapeNode!
    var bottomLeft: SKShapeNode!
    
    // center of node positions
    var fireCenter: CGPoint!
    var woodCenter: CGPoint!
    var earthCenter: CGPoint!
    var metalCenter: CGPoint!
    var waterCenter: CGPoint!
    
    var smallTop: CGPoint!
    var smallSideRight: CGPoint!
    var smallSideLeft: CGPoint!
    var smallBottomRight: CGPoint!
    var smallBottomLeft: CGPoint!
    
    func makeCircle(location: CGPoint, color: UIColor, name: String) {
        
        let circle = SKShapeNode(circleOfRadius: 25 ) // Size of Circle = Radius setting.
        circle.position = location  //touch location passed from touchesBegan.
        circle.name = name
        circle.strokeColor = UIColor.black
        circle.glowWidth = 1.0
        circle.fillColor = color
        circle.zPosition = 1
        
        circle.physicsBody = SKPhysicsBody(circleOfRadius: 25)
        circle.physicsBody?.affectedByGravity = false
        circle.physicsBody?.contactTestBitMask = 1
        circle.physicsBody?.categoryBitMask = 1
        circle.physicsBody?.collisionBitMask = 0
        
        self.addChild(circle)
        print("circle hath been maded")
    }

    override func didMove(to view: SKView) {
        woodCenter = CGPoint(x: size.width / 2, y: size.height / 2  + 200)
        fireCenter = CGPoint(x: woodCenter.x + 200 * sin(54 * .pi / 180), y: woodCenter.y - 200 * cos(54 * .pi / 180))
        earthCenter = CGPoint(x: fireCenter.x - 200 * cos(72 * .pi / 180), y: fireCenter.y - 200 * sin(72 * .pi / 180))
        metalCenter = CGPoint(x: earthCenter.x - 200, y: earthCenter.y)
        waterCenter = CGPoint(x: metalCenter.x - 200 * sin(18 * .pi / 180), y: metalCenter.y + 200 * cos(18 * .pi / 180))
        
        makeCircle(location: woodCenter, color: .green, name: "wood")
        makeCircle(location: fireCenter, color: .red, name: "fire")
        makeCircle(location: earthCenter, color: .brown, name: "earth")
        makeCircle(location: metalCenter, color: .black, name: "metal")
        makeCircle(location: waterCenter, color: .blue, name: "water")

    }
    
    override func update(_ currentTime: TimeInterval) {
    
        
    }

    func didBegin(_ contact: SKPhysicsContact) {
        
        objectMovable = false
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        objectMovable = true
        let touch = touches.first!
        let location = touch.location(in: self)
        let nodeAtPoint = atPoint(location)
        if nodeAtPoint.name == "greenCircle" || nodeAtPoint.name == "redCircle" || nodeAtPoint.name == "yellowCircle" || nodeAtPoint.name == "blackCircle" || nodeAtPoint.name == "blueCircle" {
            objectGrabbed = atPoint(location) as! SKShapeNode
        } else {
            objectGrabbed = nil
        }
        
        physicsWorld.contactDelegate = self
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if objectGrabbed != nil {

            if objectMovable == true {
                objectGrabbed.position = (touches.first?.location(in: self))!
            }
            
        }
        
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
      
    }


}
