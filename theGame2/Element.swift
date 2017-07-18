//
//  Element.swift
//  theGame
//
//  Created by Tyler Goodwyn on 7/17/17.
//  Copyright © 2017 Tyler Goodwyn. All rights reserved.
//

import SpriteKit

class Element {
    
    enum element {
        case fire, earth, metal, water, wood
    }
    
    enum playerName {
        case human, AI
    }
    
    var belongsTo: playerName
    weak var label: SKLabelNode?
    
    
    weak var delegate: Player!
    
    
    
    
    var health = 0 {
        didSet {
            if let label = label {
                label.text = String(health)
            }
        }
    }
    
    var type: element {
        didSet {
            reset()
        }
    }
    
    func reset() {
        guard let delegate = delegate else {
            return
        }
        switch type {
        case .wood:
            label = delegate.greenLabel
            break
        case .fire:
            label = delegate.redLabel
            break
        case .earth:
            label = delegate.yellowLabel
            break
        case.metal:
            label = delegate.blackLabel
            break
        case.water:
            label = delegate.blueLabel
            break
        }

    }
    
    
    init(type: element, belongsTo: playerName) {
        self.belongsTo = belongsTo
        self.type = type
        reset()
    }
    

    
    convenience init() {
        self.init(type: .wood, belongsTo: .human)
    }
    
    
    
    
    
    
    /*
     static func wood() -> Element {
     let wood = Element()
     wood.type = .wood
     wood.health = redValue
     wood.belongTo = .player
     return wood
     }
     */
    
}


