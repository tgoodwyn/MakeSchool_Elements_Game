//
//  GameScene.swift
//  theGame
//
//  Created by Tyler Goodwyn on 7/16/17.
//  Copyright © 2017 Tyler Goodwyn. All rights reserved.
//

import SpriteKit
import Foundation

class GUIScene: SKScene, SKPhysicsContactDelegate {
    
    enum gameState {
        case active, inactive
    }
    
    let black = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 1)
    
    var gameState: gameState = .inactive
 
    var lastElementsTransformed: [Element.element] = []
    
    var player = Player()
    var opponent = Player()
    var opponentActionLabel: SKLabelNode!
    var victoryLabel: SKLabelNode!
    
    
 
    
    var highScoreLabel: SKLabelNode!
    var highScore: Int {
        get {
            return UserDefaults.standard.integer(forKey: "highScore")
        }
        set(high) {
            UserDefaults.standard.set(high, forKey: "highScore")
        }
    }
    
    var turnCountLabel: SKLabelNode!
    var turnsAllowed: Int = 0 {
        didSet {
            turnCountLabel.text = String(turnsAllowed)
            if turnsAllowed > highScore {
                highScore = turnsAllowed
                self.highScoreLabel.text = "\(self.highScore)"
            }
        }
    }
    
    var gamesCompleted: Int = 0
    var numberOfMovesOpponentTakes: Int = 0
    
    var nextGameButton: MSButtonNode!

    var objectGrabbed: Element!
    var objectMovable:Bool = true
    
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
  
    var startLabel: SKLabelNode!
    
    var referenceButton: MSButtonNode!
    
    var setBoardButton: MSButtonNode!
    
    override func didMove(to view: SKView) {
        // set game state to inactive
        self.gameState = .inactive
        
        
        
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
        
        // high score label
        highScoreLabel = childNode(withName: "highScoreLabel") as! SKLabelNode
        highScoreLabel.text = ("\(highScore)")
        
        startLabel = childNode(withName: "startLabel") as! SKLabelNode
       
        referenceButton = childNode(withName: "referenceButton") as! MSButtonNode
        
        referenceButton.selectedHandler = {
            
            SKTransition.flipVertical(withDuration: 0)
            
            if let view = self.view as! SKView? {
                // Load the SKScene from 'GameScene.sks'
                if let scene = ReferenceScene(fileNamed: "ReferenceScene") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    scene.guiScene = self
                    // Present the scene
                    view.presentScene(scene)
                }
            }
        }
        
        let distance: CGFloat = 200
        let distance2: CGFloat = 125
        
        
        playerElement1.position =
            CGPoint(x: size.width / 2,
                    y: size.height * 3 / 4 + distance2 + 40)
        playerElement2.position =
            CGPoint(x: playerElement1.position.x + distance * sin(54 * .pi / 180),
                    y: playerElement1.position.y - distance * cos(54 * .pi / 180))
        playerElement3.position =
            CGPoint(x: playerElement2.position.x - distance * cos(72 * .pi / 180),
                    y: playerElement2.position.y - distance * sin(72 * .pi / 180))
        playerElement4.position =
            CGPoint(x: playerElement3.position.x - distance,
                    y: playerElement3.position.y)
        playerElement5.position =
            CGPoint(x: playerElement4.position.x - distance * sin(18 * .pi / 180),
                    y: playerElement4.position.y + distance * cos(18 * .pi / 180))
        
        opponentElement1.position =
            CGPoint(x: size.width / 2,
                    y: size.height / 4 + distance2)
        opponentElement2.position =
            CGPoint(x: opponentElement1.position.x + distance2 * sin(54 * .pi / 180),
                    y: opponentElement1.position.y - distance2 * cos(54 * .pi / 180))
        opponentElement3.position =
            CGPoint(x: opponentElement2.position.x - distance2 * cos(72 * .pi / 180),
                    y: opponentElement2.position.y - distance2 * sin(72 * .pi / 180))
        opponentElement4.position =
            CGPoint(x: opponentElement3.position.x - distance2,
                    y: opponentElement3.position.y)
        opponentElement5.position =
            CGPoint(x: opponentElement4.position.x - distance2 * sin(18 * .pi / 180),
                    y: opponentElement4.position.y + distance2 * cos(18 * .pi / 180))
        
        
        // opponentActionLabel = childNode(withName: "opponentAction") as! SKLabelNode
        victoryLabel = childNode(withName: "victoryLabel") as! SKLabelNode
       
        nextGameButton = childNode(withName: "nextGameButton") as! MSButtonNode
        setBoardButton = childNode(withName: "setBoardButton") as! MSButtonNode
        
        self.victoryLabel.isHidden = true
        self.nextGameButton.isHidden = true
        

        
        turnCountLabel = childNode(withName: "turnCountLabel") as! SKLabelNode
        
        nextGameButton.selectedHandler = {
            self.setOpponentBoard()
            self.nextGameButton.isHidden = true
            self.victoryLabel.isHidden = true
            self.gameState = .active
            
        }
        
        player.startingType = .wood
        
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
            nextElement.color = Element.colors[nextElement.type]!
            nextElement.startingPosition = nextElement.position
            opponent.setElement(nextElement.type, to: nextElement)
            prevType = nextElement.type
        }
      
        
        
        //and so on
        physicsWorld.contactDelegate = self
        // initial player set up
        opponent.setup()
        player.setup()

        resetBoard()
        
        setBoardButton.selectedHandler = {
            self.setOpponentBoard()
            self.gameState = .active
            self.startLabel.isHidden = true
            self.setBoardButton.isHidden = true
            
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
        
/*
 if opponent.wood.health > 50 || opponent.fire.health > 50 || opponent.earth.health > 50 || opponent.metal.health > 50 || opponent.water.health > 50 {
 opponentBalance(balanceable)
 turnsAllowed += 1
 resetElementHealth()
 } else {
 */
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
    
    // continuous update function - where health values are reset and game over condition is checked
    override func update(_ currentTime: TimeInterval) {
       
        numberOfMovesOpponentTakes = gamesCompleted + 1
    
        // game over condition
        if self.gameState == .active {
            if player.wood.health == opponent.wood.health && player.fire.health == opponent.fire.health && player.earth.health == opponent.earth.health && player.metal.health == opponent.metal.health && player.water.health == opponent.water.health {
                victoryLabel.isHidden = false
                gamesCompleted += 1
                nextGameButton.isHidden = false
                self.gameState = .inactive
                turnsAllowed = 0
            } else if turnsAllowed == 0 {
                
                self.startLabel.isHidden = false
                self.startLabel.text = "No"
                self.setBoardButton.isHidden = false
                turnsAllowed = 0
                self.resetBoard()
                self.gameState = .inactive
            }
        }
        
        
      
    }

    func resetElementHealth() {
    
        for elements in [player.wood, player.fire, player.earth, player.metal, player.water, opponent.wood, opponent.fire, opponent.earth, opponent.metal, opponent.water] {
            if (elements?.health)! < 0 {
                elements?.health = abs((elements?.health)!)
            }
    
            if (elements?.health)! >= 10 {
                elements?.health -= 10
            }
        }
    }

    
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        objectMovable = false
       
        let contactNodeA = contact.bodyA.node as! SKSpriteNode
        let contactNodeB = contact.bodyB.node as! SKSpriteNode
        
        
        //var playerRed: SKSpriteNode?
        //if contactNodeA.color = red
        
        // Player squares
        var playerElement1: Element?
        var playerElement2: Element?
        var opponentElement1: Element?
        var opponentElement2: Element?
        
        if let nodeA = contactNodeA as? Element {
            if nodeA.belongsTo == .human {
                playerElement1 = nodeA
            } else {
                opponentElement1 = nodeA
            }
        }
        
        if let nodeB = contactNodeB as? Element {
            if nodeB.belongsTo == .human {
                if playerElement1 == nil {
                    playerElement1 = nodeB
                } else {
                    playerElement2 = nodeB
                }
            } else {
                if opponentElement1 == nil {
                    opponentElement1 = nodeB
                } else {
                    opponentElement2 = nodeB
                }
            }
            
        }
        
        if self.gameState == .active {
             // supporting interactions
            if playerElement1 != nil && playerElement2 != nil {
                if Element.strengthens[playerElement1!.type] == playerElement2!.type {
                    playerElement2!.health += playerElement1!.health
                    resetElementHealth()
                    turnsAllowed -= 1
                } else if Element.strengthens[playerElement2!.type] == playerElement1!.type {
                    playerElement1!.health += playerElement2!.health
                    resetElementHealth()
                    turnsAllowed -= 1
                }
            }
            // damaging interactions
            if playerElement1 != nil && playerElement2 != nil {
                if Element.damagedBy[playerElement1!.type] == playerElement2!.type {
                    playerElement1!.health -= playerElement2!.health
                    resetElementHealth()
                    turnsAllowed -= 1
                } else if Element.damagedBy[playerElement2!.type] == playerElement1!.type {
                    playerElement2!.health -= playerElement1!.health
                    resetElementHealth()
                    turnsAllowed -= 1
                }
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
    
        

}
    
    

