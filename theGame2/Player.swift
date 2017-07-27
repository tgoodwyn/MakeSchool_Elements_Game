//
//  Player.swift
//  theGame
//
//  Created by Tyler Goodwyn on 7/17/17.
//  Copyright © 2017 Tyler Goodwyn. All rights reserved.
//

import SpriteKit

class Player {
    
    var wood : Element!
    var fire : Element!
    var earth: Element!
    var metal: Element!
    var water: Element!
    
    
    var opponentAvailableTransformableElements: [String] = []
    var opponentBalancableElements: [String] = []
    
    func setup()
    {
        for (_, element) in [wood, fire, earth, metal, water].enumerated() {
            element?.delegate = self
            (element!.childNode(withName: "label") as! SKLabelNode).text = String(element!.health)
        }
    }
    
    func element(_ type: Element.element) -> Element {
        switch(type) {
        case .wood:
            return wood
        case .fire:
            return fire
        case .earth:
            return earth
        case .metal:
            return metal
        case .water:
            return water
        }
    }
    
    func setElement(_ type: Element.element, to element: Element) {
        switch(type) {
        case .wood:
            wood = element
            break
        case .fire:
            fire = element
            break
        case .earth:
            earth = element
            break
        case .metal:
            metal = element
            break
        case .water:
            water = element
            break
        }
    }
    
    
    var startingType: Element.element!

    

    
}
