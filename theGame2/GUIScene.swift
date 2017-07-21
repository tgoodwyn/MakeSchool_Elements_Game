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
    var turnsTaken: Int = 0
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
  
    
    override func didMove(to view: SKView) {
        // set game state to inactive
        self.gameState = .inactive
      
        
        var prevType: Element.element?
        for number in 0...4 {
            let nextElement = childNode(withName: "element\(number)") as! Element
            nextElement.belongsTo = .human
            if let unwrappedType = prevType {
                nextElement.type = Element.strengthens[unwrappedType]!
            } else {
                nextElement.type = player.startingType
            }
            nextElement.color = Element.colors[nextElement.type]!
            nextElement.startingPosition = nextElement.position
            nextElement.label = nextElement.childNode(withName: "element\(number)Label") as? SKLabelNode
            nextElement.health = 0
            player.setElement(nextElement.type, to: nextElement)
            prevType = nextElement.type
        }
        
 
        prevType = nil
        for number in 0...4 {
            let nextElement = childNode(withName: "opponentDamages\(number)") as! Element
            if prevType != nil {
                nextElement.type = Element.strengthens[prevType!]!
            } else {
                nextElement.type = Element.damagedBy[player.startingType]!
            }
            nextElement.color = Element.colors[nextElement.type]!
            nextElement.startingPosition = nextElement.position
            prevType = nextElement.type
        }
        
        prevType = nil
        for number in 0...4 {
            let nextElement = childNode(withName: "opponentDamagedBy\(number)") as! Element
            nextElement.belongsTo = .AI
            if prevType != nil {
                nextElement.type = Element.strengthens[prevType!]!
            } else {
                nextElement.type = Element.damages[player.startingType]!
            }
            nextElement.color = Element.colors[nextElement.type]!
            nextElement.startingPosition = nextElement.position
            nextElement.label = nextElement.childNode(withName: "opponent\(number)Label") as? SKLabelNode
            nextElement.health = 0
            opponent.setElement(nextElement.type, to: nextElement)
            prevType = nextElement.type
        }
        
      
        
        //and so on
        physicsWorld.contactDelegate = self
        // initial player set up
        opponent.setup()
        player.setup()
        opponent.fire.health = 5
    }
    
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
            // taking action
            opponentBalance(balanceable)
            opponentActionLabel.text = "opponent balances"
        } else if transformable.count > 0 {
            
            if turnsTaken % 3 == 0 || turnsTaken % 3 == 1 {
                opponent.startingType.health += 1
                opponentActionLabel.text = "opponent regenerates"
            } else {
                opponentTransform(transformable)
                opponentActionLabel.text = "opponent transforms"
            }
        } else {
            opponent.startingType.health += 1
            opponentActionLabel.text = "opponent regenerates"
        }
        playerTurn = true
    }
    
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
            if opponent.wood.health == 0 && opponent.fire.health == 0 && opponent.earth.health == 0 && opponent.metal.health == 0 && opponent.water.health == 0 {
                self.resetButton.isHidden = false
                self.victoryLabel.isHidden = false
                self.gameState = .inactive
                finalScore = turnsTaken
                if finalScore < highScore || highScore == 0 {
                    highScore = finalScore
                }
                self.highScoreTurnsLabel.text = "\(self.highScore)"
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
            print("support")
            if Element.strengthens[playerElement1!.type] == playerElement2!.type {
                playerElement2!.health += playerElement1!.health
                playerElement1!.health = 0
            } else if Element.strengthens[playerElement2!.type] == playerElement1!.type {
                playerElement1!.health += playerElement2!.health
                playerElement2!.health = 0
            }
        }
        // damaging interactions
        if playerElement1 != nil && opponentElement1 != nil {
            print("damage")
            if Element.damages[opponentElement1!.type] == playerElement1!.type {
                opponentElement1!.health -= playerElement1!.health
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
    
    

