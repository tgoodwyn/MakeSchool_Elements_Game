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
    
    enum gameMode {
        case untimed, timed
    }
    
    var gameMode: gameMode = .untimed
    var gameState: gameState!
    
    var player = Player()
    var ai = Player()
    
    var background1: SKSpriteNode!
    var background2: SKSpriteNode!
    
    // AI turn stuff
    var gamesCompleted: Int = 0
    var numberOfMovesaiTakes: Int = 0
    var lastUntimedMove: Int = 0
    var aiActions = [String]()
    var aiAction: String!
    var playerAction: String!
    var movesTaken: Int = 0 {
        didSet {
            turnCountLabel.text = String(movesTaken)
        }
    }
    var lastElementsTransformed: [Element.element] = []
    var playerFireHealths = [Int]()
    var playerEarthHealths = [Int]()
    var playerMetalHealths = [Int]()
    var playerWaterHealths = [Int]()
    var playerWoodHealths = [Int]()
    var hintElements = [Element]()
    
    
    // UI Stuff
    var setBoardButton: MSButtonNode!
    var restartButton: MSButtonNode!
    var mainMenu: MSButtonNode!
    var startLabel: SKLabelNode!
    var turnCountLabel: SKLabelNode!
    var turnsAllowedLabel: SKLabelNode!
    var turnsAllowed: Int = 0 {
        didSet {
            turnsAllowedLabel.text = String(turnsAllowed)
        }
    }
    var undoButton: MSButtonNode!
    var hintButton: MSButtonNode!
    
    // Combo stuff
    var objectGrabbed: Element!
    var objectMovable:Bool = true
    var object1Locked:Bool = false
    var object2Locked:Bool = false
    var elementLockedIn1: Element?
    var elementLockedIn2: Element?
    var effect: Element!
    var comboZone1: SKSpriteNode!
    var comboZone2: SKSpriteNode!
    var playerElement1: Element!
    var playerElement2: Element!
    var playerElement3: Element!
    var playerElement4: Element!
    var playerElement5: Element!
    var playerWoodLabel: SKLabelNode!
    var playerFireLabel: SKLabelNode!
    var playerEarthLabel: SKLabelNode!
    var playerMetalLabel: SKLabelNode!
    var playerWaterLabel: SKLabelNode!
    
    // AI on screen markers
    var aiElement1: Element!
    var aiElement2: Element!
    var aiElement3: Element!
    var aiElement4: Element!
    var aiElement5: Element!
    var aiWoodLabel: SKLabelNode!
    var aiFireLabel: SKLabelNode!
    var aiEarthLabel: SKLabelNode!
    var aiMetalLabel: SKLabelNode!
    var aiWaterLabel: SKLabelNode!
    
    
    override func didMove(to view: SKView) {
        // set game state to inactive
        self.gameState = .inactive
        
        // UI Things
        hintButton = childNode(withName: "hintButton") as! MSButtonNode
        self.hintButton.isHidden = true
        startLabel = childNode(withName: "startLabel") as! SKLabelNode
        startLabel.text = "Start"
        undoButton = childNode(withName: "undoButton") as! MSButtonNode
        self.undoButton.isHidden = true
        setBoardButton = childNode(withName: "setBoardButton") as! MSButtonNode
        restartButton = childNode(withName: "restartButton") as! MSButtonNode
        turnCountLabel = childNode(withName: "turnCountLabel") as! SKLabelNode
        turnsAllowedLabel = childNode(withName: "turnAllowedLabel") as! SKLabelNode
        restartButton.isHidden = true
        background1 = childNode(withName: "background1") as! SKSpriteNode
        background2 = childNode(withName: "background2") as! SKSpriteNode
        background1.isHidden = false
        background2.isHidden = true
        // Button functions
        undoButton.selectedHandler = {
            self.gameMode = .untimed
            self.background1.isHidden = false
            self.movesTaken = self.lastUntimedMove
            self.player.fire.health = self.playerFireHealths[self.movesTaken]
            self.player.wood.health = self.playerWoodHealths[self.movesTaken]
            self.player.metal.health = self.playerMetalHealths[self.movesTaken]
            self.player.earth.health = self.playerEarthHealths[self.movesTaken]
            self.player.water.health = self.playerWaterHealths[self.movesTaken]
            self.undoButton.isHidden = true
            self.hintButton.isHidden = false
            self.startLabel.isHidden = false
        }
        hintButton.selectedHandler = {
            self.setHintElement()
        }
        setBoardButton.selectedHandler = {
            let anAction = SKAction.run {
                self.setaiBoard()
            }
            let seq = SKAction.sequence([anAction])
            self.run(seq)
            self.gameState = .active
            self.startLabel.text = "Hint"
            self.setBoardButton.isHidden = true
            self.hintButton.isHidden = false
            
        }
        restartButton.selectedHandler = {
            self.resetBoard()
            self.setaiBoard()
            self.gameState = .active
            self.startLabel.isHidden = true
            self.restartButton.isHidden = true
            self.hintButton.isHidden = false
        }
        
        
        // elements and labels
        playerElement1 = childNode(withName: "playerElement1") as! Element
        playerElement2 = childNode(withName: "playerElement2") as! Element
        playerElement3 = childNode(withName: "playerElement3") as! Element
        playerElement4 = childNode(withName: "playerElement4") as! Element
        playerElement5 = childNode(withName: "playerElement5") as! Element
        aiElement1 = childNode(withName: "opponentElement1") as! Element
        aiElement2 = childNode(withName: "opponentElement2") as! Element
        aiElement3 = childNode(withName: "opponentElement3") as! Element
        aiElement4 = childNode(withName: "opponentElement4") as! Element
        aiElement5 = childNode(withName: "opponentElement5") as! Element
        playerWoodLabel = childNode(withName: "//playerWoodLabel") as! SKLabelNode
        playerFireLabel = childNode(withName: "//playerFireLabel") as! SKLabelNode
        playerEarthLabel = childNode(withName: "//playerEarthLabel") as! SKLabelNode
        playerMetalLabel = childNode(withName: "//playerMetalLabel") as! SKLabelNode
        playerWaterLabel = childNode(withName: "//playerWaterLabel") as! SKLabelNode
        aiWoodLabel = childNode(withName: "//opponentWoodLabel") as! SKLabelNode
        aiFireLabel = childNode(withName: "//opponentFireLabel") as! SKLabelNode
        aiEarthLabel = childNode(withName: "//opponentEarthLabel") as! SKLabelNode
        aiMetalLabel = childNode(withName: "//opponentMetalLabel") as! SKLabelNode
        aiWaterLabel = childNode(withName: "//opponentWaterLabel") as! SKLabelNode
        
        // Combination things
        comboZone1 = childNode(withName: "//comboZone1") as! SKSpriteNode
        comboZone2 = childNode(withName: "//comboZone2") as! SKSpriteNode
        effect = childNode(withName: "effect") as! Element
        
        
        // Setting up game
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
                ai.startingType = nextElement.type
            }
            nextElement.startingPosition = nextElement.position
            nextElement.color = .clear
            ai.setElement(nextElement.type, to: nextElement)
            prevType = nextElement.type
        }
        
        // To start game
        resetBoard()
        physicsWorld.contactDelegate = self
        
        
        
        
    }
    
    func resetBoard() {
        player.wood.health = 3
        player.fire.health = 4
        player.earth.health = 1
        player.metal.health = 5
        player.water.health = 2
        ai.wood.health = 3
        ai.fire.health = 4
        ai.earth.health = 1
        ai.metal.health = 5
        ai.water.health = 2
        gamesCompleted = 0
    }
    
    func resetElementHealth() {
        for elements in [player.wood, player.fire, player.earth, player.metal, player.water, ai.wood, ai.fire, ai.earth, ai.metal, ai.water] {
            if (elements?.health)! < 0 {
                elements?.health = abs((elements?.health)!)
            }
            if (elements?.health)! > 10 {
                elements?.health = 20 - (elements?.health)!
            }
        }
    }
    
    // AI action functions
    func aiTransform(_ elementsToTransform: [Element]) {
        var acceptable = false
        var selectedElement: Element = ai.wood
        let transformer: [Element.element : Element] = [.earth: ai.fire, .metal: ai.earth, .water: ai.metal, .wood: ai.water, .fire: ai.wood]
        while !acceptable {
            selectedElement = elementsToTransform[Int(arc4random_uniform(UInt32(elementsToTransform.count)))]
            if (lastElementsTransformed.count < 1 || lastElementsTransformed.first != selectedElement.type) && (lastElementsTransformed.count < 2 || lastElementsTransformed[1] != selectedElement.type) {
                acceptable = true
            }
        }
        selectedElement.health += transformer[selectedElement.type]!.health
        lastElementsTransformed.append(selectedElement.type)
        if lastElementsTransformed.count > 2 {
            lastElementsTransformed.removeFirst()
        }
        aiAction = "\(selectedElement.type.rawValue)Strengthened"
        print(aiAction)
        aiActions.append(aiAction)
        print(aiActions)
        let setPlayerElement : [Element.element : Element] = [.earth: player.earth, .metal: player.metal, .water: player.water, .wood: player.wood, .fire: player.fire]
        let playerElement = setPlayerElement[selectedElement.type]
        hintElements.append(playerElement!)
        let change = ElementChange(position: selectedElement.position, text: "+")
        animateElement(selectedElement.type, object: selectedElement, label: change)
    }
    
    func aiBalance(_ elementsToBalance: [Element]) {
        let selectedElement = elementsToBalance[Int(arc4random_uniform(UInt32(elementsToBalance.count)))]
        let aiElement : [Element.element : Element] = [.earth: ai.wood, .metal: ai.fire, .water: ai.earth, .wood: ai.metal, .fire: ai.water]
        selectedElement.health -= aiElement[selectedElement.type]!.health
        aiAction = "\(selectedElement.type.rawValue)Weakened"
        print(aiAction)
        aiActions.append(aiAction)
        print(aiActions)
        let setPlayerElement : [Element.element : Element] = [.earth: player.earth, .metal: player.metal, .water: player.water, .wood: player.wood, .fire: player.fire]
        let playerElement = setPlayerElement[selectedElement.type]
        hintElements.append(playerElement!)
        let change = ElementChange(position: selectedElement.position, text: "-")
        animateElement(selectedElement.type, object: selectedElement, label: change)
        
    }
    
    func setHintElement() {
        let element = hintElements[movesTaken]
        element.position = comboZone1.position
        element.position.y = comboZone1.position.y + 22
        
        object1Locked = true
        elementLockedIn1 = element
    }
    
    // AI turn function
    func aiTurn() {
        
        // Making the arrays
        var balanceable: [Element] = []
        var transformable: [Element] = []
        // Setting the arrays
        for elements in [self.ai.wood!, self.ai.fire!, self.ai.earth!, self.ai.water!, self.ai.metal!] {
            if elements.health > 0 {
                transformable.append(elements)
                let balance : [Element.element : Element] = [.wood: self.ai.earth, .fire: self.ai.metal, .earth: self.ai.water, .water: self.ai.fire, .metal: self.ai.wood]
                if balance[elements.type]!.health > 0 {
                    balanceable.append(balance[elements.type]!)
                }
            }
        }
        if balanceable.count > 0 && arc4random_uniform(2) == 0 {
            self.aiBalance(balanceable)
            self.resetElementHealth()
            self.lastElementsTransformed = []
        } else  {
            self.aiTransform(transformable)
            self.resetElementHealth()
        }
        self.turnsAllowed += 1
        
        
    }
    
    func setaiBoard() {
        let reenableInteraction = SKAction.run {
            self.isUserInteractionEnabled = true
            print("re-enabled")
        }
        for x in 0 ..< numberOfMovesaiTakes {
            let move = SKAction.run {
                self.aiTurn()
            }
            let delay = SKAction.wait(forDuration: TimeInterval(2*x))
            var seqArray = [delay, move]
            if x == numberOfMovesaiTakes-1 {
                seqArray.append(reenableInteraction)
            }
            let seq = SKAction.sequence(seqArray)
            self.run(seq)
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
    
    func labelShow(element: Element) {
        var element = element
        for elements in [player.wood, player.water, player.fire, player.earth, player.metal] {
            if element == elements! {
                let label = childNode(withName: "player\(element.type)Label")
                label?.isHidden = false
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
        if self.gameState == .active {
            if objectGrabbed != nil && objectGrabbed.belongsTo == .human {
                if objectMovable == true {
                    objectGrabbed.position = (touches.first?.location(in: self))!
                }
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
                if self.gameState == .active {
                    if object1Locked && object2Locked {
                        if Element.strengthens[e1.type] == e2.type {
                            let change = ElementChange(position: e2.position, text: "+")
                            animateElement(e2.type, object: effect, label: change)
                            animateHealth(e1: e2, e2: e1, add: true)
                            playerAction = "\(e2.type.rawValue)Strengthened"
                            resetElementHealth()
                            resetElements()
                            if self.gameMode == .untimed {
                                movesTaken += 1
                                appendArrays()
                            }
                        } else if Element.strengthens[e2.type] == e1.type {
                            let change = ElementChange(position: e1.position, text: "+")
                            animateElement(e1.type, object: effect, label: change)
                            animateHealth(e1: e1, e2: e2, add: true)
                            playerAction = "\(e1.type.rawValue)Strengthened"
                            resetElementHealth()
                            resetElements()
                            if self.gameMode == .untimed {
                                movesTaken += 1
                                appendArrays()
                            }
                            
                        } else if Element.damagedBy[e1.type] == e2.type {
                            
                            let change = ElementChange(position: e1.position, text: "-")
                            animateElement(e1.type, object: effect, label: change)
                            animateHealth(e1: e1, e2: e2, add: false)
                            print(e1.type.rawValue)
                            playerAction = "\(e1.type.rawValue)Weakened"
                            print(playerAction)
                            resetElementHealth()
                            resetElements()
                            if self.gameMode == .untimed {
                                movesTaken += 1
                                appendArrays()
                            }
                        } else if Element.damagedBy[e2.type] == e1.type {
                            
                            let change = ElementChange(position: e2.position, text: "-")
                            animateElement(e2.type, object: effect, label: change)
                            animateHealth(e1: e2, e2: e1, add: false)
                            print(e1.type.rawValue)
                            playerAction = "\(e2.type.rawValue)Weakened"
                            print(playerAction)
                            resetElementHealth()
                            resetElements()
                            if self.gameMode == .untimed {
                                movesTaken += 1
                                appendArrays()
                            }
                        }
                        
                        
                        // SKADOODLE
                        if self.gameState == .active {
                            if self.gameMode == .untimed {
                                if playerAction != aiActions[movesTaken - 1] {
                                    movesTaken -= 1
                                    lastUntimedMove = movesTaken
                                    background1.isHidden = true
                                    background2.isHidden = false
                                    self.hintButton.isHidden = true
                                    self.undoButton.isHidden = false
                                    self.startLabel.isHidden = true
                                    self.gameMode = .timed
                                    
                                }
                            }
                        }
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
        
        // setting ai moves
        numberOfMovesaiTakes = gamesCompleted + 1
        
        // hiding gems > player health values
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
        
        /*for label in [playerWoodLabel, playerWaterLabel, playerFireLabel, playerEarthLabel, playerMetalLabel] {
         
         if label?.parent == objectGrabbed || label?.parent == elementLockedIn1 || label?.parent == elementLockedIn2 {
         label?.isHidden = false
         } else {
         label?.isHidden = true
         }
         
         }*/
        
        if self.gameMode == .untimed {
            for (opponent, player) in [ai.wood : player.wood, ai.fire : player.fire, ai.earth : player.earth, ai.metal : player.metal, ai.water : player.water] {
                if let player = player {
                    let labels: [Element.element : SKLabelNode] = [.wood : aiWoodLabel, .fire : aiFireLabel, .earth : aiEarthLabel, .metal : aiMetalLabel, .water : aiWaterLabel]
                    if let label = labels[opponent.type] {
                        if opponent.health == player.health {
                            label.fontColor = .black
                        } else {
                            label.fontColor = .white
                        }
                    }
                }
            }
        }
        
        // label updates
        aiWoodLabel.text = String(ai.wood.health)
        aiFireLabel.text = String(ai.fire.health)
        aiEarthLabel.text = String(ai.earth.health)
        aiMetalLabel.text = String(ai.metal.health)
        aiWaterLabel.text = String(ai.water.health)
        playerWoodLabel.text = String(player.wood.health)
        playerFireLabel.text = String(player.fire.health)
        playerEarthLabel.text = String(player.earth.health)
        playerMetalLabel.text = String(player.metal.health)
        playerWaterLabel.text = String(player.water.health)
        
    }
    
    func appendArrays() {
        
        playerFireHealths.append(player.fire.health)
        playerWoodHealths.append(player.wood.health)
        playerEarthHealths.append(player.earth.health)
        playerMetalHealths.append(player.metal.health)
        playerWaterHealths.append(player.water.health)
        
    }
    
    func emptyArrays() {
        playerFireHealths = []
        playerWoodHealths = []
        playerEarthHealths = []
        playerMetalHealths = []
        playerWaterHealths = []
    }
    
    func animateElement(_ type: Element.element, object objectToAnimate: Element, label: ElementChange) {
        
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
        let seq = SKAction.sequence([appear, animate!, disappear, delay])
        self.addChild(label)
        label.fontName = String(describing: UIFont.boldSystemFont(ofSize: 48))
        objectToAnimate.run(seq)
        label.run(SKAction.sequence([SKAction.unhide(),SKAction.wait(forDuration: 1),/*SKAction.removeFromParent()*/]))
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
                if self.player.wood.health == self.ai.wood.health && self.player.fire.health == self.ai.fire.health && self.player.earth.health == self.ai.earth.health && self.player.metal.health == self.ai.metal.health && self.player.water.health == self.ai.water.health && self.movesTaken == self.turnsAllowed {
                    self.startLabel.isHidden = false
                    self.startLabel.text = "Success"
                    self.hintButton.isHidden = true
                    self.gamesCompleted += 1
                    self.setBoardButton.isHidden = false
                    self.gameState = .inactive
                    self.turnsAllowed = 0
                    self.aiActions = []
                    self.hintElements = []
                    self.emptyArrays()
                    self.movesTaken = 0
                } else if self.turnsAllowed == 0 {
                    self.gamesCompleted = 0
                    self.startLabel.isHidden = false
                    self.startLabel.text = "Fail"
                    self.hintButton.isHidden = true
                    self.restartButton.isHidden = false
                    self.turnsAllowed = 0
                    self.gameState = .inactive
                    self.aiActions = []
                    self.hintElements = []
                    self.emptyArrays()
                    self.movesTaken = 0
                }
            }
        }
        let seq = SKAction.sequence([delay, anAction])
        effect.run(seq)
        
        
        
    }
    
    
    
    
}
