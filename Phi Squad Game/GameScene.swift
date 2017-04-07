//
//  GameScene.swift
//  Phi Squad Game
//
//  Created by Joseph DeYoung on 3/14/17.
//  Copyright © 2017 Joseph DeYoung. All rights reserved.
//

import SpriteKit
import GameplayKit

extension Bool {
    static func random() -> Bool {
        return arc4random_uniform(2) == 0
    }
}

class GameScene: SKScene {
    
    let player = SKSpriteNode(imageNamed: "Commando1")
    let deece = SKSpriteNode(imageNamed: "DC-17m")
    
    override func didMove(to view: SKView) {
        
        // Get label node from scene and store it for use later
        backgroundColor = SKColor.black
        for i in 0...1 {
            let background = backgroundNode()
            background.anchorPoint = CGPoint.zero
            background.position =
                CGPoint(x: CGFloat(i)*background.size.width, y: 0)
            background.name = "background"
            addChild(background)
        }
        
        run(SKAction.repeatForever(
            SKAction.sequence([SKAction.run() { [weak self] in
                self?.spawnEnemy()
                },
                SKAction.wait(forDuration: 2.5)])))
        
        player.anchorPoint = CGPoint(x: 0.5, y: 0)
        player.texture?.filteringMode = SKTextureFilteringMode.nearest
        player.setScale(15.0)
        player.zPosition = 10
        player.position = CGPoint(x: 1334/2, y: 30)
        addChild(player)
        
        deece.removeFromParent()
        deece.texture?.filteringMode = SKTextureFilteringMode.nearest
        deece.setScale(0.03)
        deece.zPosition = 15
        deece.position = CGPoint(x: -1.5, y: 18.3)
        player.addChild(deece)
        
        //player.xScale = -15
    }
    
    
    /*func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }*/
    
    func backgroundNode() -> SKSpriteNode {
        // 1
        let backgroundNode = SKSpriteNode()
        backgroundNode.anchorPoint = CGPoint.zero
        backgroundNode.name = "background"
        // 2
        let background = SKSpriteNode(imageNamed: "Background")
        background.anchorPoint = CGPoint.zero
        background.position = CGPoint(x: 0, y: 0)
        backgroundNode.addChild(background)
        // 4
        backgroundNode.size = CGSize(
            width: background.size.width,
            height: background.size.height)
        return backgroundNode
    }

    func spawnEnemy() {
        let enemy = SKSpriteNode(imageNamed: "Droid1")
        let left = CGPoint(x: -enemy.size.width, y: 30)
        let right = CGPoint(x: size.width + enemy.size.width, y: 30)
        let spawnLeft:Bool = Bool.random()
        enemy.texture?.filteringMode = SKTextureFilteringMode.nearest
        enemy.zPosition = 50
        enemy.anchorPoint = CGPoint(x: 0.5, y: 0)
        enemy.setScale(22)
        enemy.name = "enemy"
        if(spawnLeft == true){
            enemy.position = left
            let actionMove = SKAction.moveBy(x: (size.width + enemy.size.width), y: 0.0, duration: 5.0)
            let actionRemove = SKAction.removeFromParent()
            enemy.run(SKAction.sequence([actionMove, actionRemove]))

        } else {
            enemy.position = right
            enemy.xScale = -22
            let actionMove = SKAction.moveBy(x: -(size.width + enemy.size.width), y: 0.0, duration: 5.0)
            let actionRemove = SKAction.removeFromParent()
            enemy.run(SKAction.sequence([actionMove, actionRemove]))

        }
        addChild(enemy)   
    }
    
}
