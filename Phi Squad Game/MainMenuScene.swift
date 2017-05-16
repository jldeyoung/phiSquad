//
//  MainMenuScene.swift
//  ZombieConga
//
//  Created by Joseph DeYoung on 2/13/17.
//  Copyright © 2017 Joseph DeYoung. All rights reserved.
//

import Foundation
import SpriteKit

class MainMenuScene: SKScene{
    override func didMove(to view: SKView) {
        var background: SKSpriteNode
        background = SKSpriteNode(imageNamed: "SplashScreen.png")
        background.setScale(0.75)
        background.zPosition = 5
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        self.addChild(background)
        
        let pressAnywhere = SKLabelNode(fontNamed: "Anklepants")
        pressAnywhere.removeFromParent()
        pressAnywhere.text = "tap anywhere to begin"
        pressAnywhere.color = UIColor.blue
        pressAnywhere.fontSize = 80
        pressAnywhere.zPosition = 200
        pressAnywhere.horizontalAlignmentMode = .center
        pressAnywhere.verticalAlignmentMode = .center
        pressAnywhere.position = CGPoint(x: 1334/2,y: 750/2+135)
        scene?.addChild(pressAnywhere)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        sceneTapped()
    }
    func sceneTapped() {
        /*let transition = SKTransition.doorsOpenHorizontal(withDuration: 1.5)
        let nextScene = GameScene(size: size)
        nextScene.anchorPoint = CGPoint.zero
        nextScene.position = CGPoint.zero
        nextScene.scaleMode = .aspectFill
        view?.presentScene(nextScene, transition: transition)*/
        
        if (self.view ) != nil {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                // Present the scene
                view?.presentScene(scene)
            }
            
            view?.ignoresSiblingOrder = true
            
            view?.showsFPS = true
            view?.showsNodeCount = true
        }
    }
}
