//
//  GameOverScene.swift
//  Phi Squad
//
//  Created by Cameron Turf on 2/13/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
// All wins need to be removed from here and replaced with a high score condition...

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    let won:Bool
        init(size: CGSize, won: Bool) {
            self.won = won
            super.init(size: size)
        }
        
        required init(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    override func didMove(to view: SKView) {
        var background: SKSpriteNode
        if (won) {
            background = SKSpriteNode(imageNamed: "High Score")
            //run(SKAction.playSoundFileNamed("win.wav",
                                           // waitForCompletion: false))
            
        } else {
            background = SKSpriteNode(imageNamed: "You Lose")
           // run(SKAction.playSoundFileNamed("lose.wav",
                                            //waitForCompletion: false))
        }
        
        background.position =
            CGPoint(x: size.width/2, y: size.height/2)
        self.addChild(background)
        
        // More here...
        let wait = SKAction.wait(forDuration: 3.0)
        let block = SKAction.run {
            let myScene = GameScene(size: self.size)
            myScene.scaleMode = self.scaleMode
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            self.view?.presentScene(myScene, transition: reveal)
        }
        self.run(SKAction.sequence([wait, block]))
    }
}
