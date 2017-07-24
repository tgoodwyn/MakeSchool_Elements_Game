//
//  GameScene.swift
//  theGame
//
//  Created by Tyler Goodwyn on 7/16/17.
//  Copyright © 2017 Tyler Goodwyn. All rights reserved.
//

import SpriteKit
import Foundation

class GameScene: SKScene, SKPhysicsContactDelegate {
    
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
    
    var playerTurn: Bool = true
    
    var objectGrabbed: SKShapeNode!
    var objectMovable:Bool = true
    
    var greenCircle: SKShapeNode!
    var redCircle: SKShapeNode!
    var yellowCircle: SKShapeNode!
    var blackCircle: SKShapeNode!
    var blueCircle: SKShapeNode!
    
    
    var greenCenter: CGPoint!
    var redCenter: CGPoint!
    var yellowCenter: CGPoint!
    var blackCenter: CGPoint!
    var blueCenter: CGPoint!
    var greenCenter2: CGPoint!
    
    
    var opponentGreenCircle: SKShapeNode!
    var opponentRedCircle: SKShapeNode!
    var opponentYellowCircle: SKShapeNode!
    var opponentBlackCircle: SKShapeNode!
    var opponentBlueCircle: SKShapeNode!
    
    
    var resetButton: MSButtonNode!
    
    var generateButton: MSButtonNode!
    
    
    override func didMove(to view: SKView) {
        
        highScoreTurnsLabel = childNode(withName: "highScoreTurnsLabel") as! SKLabelNode
        highScoreTurnsLabel.text = ("\(highScore)")
        
        
        greenCenter = CGPoint(x: 75, y: 500)
        redCenter = CGPoint(x: 75, y: 425)
        yellowCenter = CGPoint(x: 75, y: 350)
        blackCenter = CGPoint(x: 75, y: 275)
        blueCenter = CGPoint(x: 75, y: 200)
        greenCenter2 = CGPoint(x: 75, y: 125)
        
        makeLabel(location: CGPoint(x: 260, y: 500), text: opponent.earth.health, name: "opponentYellowLabel")
        makeLabel(location: CGPoint(x: 260, y: 425), text: opponent.metal.health, name: "opponentBlackLabel")
        makeLabel(location: CGPoint(x: 260, y: 350), text: opponent.water.health, name: "opponentBlueLabel")
        makeLabel(location: CGPoint(x: 260, y: 275) , text: opponent.wood.health, name: "opponentGreenLabel")
        makeLabel(location: CGPoint(x: 260, y: 200), text: opponent.fire.health, name: "opponentRedLabel")
        
        
        
        makeLabel(location: CGPoint(x: greenCenter.x - 10, y: greenCenter.y) , text: player.wood.health, name: "greenLabel")
        makeLabel(location: CGPoint(x: redCenter.x - 10, y: redCenter.y), text: player.fire.health, name: "redLabel")
        makeLabel(location: CGPoint(x: yellowCenter.x - 10, y: yellowCenter.y), text: player.earth.health, name: "yellowLabel")
        makeLabel(location: CGPoint(x: blackCenter.x - 10, y: blackCenter.y), text: player.metal.health, name: "blackLabel")
        makeLabel(location: CGPoint(x: blueCenter.x - 10, y: blueCenter.y), text: player.water.health, name: "blueLabel")
        
        player.greenLabel = childNode(withName: "greenLabel") as! SKLabelNode
        player.redLabel = childNode(withName: "redLabel") as! SKLabelNode
        player.yellowLabel = childNode(withName: "yellowLabel") as! SKLabelNode
        player.blackLabel = childNode(withName: "blackLabel") as! SKLabelNode
        player.blueLabel = childNode(withName: "blueLabel") as! SKLabelNode
        
        
        opponent.greenLabel = childNode(withName: "opponentGreenLabel") as! SKLabelNode
        opponent.redLabel = childNode(withName: "opponentRedLabel") as! SKLabelNode
        opponent.yellowLabel = childNode(withName: "opponentYellowLabel") as! SKLabelNode
        opponent.blackLabel = childNode(withName: "opponentBlackLabel") as! SKLabelNode
        opponent.blueLabel = childNode(withName: "opponentBlueLabel") as! SKLabelNode
        
        resetButton = childNode(withName: "resetButton") as! MSButtonNode
        
        generateButton = childNode(withName: "generateButton") as! MSButtonNode
        
        resetHighScoreButton = childNode(withName: "resetHighScoreButton") as! MSButtonNode
        
        
        self.gameState = .inactive
        
        generateButton.selectedHandler = {
            
            self.playerStartingElement.health += 1
            self.turnsTaken += 1
            self.playerTurn = false
            
            self.gameState = .active
            self.victoryLabel.isHidden = true
            
        }
        
        resetButton.isHidden = true
        
        resetButton.selectedHandler = {
            
            self.opponent.fire.health = 5
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
        }
        
        
        resetHighScoreButton.selectedHandler = {
            self.resetHighScore()
        }
        
        // circle stuff
        
        makeCircle(location: greenCenter, color: .green, name: "greenCircle")
        makeCircle(location: redCenter, color: .red, name: "redCircle")
        makeCircle(location: yellowCenter, color: .orange, name: "yellowCircle")
        makeCircle(location: blackCenter, color: .black, name: "blackCircle")
        makeCircle(location: blueCenter, color: .blue, name: "blueCircle")
        
        
        makeCircle(location: CGPoint(x: 250, y: 500), color: .orange, name: "opponentYellowCircle")
        makeCircle(location: CGPoint(x: 250, y: 425), color: .black, name: "opponentBlackCircle")
        makeCircle(location: CGPoint(x: 250, y: 350), color: .blue, name: "opponentBlueCircle")
        makeCircle(location: CGPoint(x: 250, y: 275), color: .green, name: "opponentGreenCircle")
        makeCircle(location: CGPoint(x: 250, y: 200), color: .red, name: "opponentRedCircle")
        
        yellowCircle = childNode(withName: "opponentYellowCircle") as! SKShapeNode
        blackCircle = childNode(withName: "opponentBlackCircle") as! SKShapeNode
        blueCircle = childNode(withName: "opponentBlueCircle") as! SKShapeNode
        greenCircle = childNode(withName: "opponentGreenCircle") as! SKShapeNode
        redCircle = childNode(withName: "opponentRedCircle") as! SKShapeNode
        
        
        greenCircle = childNode(withName: "greenCircle") as! SKShapeNode
        redCircle = childNode(withName: "redCircle") as! SKShapeNode
        yellowCircle = childNode(withName: "yellowCircle") as! SKShapeNode
        blackCircle = childNode(withName: "blackCircle") as! SKShapeNode
        blueCircle = childNode(withName: "blueCircle") as! SKShapeNode
        
        
        opponentActionLabel = childNode(withName: "opponentAction") as! SKLabelNode
        victoryLabel = childNode(withName: "victoryLabel") as! SKLabelNode
        defeatLabel = childNode(withName: "defeatLabel") as! SKLabelNode
        turnCountLabel = childNode(withName: "turnCountLabel") as! SKLabelNode
        
        
        
        self.victoryLabel.isHidden = true
        self.defeatLabel.isHidden = true
        
        
        /*
         playerWood = player.wood
         playerFire = player.fire
         playerEarth = player.earth
         playerMetal = player.metal
         playerWater = player.water
         
         opponentWood = opponent.wood
         opponentFire = opponent.fire
         opponentEarth = opponent.earth
         opponentMetal = opponent.metal
         opponentWater = opponent.water
         */
        
        playerStartingElement = player.wood
        opponentStartingElement = opponent.fire
        
        opponent.setup()
        player.setup()
        
        opponent.fire.health = 5
        
        
        // randomizeOpponentStartingElement()
        
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
        var balanceable: [Element] = []
        var transformable: [Element] = []
        
        for elements in [opponent.wood, opponent.fire, opponent.earth, opponent.water, opponent.metal] {
            
            if elements.health > 0 {
                transformable.append(elements)
                let balance : [Element.element : Element] = [.wood: player.earth, .fire: player.metal, .earth: player.water, .water: player.fire, .metal: player.wood]
                if balance[elements.type]!.health > 0 {
                    balanceable.append(balance[elements.type]!)
                }
            }
            
        }
        
        
        
        
        
        
        print(balanceable)
        // print()
        
        if balanceable.count > 0 {
            
            
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
            
        }
            
        else
            
        {
            opponent.fire.health += 1
            opponentActionLabel.text = "opponent regenerates"
            
        }
        
        playerTurn = true
        
        
        
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
        if playerTurn == false {
            opponentTurn()
        }
        
        for elements in [opponent.wood, opponent.fire, opponent.earth, opponent.water, opponent.metal, player.wood, player.fire, player.earth, player.water, player.metal] {
            
            if elements.health < 0 {
                elements.health = 0
            }
        }
        
        
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
        
        turnCountLabel.text = String(turnsTaken)
        
        
        
    }
    
    
    func resetHighScore() {
        highScore = 0
        self.highScoreTurnsLabel.text = "\(self.highScore)"
    }
    
    
    
    
    
    
    
    // Contact and Touch functions
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        objectMovable = false
        
        // supporting interactions
        if (contact.bodyA.node?.name == "greenCircle" || contact.bodyB.node?.name == "greenCircle")
            && (contact.bodyA.node?.name == "redCircle" || contact.bodyB.node?.name == "redCircle") {
            player.fire.health += player.wood.health
            player.wood.health = 0
            
            turnsTaken += 1
            playerTurn = false
            
        }
        if (contact.bodyA.node?.name == "redCircle" || contact.bodyB.node?.name == "redCircle")
            && (contact.bodyA.node?.name == "yellowCircle" || contact.bodyB.node?.name == "yellowCircle") {
            player.earth.health += player.fire.health
            player.fire.health = 0
            
            turnsTaken += 1
            playerTurn = false
            
        }
        if (contact.bodyA.node?.name == "yellowCircle" || contact.bodyB.node?.name == "yellowCircle")
            && (contact.bodyA.node?.name == "blackCircle" || contact.bodyB.node?.name == "blackCircle") {
            player.metal.health += player.earth.health
            player.earth.health = 0
            
            turnsTaken += 1
            playerTurn = false
        }
        if (contact.bodyA.node?.name == "blackCircle" || contact.bodyB.node?.name == "blackCircle")
            && (contact.bodyA.node?.name == "blueCircle" || contact.bodyB.node?.name == "blueCircle") {
            player.water.health += player.metal.health
            player.metal.health = 0
            
            turnsTaken += 1
            playerTurn = false
        }
        if (contact.bodyA.node?.name == "blueCircle" || contact.bodyB.node?.name == "blueCircle")
            && (contact.bodyA.node?.name == "greenCircle" || contact.bodyB.node?.name == "greenCircle") {
            player.wood.health += player.water.health
            player.water.health = 0
            
            turnsTaken += 1
            playerTurn = false
        }
        
        
        // damaging interactions
        if (contact.bodyA.node?.name == "greenCircle" || contact.bodyB.node?.name == "greenCircle")
            && (contact.bodyA.node?.name == "opponentYellowCircle" || contact.bodyB.node?.name == "opponentYellowCircle") {
            opponent.earth.health -= player.wood.health
            
            turnsTaken += 1
            
            playerTurn = false
            
            turnsTaken += 1
        }
        if (contact.bodyA.node?.name == "yellowCircle" || contact.bodyB.node?.name == "yellowCircle")
            && (contact.bodyA.node?.name == "opponentBlueCircle" || contact.bodyB.node?.name == "opponentBlueCircle") {
            opponent.water.health -= player.earth.health
            playerTurn = false
            
            turnsTaken += 1
        }
        if (contact.bodyA.node?.name == "blueCircle" || contact.bodyB.node?.name == "blueCircle")
            && (contact.bodyA.node?.name == "opponentRedCircle" || contact.bodyB.node?.name == "opponentRedCircle") {
            opponent.fire.health -= player.water.health
            
            playerTurn = false
            
            turnsTaken += 1
        }
        if (contact.bodyA.node?.name == "redCircle" || contact.bodyB.node?.name == "redCircle")
            && (contact.bodyA.node?.name == "opponentBlackCircle" || contact.bodyB.node?.name == "opponentBlackCircle") {
            opponent.metal.health -= player.fire.health
            playerTurn = false
            
            turnsTaken += 1
        }
        if (contact.bodyA.node?.name == "blackCircle" || contact.bodyB.node?.name == "blackCircle")
            && (contact.bodyA.node?.name == "opponentGreenCircle" || contact.bodyB.node?.name == "opponentGreenCircle") {
            opponent.wood.health -= player.metal.health
            playerTurn = false
            
            turnsTaken += 1
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        objectMovable = true
        let touch = touches.first!
        let location = touch.location(in: self)
        let nodeAtPoint = atPoint(location)
        if nodeAtPoint.name == "greenCircle" || nodeAtPoint.name == "redCircle" || nodeAtPoint.name == "yellowCircle" || nodeAtPoint.name == "blackCircle" || nodeAtPoint.name == "blueCircle" {
            objectGrabbed = atPoint(location) as! SKShapeNode
        } else {
            objectGrabbed = nil
        }
        
        physicsWorld.contactDelegate = self
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if objectGrabbed != nil {
            
            if objectGrabbed.name == "greenCircle" {
                player.greenLabel.fontColor = .black
                
            }
            if objectGrabbed.name == "redCircle" {
                player.redLabel.fontColor = .black
                
            }
            if objectGrabbed.name == "yellowCircle" {
                player.yellowLabel.fontColor = .black
            }
            if objectGrabbed.name == "blackCircle" {
                player.blackLabel.fontColor = .black
            }
            if objectGrabbed.name == "blueCircle" {
                player.blueLabel.fontColor = .black
            }
            
            if objectMovable == true {
                objectGrabbed.position = (touches.first?.location(in: self))!
            }
            
        }
        
    }
    
    
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        greenCircle.position = greenCenter
        redCircle.position = redCenter
        yellowCircle.position = yellowCenter
        blackCircle.position = blackCenter
        blueCircle.position = blueCenter
        
        player.greenLabel.fontColor = .white
        player.redLabel.fontColor = .white
        player.yellowLabel.fontColor = .white
        player.blackLabel.fontColor = .white
        player.blueLabel.fontColor = .white
        
    }
    
    
    
    
    
    // helper functions
    
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
    
    func makeLabel(location: CGPoint, text: Int, name: String) {
        
        let label = SKLabelNode()
        label.text = String(text)
        label.position = location
        label.fontColor = .white
        label.fontSize = 24
        label.fontName = "Arial"
        label.zPosition = 2
        label.name = name
        
        label.isUserInteractionEnabled = false
        self.addChild(label)
        
    }
    
    
}

/*
 
 func randomizeOpponentStartingElement() {
 
 let rngVal = Int(arc4random_uniform(5))
 
 if rngVal == 0 {
 opponentStartingElement.type = .wood
 opponentStartingElement.label = opponent.greenLabel
 }
 
 if rngVal == 1 {
 opponentStartingElement.type = .fire
 opponentStartingElement.label = opponent.redLabel
 }
 
 if rngVal == 2 {
 opponentStartingElement.type = .earth
 opponentStartingElement.label = opponent.yellowLabel
 }
 
 if rngVal == 3 {
 opponentStartingElement.type = .metal
 opponentStartingElement.label = opponent.blackLabel
 }
 
 if rngVal == 4 {
 opponentStartingElement.type = .water
 opponentStartingElement.label = opponent.blueLabel
 }
 
 }
 */


/*
 if opponentAvailableTransformableElements.count > 0 && opponentBalancableElements.count > 0 {
 
 
 if turnsTaken % 3 == 0 {
 opponentStartingElement.health += 1
 opponentActionLabel.text = "opponent regenerates"
 } else if turnsTaken % 3 == 2 {
 opponentTransform()
 opponentActionLabel.text = "opponent transforms"
 } else {
 opponentBalance()
 opponentActionLabel.text = "opponent balances"
 
 }
 } else if opponentAvailableTransformableElements.count > 0 {
 
 if turnsTaken % 2 == 0 {
 opponentStartingElement.health += 1
 opponentActionLabel.text = "opponent regenerates"
 }
 
 else  {
 opponentTransform()
 opponentActionLabel.text = "opponent transforms"
 }
 
 } else if opponentBalancableElements.count > 0 {
 
 if turnsTaken % 2 == 0 {
 opponentStartingElement.health += 1
 opponentActionLabel.text = "opponent regenerates"
 }
 
 else  {
 opponentBalance()
 opponentActionLabel.text = "opponent transforms"
 }
 
 
 }
 
 else {
 opponentStartingElement.health += 1
 opponentActionLabel.text = "no transform available"
 
 }
 */

/*
 
 
 var playerWood: Element!
 var playerFire: Element!
 var playerEarth: Element!
 var playerMetal: Element!
 var playerWater: Element!
 
 var opponentWood: Element!
 var opponentFire: Element!
 var opponentEarth: Element!
 var opponentMetal: Element!
 var opponentWater: Element!
 
 */

