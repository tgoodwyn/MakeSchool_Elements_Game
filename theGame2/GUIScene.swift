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
 
    
    var player = Player()
    var opponent = Player()
    var opponentActionLabel: SKLabelNode!
    var victoryLabel: SKLabelNode!
    var defeatLabel: SKLabelNode!
    var turnCountLabel: SKLabelNode!
    var resetHighScoreButton: MSButtonNode!
    var turnsTaken: Int = 0 {
        didSet {
            turnCountLabel.text = String(turnsTaken)
        }
    }
    var finalScore = 0
    var highScoreTurnsLabel: SKLabelNode!
    var highScore: Int {
        get {
            return UserDefaults.standard.integer(forKey: "highScore")
        }
        set(high) {
            UserDefaults.standard.set(high, forKey: "highScore")
        }
    }
    var resetButton: MSButtonNode!
    var generateButton: MSButtonNode!
    var playerTurn: Bool = true
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
  
    var nodeToHide1: SKSpriteNode!
    var nodeToHide2: SKSpriteNode!
    var nodeToHide3: SKSpriteNode!
    
    var referenceButton: MSButtonNode!
    
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
        
        nodeToHide1 = childNode(withName: "nodeToHide1") as! SKSpriteNode
        nodeToHide2 = childNode(withName: "nodeToHide2") as! SKSpriteNode
        nodeToHide3 = childNode(withName: "nodeToHide3") as! SKSpriteNode
        
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
        
        playerElement1.position =
            CGPoint(x: size.width / 4,
                    y: size.height / 2  + distance)
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
            CGPoint(x: size.width * 3 / 4,
                    y: size.height / 2 + distance)
        opponentElement2.position =
            CGPoint(x: opponentElement1.position.x + distance * sin(54 * .pi / 180),
                    y: opponentElement1.position.y - distance * cos(54 * .pi / 180))
        opponentElement3.position =
            CGPoint(x: opponentElement2.position.x - distance * cos(72 * .pi / 180),
                    y: opponentElement2.position.y - distance * sin(72 * .pi / 180))
        opponentElement4.position =
            CGPoint(x: opponentElement3.position.x - distance,
                    y: opponentElement3.position.y)
        opponentElement5.position =
            CGPoint(x: opponentElement4.position.x - distance * sin(18 * .pi / 180),
                    y: opponentElement4.position.y + distance * cos(18 * .pi / 180))
        
        
        // opponentActionLabel = childNode(withName: "opponentAction") as! SKLabelNode
        victoryLabel = childNode(withName: "victoryLabel") as! SKLabelNode
        defeatLabel = childNode(withName: "defeatLabel") as! SKLabelNode
        turnCountLabel = childNode(withName: "turnCountLabel") as! SKLabelNode
        resetButton = childNode(withName: "resetButton") as! MSButtonNode
        
        self.victoryLabel.isHidden = true
        self.defeatLabel.isHidden = true
        self.resetButton.isHidden = true
        
        generateButton = childNode(withName: "generateButton") as! MSButtonNode
        
        resetButton.selectedHandler = {
            
            self.opponent.fire.health = 0
            self.opponent.wood.health = 0
            self.opponent.earth.health = 0
            self.opponent.metal.health = 0
            self.opponent.water.health = 0
            
            
            self.player.wood.health = 0
            self.player.fire.health = 0
            self.player.earth.health = 0
            self.player.metal.health = 0
            self.player.water.health = 0
            
            self.turnsTaken = 0
            self.resetButton.isHidden = true
            
            self.defeatLabel.isHidden = true
            self.victoryLabel.isHidden = true
        }
        
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
                nextElement.type = Element.damages[player.startingType]!
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
        generateButton.selectedHandler = {
            self.gameState = .active
            self.player.element(self.player.startingType).health += 1
            self.turnsTaken += 1
            self.delayAnimation()
            self.playerTurn = false
            
            
            
        }
        
    }
    
    // UI animation functions
    func delayAnimation() {
        let hide = SKAction.hide()
        let delay = SKAction.wait(forDuration: 0.5)
        let unhide = SKAction.unhide()
        let sequence = SKAction.sequence([hide,delay,unhide])
        
        nodeToHide1.run(sequence)
        nodeToHide2.run(sequence)
        nodeToHide3.run(sequence)
    }
    
    
    // AI action functions
    func opponentTransform(_ elementsToTransform: [Element]) {
        let selectedElement = elementsToTransform[Int(arc4random_uniform(UInt32(elementsToTransform.count)))]
        let transformed: [Element.element : Element] = [.earth: opponent.metal, .metal: opponent.water, .water: opponent.wood, .wood: opponent.fire, .fire: opponent.earth]
        transformed[selectedElement.type]!.health += selectedElement.health
        selectedElement.health = 0
    }
    
    func opponentBalance(_ elementsToBalance: [Element]) {
        let selectedElement = elementsToBalance[Int(arc4random_uniform(UInt32(elementsToBalance.count)))]
        let opponentElement : [Element.element : Element] = [.earth: opponent.wood, .metal: opponent.fire, .water: opponent.earth, .wood: opponent.metal, .fire: opponent.water]
        selectedElement.health -= opponentElement[selectedElement.type]!.health
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
                let balance : [Element.element : Element] = [.wood: player.earth, .fire: player.metal, .earth: player.water, .water: player.fire, .metal: player.wood]
                if balance[elements.type]!.health > 0 {
                    balanceable.append(balance[elements.type]!)
                }
            }
        }
        // Determining action opponent takes
        if balanceable.count > 0 {
            if turnsTaken % 3 == 0 {
                opponentBalance(balanceable)
                // opponentActionLabel.text = "opponent regenerates"
            } else {
                opponent.element(opponent.startingType).health += 1
                // opponentActionLabel.text = "opponent transforms"
            }

            
            // taking action
            
            // opponentActionLabel.text = "opponent balances"
        } else if transformable.count > 0 {
            
            if turnsTaken % 3 == 0 || turnsTaken % 3 == 1 {
                opponent.element(opponent.startingType).health += 1
                // opponentActionLabel.text = "opponent regenerates"
            } else {
                opponentTransform(transformable)
                // opponentActionLabel.text = "opponent transforms"
            }
        } else {
            opponent.element(opponent.startingType).health += 1
            // opponentActionLabel.text = "opponent regenerates"
        }
        playerTurn = true
    }
    
    // continuous update function - where health values are reset and game over condition is checked
    override func update(_ currentTime: TimeInterval) {
        if playerTurn == false {
            opponentTurn()
        }
        // resetting any negative elements to zero
        for elements in [opponent.wood!, opponent.fire!, opponent.earth!, opponent.water!, opponent.metal!, player.wood!, player.fire!, player.earth!, player.water!, player.metal!] {
            
            if elements.health < 0 {
                elements.health = 0
            }
        }
        // game over condition
        if self.gameState == .active {
            if player.wood.health >= 3 && player.fire.health >= 4 && player.earth.health >= 1 && player.metal.health >= 5 && player.water.health == 2 {
                self.resetButton.isHidden = false
                self.victoryLabel.isHidden = false
                self.gameState = .inactive
                print("game over")
            }
            if player.wood.health == 0 && player.fire.health == 0 && player.earth.health == 0 && player.metal.health == 0 && player.water.health == 0 {
                self.resetButton.isHidden = false
                self.defeatLabel.isHidden = false
                self.gameState = .inactive
            }
        }
        
        
        
      
    }

    func resetHighScore() {
        highScore = 0
        self.highScoreTurnsLabel.text = "\(self.highScore)"
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        print("collide")
        
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
         // supporting interactions
        if playerElement1 != nil && playerElement2 != nil {
            if Element.strengthens[playerElement1!.type] == playerElement2!.type {
                playerElement2!.health += playerElement1!.health
                playerElement1!.health = 0
                turnsTaken += 1
                playerTurn = false
            } else if Element.strengthens[playerElement2!.type] == playerElement1!.type {
                playerElement1!.health += playerElement2!.health
                playerElement2!.health = 0
                turnsTaken += 1
                playerTurn = false
            }
        }
        // damaging interactions
        if playerElement1 != nil && opponentElement1 != nil {
            if Element.damagedBy[opponentElement1!.type] == playerElement1!.type {
                opponentElement1!.health -= playerElement1!.health
                turnsTaken += 1
                playerTurn = false
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
    
    

