//
//  Player.swift
//  theGame
//
//  Created by Tyler Goodwyn on 7/17/17.
//  Copyright © 2017 Tyler Goodwyn. All rights reserved.
//

import SpriteKit

class Player {
    
    var wood : Element
    var fire : Element
    var earth: Element
    var metal: Element
    var water: Element
    
    
    var opponentAvailableTransformableElements: [String] = []
    var opponentBalancableElements: [String] = []
    
    
    init(playerName: Element.playerName) {
        wood = Element(type: .wood, belongsTo: playerName)
        fire = Element(type: .fire, belongsTo: playerName)
        earth = Element(type: .earth, belongsTo: playerName)
        metal = Element(type: .metal, belongsTo: playerName)
        water = Element(type: .water, belongsTo: playerName)
        for (_, element) in [wood, fire, earth, metal, water].enumerated() {
            element.delegate = self
        }
    }
    
    func setup()
    {
        for (_, element) in [wood, fire, earth, metal, water].enumerated() {
            element.reset()
        }
    }
    
    
    var primaryElement: SKSpriteNode!
    
    
    
    
    var greenLabel: SKLabelNode!
    var redLabel: SKLabelNode!
    var yellowLabel: SKLabelNode!
    var blackLabel: SKLabelNode!
    var blueLabel: SKLabelNode!
    

    
}
