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
        background.zPosition = 5
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        self.addChild(background)
        
        let pressAnywhere = SKLabelNode(fontNamed: "chalkduster")
        pressAnywhere.text = "tap anywhere to begin"
        pressAnywhere.color = SKColor.blue
        pressAnywhere.fontSize = 100
        pressAnywhere.zPosition = 200
        pressAnywhere.horizontalAlignmentMode = .center
        pressAnywhere.verticalAlignmentMode = .center
        pressAnywhere.position = CGPoint(x: 0,y: 0)
        scene?.addChild(pressAnywhere)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        sceneTapped()
    }
    func sceneTapped() {
        let transition = SKTransition.doorsOpenHorizontal(withDuration: 1.5)
        let nextScene = GameScene(size: size)
        nextScene.scaleMode = scaleMode
        view?.presentScene(nextScene, transition: transition)

    }
}
