//
//  GemScene.swift
//  theGame2
//
//  Created by Tyler Goodwyn on 7/31/17.
//  Copyright © 2017 Tyler Goodwyn. All rights reserved.
//

import Foundation
import SpriteKit

class WoodTutorial6: SKScene, SKPhysicsContactDelegate {
    
    enum gameState {
        case active, inactive
    }
    var gameState: gameState = .inactive
    var startRunning: Bool = false
    var startButton: MSButtonNode!

    
    var player = Player()
    var opponent = Player()
    
    var startLabel: SKLabelNode!
    var turnCountLabel: SKLabelNode!
    var turnsAllowed: Int = 3
    
    var gamesCompleted: Int = 0
    var numberOfMovesOpponentTakes: Int = 0

    var nextTutButton: MSButtonNode!
    var restartButton: MSButtonNode!
    
    var objectGrabbed: Element!
    var objectMovable:Bool = true
    var object1Locked:Bool = false
    var object2Locked:Bool = false
    
    var playerElement1: Element!
    var playerElement2: Element!
    var playerElement3: Element!
    var playerElement4: Element!
    var playerElement5: Element!
    
    var opponentElement1: Element!
    var opponentElement2: Element!
    var opponentElement3: Element!
    var opponentElement4: Element!
    var opponentElement5: Element!
    
    var opponentWoodLabel: SKLabelNode!
    var opponentFireLabel: SKLabelNode!
    var opponentEarthLabel: SKLabelNode!
    var opponentMetalLabel: SKLabelNode!
    var opponentWaterLabel: SKLabelNode!
    
    var mainMenu: MSButtonNode!
    
    var comboZone1: SKSpriteNode!
    var comboZone2: SKSpriteNode!
    
    var elementLockedIn1: Element?
    var elementLockedIn2: Element?
    
    var lastElementsTransformed: [Element.element] = []
    
    var effect: SKSpriteNode!
    
    var tutText1: SKLabelNode!
    var tutText2: SKLabelNode!
    
    override func didMove(to view: SKView) {
       
        startLabel = childNode(withName: "startLabel") as! SKLabelNode
        startLabel.text = "Tap"
        startLabel.isHidden = false
        startButton = childNode(withName: "startButton") as! MSButtonNode
        
        startButton.selectedHandler = {
            self.startLabel.isHidden = true
            self.startButton.isHidden = true
            self.startRunning = true
            self.gameState = .active
        }
        
        // element node connections and locations
        playerElement1 = childNode(withName: "playerElement1") as! Element
        playerElement2 = childNode(withName: "playerElement2") as! Element
        playerElement3 = childNode(withName: "playerElement3") as! Element
        playerElement4 = childNode(withName: "playerElement4") as! Element
        playerElement5 = childNode(withName: "playerElement5") as! Element
        
        opponentElement1 = childNode(withName: "opponentElement1") as! Element
        opponentElement2 = childNode(withName: "opponentElement2") as! Element
        opponentElement3 = childNode(withName: "opponentElement3") as! Element
        opponentElement4 = childNode(withName: "opponentElement4") as! Element
        opponentElement5 = childNode(withName: "opponentElement5") as! Element
   
        opponentWoodLabel = childNode(withName: "//opponentWoodLabel") as! SKLabelNode
        opponentFireLabel = childNode(withName: "//opponentFireLabel") as! SKLabelNode
        opponentEarthLabel = childNode(withName: "//opponentEarthLabel") as! SKLabelNode
        opponentMetalLabel = childNode(withName: "//opponentMetalLabel") as! SKLabelNode
        opponentWaterLabel = childNode(withName: "//opponentWaterLabel") as! SKLabelNode
        
        comboZone1 = childNode(withName: "//comboZone1") as! SKSpriteNode
        comboZone2 = childNode(withName: "//comboZone2") as! SKSpriteNode
        
        effect = childNode(withName: "effect") as! SKSpriteNode
        
        tutText1 = childNode(withName: "tutorialText1") as! SKLabelNode
        tutText2 = childNode(withName: "tutorialText2") as! SKLabelNode
       
        
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
            nextElement.startingPosition = nextElement.position
            player.setElement(nextElement.type, to: nextElement)
            prevType = nextElement.type
        }
        
     
        playerElement4.isHidden = true
        
        prevType = nil
        for number in 1...5 {
            let nextElement = childNode(withName: "opponentElement\(number)") as! Element
            nextElement.belongsTo = .AI
            if prevType != nil {
                nextElement.type = Element.strengthens[prevType!]!
            } else {
                nextElement.type = player.startingType
                opponent.startingType = nextElement.type
            }
            nextElement.startingPosition = nextElement.position
            opponent.setElement(nextElement.type, to: nextElement)
            prevType = nextElement.type
        }
        
        setBoard()
        physicsWorld.contactDelegate = self
        
        
        nextTutButton = childNode(withName: "setBoardButton") as! MSButtonNode
        restartButton = childNode(withName: "restartButton") as! MSButtonNode
    
        turnCountLabel = childNode(withName: "turnCountLabel") as! SKLabelNode
        
        restartButton.isHidden = true
        nextTutButton.isHidden = true
        
        nextTutButton.selectedHandler = {
            
            SKTransition.flipVertical(withDuration: 0)
            
            let tutorial = GemScene(fileNamed: "GemScene")
            tutorial?.scaleMode = .aspectFill
            view.presentScene(tutorial)
            
        }
        restartButton.selectedHandler = {
            self.setBoard()
            self.turnsAllowed = 3
            self.startLabel.isHidden = true
            self.restartButton.isHidden = true
        }
    
        
    }
    
    func setBoard() {
        player.wood.health = 8
        player.fire.health = 5
        player.earth.health = 0
        player.metal.health = 9
        player.water.health = 4
        
        opponent.wood.health = 0
        opponent.fire.health = 1
        opponent.earth.health = 0
        opponent.metal.health = 8
        opponent.water.health = 4
        
    }
    
    func resetElementHealth() {
        for elements in [player.wood, player.fire, player.earth, player.metal, player.water, opponent.wood, opponent.fire, opponent.earth, opponent.metal, opponent.water] {
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
            }
            
            if zoneNode?.name == ("comboZone2") {
                elementLockedIn2 = playerElement
                object2Locked = true
            }
            
        }
      
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.gameState == .active {
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
            objectGrabbed = nil
            for element in [playerElement1, playerElement2, playerElement3, playerElement4, playerElement5] {
                if element != objectGrabbed && element != elementLockedIn1 && element != elementLockedIn2 {
                    element!.position = element!.startingPosition
                }
            }
            if  let e1 = elementLockedIn1, let e2 = elementLockedIn2 {
                func resetElements() {
                    self.isUserInteractionEnabled = false
                    let moveBackE1 = SKAction.move(to: elementLockedIn1!.startingPosition, duration: 0)
                    let moveBackE2 = SKAction.move(to: elementLockedIn2!.startingPosition, duration: 0)
                    let elementSeq1 = SKAction.sequence([SKAction.wait(forDuration: 1.25), moveBackE1])
                    let elementSeq2 = SKAction.sequence([SKAction.wait(forDuration: 1.25), moveBackE2])
                    e1.run(elementSeq1)
                    e2.run(elementSeq2)
                    elementLockedIn1 = nil
                    elementLockedIn2 = nil
                    self.isUserInteractionEnabled = true
                }
                if object1Locked && object2Locked {
                    if Element.strengthens[e1.type] == e2.type {
                        animateElement(e2.type)
                        animateHealth(e1: e2, e2: e1, add: true)
                        resetElementHealth()
                        resetElements()
                        turnsAllowed -= 1
                        
                    } else if Element.strengthens[e2.type] == e1.type {
                        
                        animateElement(e1.type)
                        animateHealth(e1: e1, e2: e2, add: true)
                        resetElementHealth()
                        resetElements()
                        turnsAllowed -= 1
                        
                    } else if Element.damagedBy[e1.type] == e2.type {
                        
                        animateElement(e1.type)
                        animateHealth(e1: e1, e2: e2, add: false)
                        resetElementHealth()
                        resetElements()
                        turnsAllowed -= 1
                    } else if Element.damagedBy[e2.type] == e1.type {
                        
                        animateElement(e2.type)
                        animateHealth(e1: e2, e2: e1, add: false)
                        resetElementHealth()
                        resetElements()
                        turnsAllowed -= 1
                    }
                    
                }
            }
        } else if objectGrabbed != nil  {
            if objectGrabbed == elementLockedIn1 {
                object1Locked = false
                elementLockedIn1 = nil
            }
            if objectGrabbed == elementLockedIn2 {
                object2Locked = false
                elementLockedIn2 = nil
            }
            objectGrabbed.position = objectGrabbed.startingPosition
            
        }
        
        print("player wood health is \(player.wood.health)")
        print("opponent wood health is \(opponent.wood.health)")
        print("turns allowed is \(turnsAllowed)")
        
        
    }
    override func update(_ currentTime: TimeInterval) {
    
        turnCountLabel.text = String(turnsAllowed)
        
        opponentWoodLabel.text = String(opponent.wood.health)
        opponentFireLabel.text = String(opponent.fire.health)
        opponentEarthLabel.text = String(opponent.earth.health)
        opponentMetalLabel.text = String(opponent.metal.health)
        opponentWaterLabel.text = String(opponent.water.health)
        
        if turnsAllowed == 3 && startRunning {
            self.startRunning = false
            let delay = SKAction.wait(forDuration: 2.25)
            let delay2 = SKAction.wait(forDuration: 3.0)
            let anAction = SKAction.run {
                // self.isUserInteractionEnabled = false
                self.tutText1.text = ("See now if you can handle")
                self.tutText2.text = ("this more complex recipe")
            }
            let seq = SKAction.sequence([anAction])
            tutText1.run(seq)
        } else if turnsAllowed == 2 {
            self.tutText1.text = ("Remember that order matters")
            self.tutText2.text = nil
        } else if turnsAllowed == 1 {
            self.tutText1.text = ("And that elements weaken")
            self.tutText2.text = ("two to the right")
        }
        
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
    
    func animateElement(_ type: Element.element) {
    
        self.isUserInteractionEnabled = false
        let delay = SKAction.wait(forDuration: 0.25)
        var animate = SKAction(named: "magicFX")
        
        switch type {
            case .wood:
                animate = SKAction(named: "woodFX")
                break
            case .fire:
                animate = SKAction(named: "fireFX")
                break
            case .earth:
                animate = SKAction(named: "earthFX")
                break
            case.metal:
                animate = SKAction(named: "metalFX")
                break
            case.water:
                animate = SKAction(named: "waterFX")
                break
            }
            
            
        let appear = SKAction.fadeAlpha(to: 1, duration: 0)
        let disappear = SKAction.fadeAlpha(to: 0, duration: 0)
        let seq = SKAction.sequence([delay, appear, animate!, disappear])
        effect.run(seq)
    }
    
    func animateHealth(e1: Element, e2: Element, add: Bool) {
        let delay = SKAction.wait(forDuration: 1.25)
        let anAction = SKAction.run {
            if add == true {
                e1.health += e2.health
            } else {
                e1.health -= e2.health
            }
            self.resetElementHealth()
            
            // game over condition
            
            if self.player.wood.health == self.opponent.wood.health && self.player.fire.health == self.opponent.fire.health && self.player.earth.health == self.opponent.earth.health && self.player.metal.health == self.opponent.metal.health && self.player.water.health == self.opponent.water.health {
                self.startLabel.isHidden = false
                self.startLabel.text = "Next"
                self.nextTutButton.isHidden = false
                self.turnsAllowed = 0
                print("OVER CONDITION 1")
                
                    self.tutText1.text = ("Excellent job! You're almost")
                    self.tutText2.text = ("ready for the full game!")
        
                
            } else if self.turnsAllowed == 0 {
                self.gamesCompleted = 0
                self.startLabel.isHidden = false
                self.startLabel.text = "Restart"
                self.restartButton.isHidden = false
                self.turnsAllowed = 0
                print("OVER CONDITION 2")
                self.tutText1.text = ("This was a tough one")
                self.tutText2.text = ("Give it another try")
            }
        }
        let seq = SKAction.sequence([delay, anAction])
        effect.run(seq)
        
        
        
    }
    
    
    
    
}
