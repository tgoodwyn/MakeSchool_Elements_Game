
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
    }

    override func didMove(to view: SKView) {
        
        let distance1: CGFloat = 150
        let distance2: CGFloat = 90
        
        woodCenter = CGPoint(x: size.width / 2, y: size.height * 2 / 3  + distance1 - 15)
        fireCenter = CGPoint(x: woodCenter.x + distance1 * sin(54 * .pi / 180), y: woodCenter.y - distance1 * cos(54 * .pi / 180))
        earthCenter = CGPoint(x: fireCenter.x - distance1 * cos(72 * .pi / 180), y: fireCenter.y - distance1 * sin(72 * .pi / 180))
        metalCenter = CGPoint(x: earthCenter.x - distance1, y: earthCenter.y)
        waterCenter = CGPoint(x: metalCenter.x - distance1 * sin(18 * .pi / 180), y: metalCenter.y + distance1 * cos(18 * .pi / 180))
        
        
        smallTop = CGPoint(x: size.width / 2, y: size.height * 1 / 3 + 15)
        smallSideRight = CGPoint(x: smallTop.x + distance2 * sin(54 * .pi / 180), y: smallTop.y - distance2 * cos(54 * .pi / 180))
        smallBottomRight = CGPoint(x: smallSideRight.x - distance2 * cos(72 * .pi / 180), y: smallSideRight.y - distance2 * sin(72 * .pi / 180))
        smallBottomLeft = CGPoint(x: smallBottomRight.x - distance2, y: smallBottomRight.y)
        smallSideLeft = CGPoint(x: smallBottomLeft.x - distance2 * sin(18 * .pi / 180), y: smallBottomLeft.y + distance2 * cos(18 * .pi / 180))
        
        
        
        makeCircle(location: woodCenter, color: .green, name: "wood")
        makeCircle(location: fireCenter, color: .red, name: "fire")
        makeCircle(location: earthCenter, color: .brown, name: "earth")
        makeCircle(location: metalCenter, color: .black, name: "metal")
        makeCircle(location: waterCenter, color: .blue, name: "water")

        makeCircle(location: smallTop, color: .green, name: "woodSmall")
        makeCircle(location: smallSideRight, color: .red, name: "fireSmall")
        makeCircle(location: smallBottomRight, color: .brown, name: "earthSmall")
        makeCircle(location: smallBottomLeft, color: .black, name: "metalSmall")
        makeCircle(location: smallSideLeft, color: .blue, name: "waterSmall")
        
        woodNode = childNode(withName: "wood") as! SKShapeNode
        fireNode = childNode(withName: "fire") as! SKShapeNode
        earthNode = childNode(withName: "earth") as! SKShapeNode
        metalNode = childNode(withName: "metal") as! SKShapeNode
        waterNode = childNode(withName: "water") as! SKShapeNode
    }
    
    override func update(_ currentTime: TimeInterval) {
    
        
    }

    func didBegin(_ contact: SKPhysicsContact) {
        
        objectMovable = false
        
        var element: SKNode?
        if contact.bodyA.node?.name == "wood" || contact.bodyA.node?.name == "fire" || contact.bodyA.node?.name == "earth" || contact.bodyA.node?.name == "metal" || contact.bodyA.node?.name == "water" {
            element = contact.bodyA.node!
        } else if contact.bodyB.node?.name == "wood" || contact.bodyB.node?.name == "fire" || contact.bodyB.node?.name == "earth" || contact.bodyB.node?.name == "metal" || contact.bodyB.node?.name == "water" {
            element = contact.bodyB.node!
        }
        var selectionSquare: SKNode?
        if contact.bodyA.node?.name == "selectionSquare" {
            selectionSquare = contact.bodyA.node!
        } else if contact.bodyB.node?.name == "selectionSquare" {
            selectionSquare = contact.bodyB.node!
        }
        
        var startingType: Element.element!
        
        if selectionSquare != nil && element != nil {
            switch((element?.name)!) {
            case "wood":
                startingType = .wood
                break
            case "fire":
                startingType = .fire
                break
            case "earth":
                startingType = .earth
                break
            case "metal":
                startingType = .metal
                break
            case "water":
                startingType = .water
                break
            default:
                print("unsupported element")
                return
            }
            let game = GUIScene(fileNamed: "GUIScene")
            game?.scaleMode = .aspectFill
            game?.player.startingType = startingType
            view?.presentScene(game)
        }
        
              
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        objectMovable = true
        let touch = touches.first!
        let location = touch.location(in: self)
        let nodeAtPoint = atPoint(location)
        if nodeAtPoint.name == "wood" || nodeAtPoint.name == "fire" || nodeAtPoint.name == "earth" || nodeAtPoint.name == "metal" || nodeAtPoint.name == "water" {
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
      
        
        woodNode.position = woodCenter
        fireNode.position = fireCenter
        earthNode.position = earthCenter
        metalNode.position = metalCenter
        waterNode.position = waterCenter
        
        
    }


}
