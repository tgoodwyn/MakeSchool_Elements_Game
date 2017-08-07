//
//  ReferenceScene.swift
//  theGame2
//
//  Created by Tyler Goodwyn on 7/26/17.
//  Copyright © 2017 Tyler Goodwyn. All rights reserved.
//

import Foundation
import SpriteKit

class ReferenceScene: SKScene {
    

    var backToGame: MSButtonNode!
    
    var guiScene: GemScene!
    
    override func didMove(to view: SKView) {
 
        backToGame = childNode(withName: "backToGame") as! MSButtonNode
        
        backToGame.selectedHandler = {
            
            SKTransition.flipVertical(withDuration: 0)
            
            if let view = self.view as! SKView? {
                // Load the SKScene from 'GameScene.sks'
                if let scene = self.guiScene {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    
                    // Present the scene
                    view.presentScene(scene)
                }
            }
        }
        
                
    }
    
}
