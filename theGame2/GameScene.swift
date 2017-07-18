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
    
    
    
    var playerStartingElement: Element!
    var opponentStartingElement: Element!
   
    
    var player = Player(playerName: .human)
    var opponent = Player(playerName: .AI)
    
    var opponentAvailableTransformableElements: [String] = []
    
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
       
    
    var playerTurn: Bool = true
    
    var objectGrabbed: SKShapeNode!
    var objectMovable:Bool = true
    
    var greenCircle: SKShapeNode!
    var redCircle: SKShapeNode!
    var yellowCircle: SKShapeNode!
    var blackCircle: SKShapeNode!
    var blueCircle: SKShapeNode!
    var greenCircle2: SKShapeNode!
    
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
    
    
    var generateButton: MSButtonNode!
    
    
    override func didMove(to view: SKView) {
        
        
        
        
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
        
        
        generateButton = childNode(withName: "generateButton") as! MSButtonNode
        
        
        generateButton.selectedHandler = {
            
            self.playerStartingElement.health += 1
            self.playerTurn = false
            
        }
        
        
        
        // circle stuff
        
        makeCircle(location: greenCenter, color: .green, name: "greenCircle")
        makeCircle(location: redCenter, color: .red, name: "redCircle")
        makeCircle(location: yellowCenter, color: .orange, name: "yellowCircle")
        makeCircle(location: blackCenter, color: .black, name: "blackCircle")
        makeCircle(location: blueCenter, color: .blue, name: "blueCircle")
        makeCircle(location: greenCenter2, color: .green, name: "greenCircle2")
        
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
        greenCircle2 = childNode(withName: "greenCircle2") as! SKShapeNode
        
        
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
        // randomizeOpponentStartingElement()
       
    }
    
    
    func opponentTransform() {
        
        let selectedElement = opponentAvailableTransformableElements[Int(arc4random_uniform(UInt32(opponentAvailableTransformableElements.count)))]
        
        if selectedElement == "wood" {
            opponent.fire.health += opponent.wood.health
            opponent.wood.health = 0
        }
        
        if selectedElement == "fire" {
            opponent.earth.health += opponent.fire.health
            opponent.fire.health = 0
        }
        
        if selectedElement == "earth" {
            opponent.metal.health += opponent.earth.health
            opponent.earth.health = 0
        }
        
        if selectedElement == "metal" {
            opponent.water.health += opponent.metal.health
            opponent.metal.health = 0
        }
        
        if selectedElement == "water" {
            opponent.wood.health += opponent.water.health
            opponent.water.health = 0
        }
        
        print("randomly selected transformable element is\(selectedElement)")
    }
    
    func opponentTurn() {
        
        
        
        if opponentAvailableTransformableElements.count > 0 {
        
            var whatOpponentDoes = Int(UInt32(arc4random_uniform(2)))
            
            if whatOpponentDoes == 0 {
                opponentStartingElement.health += 1
                print("opponent regenerates")
            } else if whatOpponentDoes == 1 {
                opponentTransform()
                print("opponent transforms")
            }
        } else {
            opponentStartingElement.health += 1
            print("no colors available to transform, opponent regenerates")
        }
        
        
        
        playerTurn = true
        
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        objectMovable = false
        
        // supporting interactions
        if (contact.bodyA.node?.name == "greenCircle" || contact.bodyB.node?.name == "greenCircle")
            && (contact.bodyA.node?.name == "redCircle" || contact.bodyB.node?.name == "redCircle") {
            player.fire.health += player.wood.health
            player.wood.health = 0
            playerTurn = false
            print("human player's fire health is\(player.fire.health)")
        }
        if (contact.bodyA.node?.name == "redCircle" || contact.bodyB.node?.name == "redCircle")
            && (contact.bodyA.node?.name == "yellowCircle" || contact.bodyB.node?.name == "yellowCircle") {
            player.earth.health += player.fire.health
            player.fire.health = 0
            playerTurn = false
            print("human player's earth health is\(player.earth.health)")
        }
        if (contact.bodyA.node?.name == "yellowCircle" || contact.bodyB.node?.name == "yellowCircle")
            && (contact.bodyA.node?.name == "blackCircle" || contact.bodyB.node?.name == "blackCircle") {
            player.metal.health += player.earth.health
            player.earth.health = 0
            playerTurn = false
        }
        if (contact.bodyA.node?.name == "blackCircle" || contact.bodyB.node?.name == "blackCircle")
            && (contact.bodyA.node?.name == "blueCircle" || contact.bodyB.node?.name == "blueCircle") {
            player.water.health += player.metal.health
            player.metal.health = 0
            playerTurn = false
        }
        if (contact.bodyA.node?.name == "blueCircle" || contact.bodyB.node?.name == "blueCircle")
            && (contact.bodyA.node?.name == "greenCircle" || contact.bodyB.node?.name == "greenCircle") {
            player.wood.health += player.water.health
            player.water.health = 0
            playerTurn = false
        }
        
        
        // damaging interactions
        if (contact.bodyA.node?.name == "greenCircle" || contact.bodyB.node?.name == "greenCircle")
            && (contact.bodyA.node?.name == "opponentYellowCircle" || contact.bodyB.node?.name == "opponentYellowCircle") {
            opponent.earth.health -= player.wood.health
            print("opponent's earth health is \(opponent.earth.health)")
            playerTurn = false
        }
        if (contact.bodyA.node?.name == "yellowCircle" || contact.bodyB.node?.name == "yellowCircle")
            && (contact.bodyA.node?.name == "opponentBlueCircle" || contact.bodyB.node?.name == "opponentBlueCircle") {
            opponent.water.health -= player.earth.health
            playerTurn = false
        }
        if (contact.bodyA.node?.name == "blueCircle" || contact.bodyB.node?.name == "blueCircle")
            && (contact.bodyA.node?.name == "opponentRedCircle" || contact.bodyB.node?.name == "opponentRedCircle") {
            opponent.fire.health -= player.water.health
            print("opponent's fire health is \(opponent.fire.health)")
            playerTurn = false
        }
        if (contact.bodyA.node?.name == "redCircle" || contact.bodyB.node?.name == "redCircle")
            && (contact.bodyA.node?.name == "opponentBlackCircle" || contact.bodyB.node?.name == "opponentBlackCircle") {
            opponent.metal.health -= player.fire.health
            playerTurn = false
        }
        if (contact.bodyA.node?.name == "blackCircle" || contact.bodyB.node?.name == "blackCircle")
            && (contact.bodyA.node?.name == "opponentGreenCircle" || contact.bodyB.node?.name == "opponentGreenCircle") {
            opponent.wood.health -= player.metal.health
            playerTurn = false
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
        
        print("opponent's starting element is \(opponentStartingElement.type)")
        
    }
    

    
    override func update(_ currentTime: TimeInterval) {
        if playerTurn == false {
            opponentTurn()
        }
        
        if opponent.wood.health > 0 {
            opponentAvailableTransformableElements.append("wood")
        } else if opponent.wood.health <= 0 {
            
            for index in 0..<(opponentAvailableTransformableElements.count) {
                
                if opponentAvailableTransformableElements[index] == "wood" {
                    opponentAvailableTransformableElements.remove(at: index)
                    break
                }
            }
            
        }
        
        if opponent.fire.health > 0 {
            opponentAvailableTransformableElements.append("fire")
        } else if opponent.fire.health <= 0 {
            for index in 0..<(opponentAvailableTransformableElements.count) {
                
                if opponentAvailableTransformableElements[index] == "fire" {
                    opponentAvailableTransformableElements.remove(at: index)
                    break
                }
            }
        }
        if opponent.earth.health > 0 {
            opponentAvailableTransformableElements.append("earth")
        }
        if opponent.metal.health > 0 {
            opponentAvailableTransformableElements.append("metal")
        }
        if opponent.water.health > 0 {
            opponentAvailableTransformableElements.append("water")
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
        
        opponentTransform()
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

