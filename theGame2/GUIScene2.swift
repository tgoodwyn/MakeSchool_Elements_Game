//
//  GUIScene2.swift
//  theGame2
//
//  Created by Tyler Goodwyn on 7/24/17.
//  Copyright © 2017 Tyler Goodwyn. All rights reserved.
//

import Foundation
import SpriteKit

class GUIScene2: SKScene {

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

    var player: Player!
    
    override func didMove(to view: SKView) {
        
        let distance: CGFloat = 200
        
        self.anchorPoint = CGPoint(x: 0, y: 0)
        
        playerElement1 = childNode(withName: "playerNode1") as! Element
        playerElement2 = childNode(withName: "playerNode2") as! Element
        playerElement3 = childNode(withName: "playerNode3") as! Element
        playerElement4 = childNode(withName: "playerNode4") as! Element
        playerElement5 = childNode(withName: "playerNode5") as! Element
        
        opponentElement1 = childNode(withName: "opponentNode1") as! Element
        opponentElement2 = childNode(withName: "opponentNode2") as! Element
        opponentElement3 = childNode(withName: "opponentNode3") as! Element
        opponentElement4 = childNode(withName: "opponentNode4") as! Element
        opponentElement5 = childNode(withName: "opponentNode5") as! Element
        
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
        
        player.startingType = .wood
        var prevType: Element.element?
        for number in 1...5 {
            let nextElement = childNode(withName: "playerNode\(number)") as! Element
            nextElement.belongsTo = .human
            if let unwrappedType = prevType {
                nextElement.type = Element.strengthens[unwrappedType]!
            } else {
                nextElement.type = player.startingType
            }
            nextElement.color = Element.colors[nextElement.type]!

            nextElement.startingPosition = nextElement.position
            nextElement.health = 0
            player.setElement(nextElement.type, to: nextElement)
            prevType = nextElement.type
            
        }
        
    }
    
    var objectMovable = false
    var objectGrabbed: Element!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        objectMovable = true
        let touch = touches.first!
        let location = touch.location(in: self)
        if let nodeAtPoint = atPoint(location) as? Element,
        let ownedBy = nodeAtPoint.belongsTo {
            if ownedBy == .human {
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

