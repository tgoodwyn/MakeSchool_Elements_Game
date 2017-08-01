//
//  MainMenu.swift
//  theGame2
//
//  Created by Tyler Goodwyn on 7/31/17.
//  Copyright © 2017 Tyler Goodwyn. All rights reserved.
//

import Foundation
import SpriteKit

class MainMenu: SKScene {
    
    var buttonNode: MSButtonNode!
    
    override func didMove(to view: SKView) {
        buttonNode = childNode(withName: "buttonNode") as! MSButtonNode
        
        buttonNode.selectedHandler = {
            
            SKTransition.flipVertical(withDuration: 0)
            
            let game = GemScene(fileNamed: "GemScene")
            game?.scaleMode = .aspectFill
            view.presentScene(game)
        }
    }
    
    
    
    
    
    
    
}
