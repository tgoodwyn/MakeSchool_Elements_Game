//
//  GemScene.swift
//  theGame2
//
//  Created by Tyler Goodwyn on 7/31/17.
//  Copyright © 2017 Tyler Goodwyn. All rights reserved.
//

import Foundation
import SpriteKit

class GemScene: SKScene, SKPhysicsContactDelegate {
    

    var player = Player()
  
    
    var objectGrabbed: Element!
    var objectMovable:Bool = true
    
    var playerElement1: Element!
    var playerElement2: Element!
    var playerElement3: Element!
    var playerElement4: Element!
    var playerElement5: Element!
    
    var mainMenu: MSButtonNode!
    
    var comboZone1: SKSpriteNode!
    var comboZone2: SKSpriteNode!
    
    override func didMove(to view: SKView) {

        // element node connections and locations
        playerElement1 = childNode(withName: "playerElement1") as! Element
        playerElement2 = childNode(withName: "playerElement2") as! Element
        playerElement3 = childNode(withName: "playerElement3") as! Element
        playerElement4 = childNode(withName: "playerElement4") as! Element
        playerElement5 = childNode(withName: "playerElement5") as! Element
        
        comboZone1 = childNode(withName: "comboZone1") as! Element
        comboZone2 = childNode(withName: "comboZone2") as! Element
        
        mainMenu = childNode(withName: "mainMenu") as! MSButtonNode
        
        mainMenu.selectedHandler = {
            let menu = MainMenu(fileNamed: "MainMenu")
            menu?.scaleMode = .aspectFill
            view.presentScene(menu)
        }
        
        player.startingType = .water
        
        var prevType: Element.element?
        for number in 1...5 {
            let nextElement = childNode(withName: "playerElement\(number)") as! Element
            nextElement.belongsTo = .human
            if let unwrappedType = prevType {
                nextElement.type = Element.strengthens[unwrappedType]!
            } else {
                nextElement.type = player.startingType
            }
            nextElement.color = Element.colors[nextElement.type]!
            nextElement.startingPosition = nextElement.position
            player.setElement(nextElement.type, to: nextElement)
            prevType = nextElement.type
        }
        
        
        
        resetBoard()
        physicsWorld.contactDelegate = self
    }
    
    func resetBoard() {
        player.wood.health = 3
        player.fire.health = 4
        player.earth.health = 1
        player.metal.health = 5
        player.water.health = 2
        
    }
    
    func resetElementHealth() {
        for elements in [player.wood, player.fire, player.earth, player.metal, player.water] {
            if (elements?.health)! < 0 {
                elements?.health = abs((elements?.health)!)
            }
            if (elements?.health)! > 10 {
                elements?.health = 20 - (elements?.health)!
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        objectMovable = false
        print("CONTACT!!!!!!!!!!!!!!!!!!!!!")
        let contactNodeA = contact.bodyA.node as! SKSpriteNode
        let contactNodeB = contact.bodyB.node as! SKSpriteNode
        // Player squares
        var playerElement: Element?
        var playerElement2: Element?
        
        var zoneNode: SKSpriteNode
        
        if let nodeA = contactNodeA as? Element {
                playerElement1 = nodeA
        } else {
            
        }
        if let nodeB = contactNodeB as? Element {
        
                if playerElement1 == nil {
                    playerElement1 = nodeB
                } else {
                    playerElement2 = nodeB
                }

        }
        // supporting interactions
        if playerElement1 != nil && playerElement2 != nil {
            if Element.strengthens[playerElement1!.type] == playerElement2!.type {
                playerElement2!.health += playerElement1!.health
                resetElementHealth()
            } else if Element.strengthens[playerElement2!.type] == playerElement1!.type {
                playerElement1!.health += playerElement2!.health
                resetElementHealth()
            }
        }
        // damaging interactions
        if playerElement1 != nil && playerElement2 != nil {
            if Element.damagedBy[playerElement1!.type] == playerElement2!.type {
                playerElement1!.health -= playerElement2!.health
                resetElementHealth()
            } else if Element.damagedBy[playerElement2!.type] == playerElement1!.type {
                playerElement2!.health -= playerElement1!.health
                resetElementHealth()
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        objectMovable = true
        let touch = touches.first!
        let location = touch.location(in: self)
        if let nodeAtPoint = atPoint(location) as? Element {
            if nodeAtPoint.belongsTo == .human {
                objectGrabbed = nodeAtPoint
            } else {
                objectGrabbed = nil
            }
        } else if atPoint(location) is SKLabelNode && atPoint(location).parent is Element && (atPoint(location).parent as! Element).belongsTo == .human {
            objectGrabbed = atPoint(location).parent as? Element
        } else {
            objectGrabbed = nil
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if objectGrabbed != nil {
            if objectMovable == true {
                objectGrabbed.position = (touches.first?.location(in: self))!
            }
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if objectGrabbed != nil {
            objectGrabbed.position = objectGrabbed.startingPosition
        }
    }
    override func update(_ currentTime: TimeInterval) {
        for value in 1...10 {
            let fireGem = childNode(withName: "fireGem\(value)") as! Gem
            fireGem.number = value
            if fireGem.number > player.fire.health {
                fireGem.isHidden = true
            } else {
                fireGem.isHidden = false
            }
            let woodGem = childNode(withName: "woodGem\(value)") as! Gem
            woodGem.number = value
            if woodGem.number > player.wood.health {
                woodGem.isHidden = true
            } else {
                woodGem.isHidden = false
            }
            let earthGem = childNode(withName: "earthGem\(value)") as! Gem
            earthGem.number = value
            if earthGem.number > player.earth.health {
                earthGem.isHidden = true
            } else {
                earthGem.isHidden = false
            }
            let metalGem = childNode(withName: "metalGem\(value)") as! Gem
            metalGem.number = value
            if metalGem.number > player.metal.health {
                metalGem.isHidden = true
            } else {
                metalGem.isHidden = false
            }
            let waterGem = childNode(withName: "waterGem\(value)") as! Gem
            waterGem.number = value
            if waterGem.number > player.water.health {
                waterGem.isHidden = true
            } else {
                waterGem.isHidden = false
            }
            
        }

    }

    
    
}
