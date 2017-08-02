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
    var object1Locked:Bool = false
    var object2Locked:Bool = false
    
    var playerElement1: Element!
    var playerElement2: Element!
    var playerElement3: Element!
    var playerElement4: Element!
    var playerElement5: Element!
    
    var mainMenu: MSButtonNode!
    
    var comboZone1: SKSpriteNode!
    var comboZone2: SKSpriteNode!
    
    var elementLockedIn1: Element?
    var elementLockedIn2: Element?
    
    override func didMove(to view: SKView) {

        // element node connections and locations
        playerElement1 = childNode(withName: "playerElement1") as! Element
        playerElement2 = childNode(withName: "playerElement2") as! Element
        playerElement3 = childNode(withName: "playerElement3") as! Element
        playerElement4 = childNode(withName: "playerElement4") as! Element
        playerElement5 = childNode(withName: "playerElement5") as! Element
        
        comboZone1 = childNode(withName: "//comboZone1") as! SKSpriteNode
        comboZone2 = childNode(withName: "//comboZone2") as! SKSpriteNode
        
        // mainMenu = childNode(withName: "mainMenu") as! MSButtonNode
        
        /*mainMenu.selectedHandler = {
            let menu = MainMenu(fileNamed: "MainMenu")
            menu?.scaleMode = .aspectFill
            view.presentScene(menu)
        }*/
        
        player.startingType = .water
        
        var prevType: Element.element?
        for number in 1...5 {
            let nextElement = childNode(withName: "playerElement\(number)") as! Element
            if let unwrappedType = prevType {
                nextElement.type = Element.strengthens[unwrappedType]!
            } else {
                nextElement.type = player.startingType
            }
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
    
    var destZone: SKSpriteNode?
    
    func didBegin(_ contact: SKPhysicsContact) {
        objectMovable = false
        
        let contactNodeA = contact.bodyA.node as! SKSpriteNode
        let contactNodeB = contact.bodyB.node as! SKSpriteNode
        
        var playerElement: Element?
        var zoneNode: SKSpriteNode?
        
        if let nodeA = contactNodeA as? Element {
            playerElement = nodeA
        
        } else if contactNodeA.name!.hasPrefix("comboZone") {
            zoneNode = contactNodeA
        }
        
        if let nodeB = contactNodeB as? Element {
            playerElement = nodeB

        } else if contactNodeB.name!.hasPrefix("comboZone") {
            zoneNode = contactNodeB
        }
       
        if playerElement != nil && zoneNode != nil {
            destZone = zoneNode
            
            if zoneNode?.name == ("comboZone1") {
                elementLockedIn1 = playerElement
                object1Locked = true
            } else if zoneNode?.name == ("comboZone2") {
                elementLockedIn2 = playerElement
                object2Locked = true
            }
            
        }
      
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        objectMovable = true
        let touch = touches.first!
        let location = touch.location(in: self)
        if let nodeAtPoint = atPoint(location) as? Element {
            objectGrabbed = nodeAtPoint
       
        } else if atPoint(location) is SKSpriteNode && atPoint(location).parent is Element{
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
        
        if let dest = destZone {
            
            objectGrabbed.position = dest.position
            objectGrabbed.position.y = dest.position.y + 22
            destZone = nil
            
        } else if objectGrabbed != nil  {
            
            print("objectGrabbed is \(objectGrabbed)")
            print("elementLockedIn1 is \(elementLockedIn1)")
            print("elementLockedIn2 is \(elementLockedIn2)")
            
            if objectGrabbed == elementLockedIn1 {
                print("object l leaving")
                object1Locked = false
                elementLockedIn1 = nil
            }
            if objectGrabbed == elementLockedIn2 {
                print("object 2 leaving")
                object2Locked = false
                elementLockedIn2 = nil
            }
            objectGrabbed.position = objectGrabbed.startingPosition
        }
        
        
        
        if  let e1 = elementLockedIn1, let e2 = elementLockedIn2 {
           
            print("working")
            
            func resetElements() {
                elementLockedIn1?.position = (elementLockedIn1?.startingPosition)!
                elementLockedIn2?.position = (elementLockedIn2?.startingPosition)!
                elementLockedIn1 = nil
                elementLockedIn2 = nil
                
            }
            
            if object1Locked == true && object1Locked == true {
                if Element.strengthens[e1.type] == e2.type {
                    print("e1 supports e2")
                    resetElements()
                    print(elementLockedIn1)
                } else if Element.strengthens[e2.type] == e1.type {
                    print("e2 supports e1")
                    resetElements()
                } else if Element.damagedBy[e1.type] == e2.type {
                    print("e2 damages e1")
                    resetElements()
                } else if Element.damagedBy[e2.type] == e1.type {
                    print("e1 damages e2")
                    resetElements()
                }
            }
        }
        
        
    }
    override func update(_ currentTime: TimeInterval) {
        /*for value in 1...10 {
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
 
        }*/
        
    }

    
    
}
