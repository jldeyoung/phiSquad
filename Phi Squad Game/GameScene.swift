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
    let e5 = SKSpriteNode(imageNamed: "E5BlasterRifle")
    let bbr = SKSpriteNode(imageNamed: "BlasterBoltR")
    let bbb = SKSpriteNode(imageNamed: "BlasterBoltB")
    var highScore:NSInteger = 15
    var playerName:NSString = "Name"
    let playableRect:CGRect = CGRect(x: 0, y: 0, width: 1334, height: 750)
    var velocity = CGPoint.zero
    var dt: TimeInterval = 0
    var lastUpdateTime: TimeInterval = 0
    var lastTouchLocation: CGPoint = CGPoint.zero
    let warningLabel = SKLabelNode(fontNamed: "Times New Roman")
    
    var isInvincible: Bool = false
    
    var lives = 5
    var gameOver = false
    //
    
    let moveRectL:CGRect = CGRect(x: 0, y: 0, width: 100, height: 100)
    let moveRectR:CGRect = CGRect(x: 1234, y: 0, width: 100, height: 100)
    
    let livesLabel = SKLabelNode(fontNamed: "anklepants")
    let scoreLabel = SKLabelNode(fontNamed: "anklepants")
    var score = 0
    
    var difficulty = 0.1
    
    func readPlist(namePlist: String, key: String) -> AnyObject{
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsDirectory = paths.object(at: 0) as! NSString
        let path = documentsDirectory.appendingPathComponent(namePlist+".plist")
        
        var output:AnyObject = false as AnyObject
        
        if let dict = NSMutableDictionary(contentsOfFile: path){
            output = dict.object(forKey: key)! as AnyObject
        }else{
            if let privPath = Bundle.main.path(forResource: namePlist, ofType: "plist"){
                if let dict = NSMutableDictionary(contentsOfFile: privPath){
                    output = dict.object(forKey: key)! as AnyObject
                }else{
                    output = false as AnyObject
                    print("error_read")
                }
            }else{
                output = false as AnyObject
                print("error_read")
            }
        }
        return output
    }

    func writePlist(namePlist: String, key: String, data: AnyObject){
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsDirectory = paths.object(at: 0) as! NSString
        let path = documentsDirectory.appendingPathComponent(namePlist+".plist")
        
        if let dict = NSMutableDictionary(contentsOfFile: path){
            dict.setObject(data, forKey: key as NSCopying)
            if dict.write(toFile: path, atomically: true){
                print("plist_write")
            }else{
                print("plist_write_error")
            }
        }else{
            if let privPath = Bundle.main.path(forResource: namePlist, ofType: "plist"){
                if let dict = NSMutableDictionary(contentsOfFile: privPath){
                    dict.setObject(data, forKey: key as NSCopying)
                    if dict.write(toFile: path, atomically: true){
                        print("plist_write")
                    }else{
                        print("plist_write_error")
                    }
                }else{
                    print("plist_write")
                }
            }else{
                print("error_find_plist")
            }
        }
    }
    
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
                SKAction.wait(forDuration: 5.0-difficulty)])))
        
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
        
        highScore = readPlist(namePlist: "data", key: "High Score") as! Int
        print("High Score: \(highScore)")
        
        let shapeR = SKShapeNode()
        let path = CGMutablePath()
        path.addRect(moveRectR)
        shapeR.path = path
        shapeR.strokeColor = SKColor.red
        shapeR.lineWidth = 4.0
        shapeR.zPosition = 20
        addChild(shapeR)
        
        let shapeL = SKShapeNode()
        path.addRect(moveRectL)
        shapeL.path = path
        shapeL.strokeColor = SKColor.red
        shapeL.lineWidth = 4.0
        shapeL.zPosition = 20
        addChild(shapeL)
        
        livesLabel.text = "Lives: X"
        livesLabel.fontColor = SKColor.blue
        livesLabel.fontSize = 100
        livesLabel.zPosition = 150
        livesLabel.horizontalAlignmentMode = .left
        livesLabel.verticalAlignmentMode = .bottom
        livesLabel.position = CGPoint(
            x: -playableRect.size.width/2 + CGFloat(20),
            y: -playableRect.size.height/2 + CGFloat(20))
        addChild(livesLabel)
        
        scoreLabel.text = "Cats: X"
        scoreLabel.fontColor = SKColor.blue
        scoreLabel.fontSize = 100
        scoreLabel.zPosition = 150
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.verticalAlignmentMode = .bottom
        scoreLabel.position = CGPoint(
            x: playableRect.size.width/2 - CGFloat(60),
            y: -playableRect.size.height/2 + CGFloat(20))
        addChild(scoreLabel)
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
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }*/
    
    
    override func update(_ currentTime: TimeInterval) {
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0 }
        lastUpdateTime = currentTime
        
        move(sprite: player, velocity: velocity)
        
        writePlist(namePlist: "data", key: "High Score", data: highScore as AnyObject)
        
        checkCollisions()
    }
    
    
    
    func sceneTouched(touchLocation:CGPoint) {
        
        if(touchLocation.x <= moveRectL.maxX && touchLocation.y <= moveRectL.maxY){//touch left box
            player.xScale = 15
            player.removeAllActions()
            player.run(SKAction.moveBy(x: -667, y: 0, duration: 3.0))
        }else if(touchLocation.x >= moveRectR.minX && touchLocation.y <= moveRectR.maxY){//touch right box
            player.xScale = -15
            player.removeAllActions()
            player.run(SKAction.moveBy(x: 667, y: 0, duration: 3.0))
        }else{
            if(touchLocation.x >= player.position.x){//touch to right
                player.xScale = -15
                player.removeAllActions()
                bbb.removeFromParent()
                bbb.removeAllActions()
                bbb.texture?.filteringMode = SKTextureFilteringMode.nearest
                bbb.setScale(5)
                bbb.position = CGPoint(x: player.position.x+player.size.width/2, y: player.position.y+277.5)
                bbb.zPosition = 200
                addChild(bbb)
                bbb.run(SKAction.moveBy(x: 1334, y: 0, duration: 4.0))
            }else{//touch to left
                player.xScale = 15
                player.removeAllActions()
                bbb.removeFromParent()
                bbb.removeAllActions()
                bbb.texture?.filteringMode = SKTextureFilteringMode.nearest
                bbb.setScale(5)
                bbb.position = CGPoint(x: player.position.x-player.size.width/2, y: player.position.y+277.5)
                bbb.zPosition = 200
                addChild(bbb)
                bbb.run(SKAction.moveBy(x: -1334, y: 0, duration: 4.0))
            }
        }
        
        lastTouchLocation = touchLocation
    }
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        sceneTouched(touchLocation: touchLocation)
    }
    override func touchesMoved(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        sceneTouched(touchLocation: touchLocation)
    }
    
    func move(sprite: SKSpriteNode, velocity: CGPoint) {
        let amountToMove = velocity * CGFloat(dt)
        sprite.position += amountToMove
        
        boundsCheckPlayer()
    }
    
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
        warningLabel.removeFromParent()
        warningLabel.text = "!"
        warningLabel.fontSize = 60
        warningLabel.zPosition = 20
        warningLabel.fontColor = UIColor.red
        let actionMove = SKAction.moveBy(x: (size.width + enemy.size.width), y: 0.0, duration: 5.0-difficulty)
        let actionRemove = SKAction.removeFromParent()
        e5.removeFromParent()
        e5.texture?.filteringMode = SKTextureFilteringMode.nearest
        e5.setScale(0.0065)
        e5.zPosition = 15
        e5.position = CGPoint(x: 1.5, y: 16.3)
        enemy.addChild(e5)
        if(spawnLeft == true){
            enemy.position = left
            warningLabel.position = CGPoint(x: size.width/2, y: size.height/2)
            addChild(warningLabel)
            run(SKAction.wait(forDuration: 1.0))
            warningLabel.run(actionRemove)
            
            enemy.run(SKAction.sequence([actionMove, actionRemove]))

        } else {
            enemy.position = right
            enemy.xScale = -22
            warningLabel.position = CGPoint(x: 100, y: size.height/2)
            addChild(warningLabel)
            run(SKAction.wait(forDuration: 1.0))
            warningLabel.run(actionRemove)
            let actionMove = SKAction.moveBy(x: (-size.width - enemy.size.width), y: 0.0, duration: 5.0 - difficulty)
            let actionRemove = SKAction.removeFromParent()
            enemy.run(SKAction.sequence([actionMove, actionRemove]))

        }
        
        addChild(enemy)   
    }
    
    func boundsCheckPlayer() {
        let bottomLeft = CGPoint(x: playableRect.minX, y: playableRect.minY)
        let topRight = CGPoint(x: playableRect.maxX, y: playableRect.maxY)
        player.zPosition = 50
        if player.position.x <= bottomLeft.x {
            player.position.x = bottomLeft.x
            velocity.x = abs(velocity.x)
        }
        if player.position.x >= topRight.x {
            player.position.x = topRight.x
            velocity.x = -velocity.x
        }
        if player.position.y <= bottomLeft.y {
            player.position.y = bottomLeft.y
            velocity.y = -velocity.y
        }
        if player.position.y >= topRight.y {
            player.position.y = topRight.y
            velocity.y = -velocity.y
        }
    }
    func playerHit(enemy: SKSpriteNode) {
        isInvincible = true
        let blinkTimes = 5.0
        let duration = 0.5
        let blinkAction = SKAction.customAction(
        withDuration: duration) { node, elapsedTime in
            let slice = duration / blinkTimes
            let remainder = Double(elapsedTime).truncatingRemainder(
                dividingBy: slice)
            node.isHidden = remainder > slice / 2
        }
        let setHidden = SKAction.run() { [weak self] in
            self?.player.isHidden = false
            self?.isInvincible = false
        }
        player.run(SKAction.sequence([blinkAction, setHidden]))
        
        //enemy.removeFromParent()
        //run(enemyCollisionSound)
        //loseCats()
        lives -= 1
    }
    func blastHit(enemy: SKSpriteNode){
        enemy.removeAllActions()
        enemy.removeAllChildren()
        enemy.removeFromParent()
        bbb.removeFromParent()
        bbb.position = CGPoint(x: size.width/2, y: size.height)
        highScore += 1
        difficulty *= 1.01
    }
    func checkCollisions(){
        var hitEnemies: [SKSpriteNode] = []
        if(isInvincible == false){
            enumerateChildNodes(withName: "enemy") { node, _ in
                let enemy = node as! SKSpriteNode
                if node.frame.insetBy(dx: 20, dy: 20).intersects(
                    self.player.frame) {
                    hitEnemies.append(enemy)
                }
            }
        }
        for enemy in hitEnemies {
            playerHit(enemy: enemy)
        }
        var bHitEnemies: [SKSpriteNode] = []
        //if(isInvincible == false){
            enumerateChildNodes(withName: "enemy") { node, _ in
                let enemy = node as! SKSpriteNode
                if node.frame.insetBy(dx: 20, dy: 20).intersects(
                    self.bbb.frame) {
                    bHitEnemies.append(enemy)
                }
            //}
        }
        for enemy in bHitEnemies {
            blastHit(enemy: enemy)
        }

    }
}
