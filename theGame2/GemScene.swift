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
    
    enum gameState {
        case active, inactive
    }
    
    var gameState: gameState!
    
    var player = Player()
    var opponent = Player()
    
    var startLabel: SKLabelNode!
    var turnCountLabel: SKLabelNode!
    var turnsAllowed: Int = 0 {
        didSet {
            turnCountLabel.text = String(turnsAllowed)
        }
    }
    
    var gamesCompleted: Int = 0
    var numberOfMovesOpponentTakes: Int = 0

    var setBoardButton: MSButtonNode!
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
    
    var playerWoodLabel: SKLabelNode!
    var playerFireLabel: SKLabelNode!
    var playerEarthLabel: SKLabelNode!
    var playerMetalLabel: SKLabelNode!
    var playerWaterLabel: SKLabelNode!
    
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
    
    override func didMove(to view: SKView) {
        // set game state to inactive
        self.gameState = .inactive
        
        startLabel = childNode(withName: "startLabel") as! SKLabelNode
        startLabel.text = "Start"
        
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
        
        playerWoodLabel = childNode(withName: "//playerWoodLabel") as! SKLabelNode
        playerFireLabel = childNode(withName: "//playerFireLabel") as! SKLabelNode
        playerEarthLabel = childNode(withName: "//playerEarthLabel") as! SKLabelNode
        playerMetalLabel = childNode(withName: "//playerMetalLabel") as! SKLabelNode
        playerWaterLabel = childNode(withName: "//playerWaterLabel") as! SKLabelNode
        
        opponentWoodLabel = childNode(withName: "opponentWoodLabel") as! SKLabelNode
        opponentFireLabel = childNode(withName: "opponentFireLabel") as! SKLabelNode
        opponentEarthLabel = childNode(withName: "opponentEarthLabel") as! SKLabelNode
        opponentMetalLabel = childNode(withName: "opponentMetalLabel") as! SKLabelNode
        opponentWaterLabel = childNode(withName: "opponentWaterLabel") as! SKLabelNode
        
        comboZone1 = childNode(withName: "//comboZone1") as! SKSpriteNode
        comboZone2 = childNode(withName: "//comboZone2") as! SKSpriteNode
        
        effect = childNode(withName: "effect") as! SKSpriteNode
        
        
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
        
        resetBoard()
        physicsWorld.contactDelegate = self
        
        
        setBoardButton = childNode(withName: "setBoardButton") as! MSButtonNode
        restartButton = childNode(withName: "restartButton") as! MSButtonNode
    
        turnCountLabel = childNode(withName: "turnCountLabel") as! SKLabelNode
        
        restartButton.isHidden = true

        setBoardButton.selectedHandler = {
            self.setOpponentBoard()
            self.gameState = .active
            self.startLabel.isHidden = true
            self.setBoardButton.isHidden = true
            
        }
        restartButton.selectedHandler = {
            self.resetBoard()
            self.setOpponentBoard()
            self.gameState = .active
            self.startLabel.isHidden = true
            self.restartButton.isHidden = true
        }
    
        
    }
    
    func resetBoard() {
        player.wood.health = 3
        player.fire.health = 4
        player.earth.health = 1
        player.metal.health = 5
        player.water.health = 2
        opponent.wood.health = 3
        opponent.fire.health = 4
        opponent.earth.health = 1
        opponent.metal.health = 5
        opponent.water.health = 2
        gamesCompleted = 0
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
    
    // AI action functions
    func opponentTransform(_ elementsToTransform: [Element]) {
        var acceptable = false
        var selectedElement: Element = opponent.wood
        let transformed: [Element.element : Element] = [.earth: opponent.metal, .metal: opponent.water, .water: opponent.wood, .wood: opponent.fire, .fire: opponent.earth]
        while !acceptable {
            selectedElement = elementsToTransform[Int(arc4random_uniform(UInt32(elementsToTransform.count)))]
            if (lastElementsTransformed.count < 1 || lastElementsTransformed.first != selectedElement.type) && (lastElementsTransformed.count < 2 || lastElementsTransformed[1] != selectedElement.type) {
                acceptable = true
            }
        }
        transformed[selectedElement.type]!.health += selectedElement.health
        lastElementsTransformed.append(selectedElement.type)
        if lastElementsTransformed.count > 2 {
            lastElementsTransformed.removeFirst()
        }
        let turnCount: Int = turnsAllowed + 1
        print("\(selectedElement.type) supports on turn \(turnCount)")
    }
    
    func opponentBalance(_ elementsToBalance: [Element]) {
        let selectedElement = elementsToBalance[Int(arc4random_uniform(UInt32(elementsToBalance.count)))]
        let opponentElement : [Element.element : Element] = [.earth: opponent.wood, .metal: opponent.fire, .water: opponent.earth, .wood: opponent.metal, .fire: opponent.water]
        selectedElement.health -= opponentElement[selectedElement.type]!.health
        let turnCount: Int = turnsAllowed + 1
        print("\(selectedElement.type) is weakened on turn \(turnCount)")
    }
    
    // AI opponent turn function
    func opponentTurn() {
        // Making the arrays
        var balanceable: [Element] = []
        var transformable: [Element] = []
        // Setting the arrays
        for elements in [opponent.wood!, opponent.fire!, opponent.earth!, opponent.water!, opponent.metal!] {
            if elements.health > 0 {
                transformable.append(elements)
                let balance : [Element.element : Element] = [.wood: opponent.earth, .fire: opponent.metal, .earth: opponent.water, .water: opponent.fire, .metal: opponent.wood]
                if balance[elements.type]!.health > 0 {
                    balanceable.append(balance[elements.type]!)
                }
            }
        }
        if balanceable.count > 0 && arc4random_uniform(2) == 0 {
            opponentBalance(balanceable)
            resetElementHealth()
            lastElementsTransformed = []
        } else  {
            opponentTransform(transformable)
            resetElementHealth()
        }
        turnsAllowed += 1
    }
    
    func setOpponentBoard() {
        for _ in 0 ..< numberOfMovesOpponentTakes {
            opponentTurn()
            print("opponent has \(numberOfMovesOpponentTakes) moves")
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
            objectGrabbed = nil
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
            print("this is being called")
        }
        
        
        
        
        
    }
    override func update(_ currentTime: TimeInterval) {
    
        
        playerWoodLabel.text = String(player.wood.health)
        playerFireLabel.text = String(player.fire.health)
        playerEarthLabel.text = String(player.earth.health)
        playerMetalLabel.text = String(player.metal.health)
        playerWaterLabel.text = String(player.water.health)
        
        opponentWoodLabel.text = String(opponent.wood.health)
        opponentFireLabel.text = String(opponent.fire.health)
        opponentEarthLabel.text = String(opponent.earth.health)
        opponentMetalLabel.text = String(opponent.metal.health)
        opponentWaterLabel.text = String(opponent.water.health)
        
        numberOfMovesOpponentTakes = gamesCompleted + 1
        
        
        
        for element in [playerElement1, playerElement2, playerElement3, playerElement4, playerElement5] {
            if (object1Locked && element != objectGrabbed && element != elementLockedIn1) || (object2Locked && element != objectGrabbed && element != elementLockedIn2) {
                element!.position = element!.startingPosition
            }
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
            if self.gameState == .active {
                if self.player.wood.health == self.opponent.wood.health && self.player.fire.health == self.opponent.fire.health && self.player.earth.health == self.opponent.earth.health && self.player.metal.health == self.opponent.metal.health && self.player.water.health == self.opponent.water.health {
                    self.startLabel.isHidden = false
                    self.startLabel.text = "Success"
                    self.gamesCompleted += 1
                    self.setBoardButton.isHidden = false
                    self.gameState = .inactive
                    self.turnsAllowed = 0
                } else if self.turnsAllowed == 0 {
                    
                    self.startLabel.isHidden = false
                    self.startLabel.text = "Fail"
                    self.setBoardButton.isHidden = false
                    self.turnsAllowed = 0
                    self.resetBoard()
                    self.gameState = .inactive
                }
            }
        }
        let seq = SKAction.sequence([delay, anAction])
        effect.run(seq)
        
        
        
    }
    
    
    
    
}
