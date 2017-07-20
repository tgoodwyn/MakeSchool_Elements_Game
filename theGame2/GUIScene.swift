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
    var gameState: gameState = .inactive
    var playerStartingElement: Element!
    var opponentStartingElement: Element!
    var player = Player(playerName: .human)
    var opponent = Player(playerName: .AI)
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
    var objectGrabbed: SKShapeNode!
    var objectMovable:Bool = true
    
    override func didMove(to view: SKView) {
        // set game state to inactive
        self.gameState = .inactive

        // initial player set up
        playerStartingElement = player.wood
        opponentStartingElement = opponent.fire
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
        for elements in [opponent.wood, opponent.fire, opponent.earth, opponent.water, opponent.metal] {
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
                opponent.fire.health += 1
                opponentActionLabel.text = "opponent regenerates"
            } else {
                opponentTransform(transformable)
                opponentActionLabel.text = "opponent transforms"
            }
        } else {
            opponent.fire.health += 1
            opponentActionLabel.text = "opponent regenerates"
        }
        playerTurn = true
    }
    
    override func update(_ currentTime: TimeInterval) {
        if playerTurn == false {
            opponentTurn()
        }
        // resetting any negative elements to zero
        for elements in [opponent.wood, opponent.fire, opponent.earth, opponent.water, opponent.metal, player.wood, player.fire, player.earth, player.water, player.metal] {
            
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
}
    
    

