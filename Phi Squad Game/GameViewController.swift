//
//  GameViewController.swift
//  Phi Squad Game
//
//  Created by Joseph DeYoung on 3/14/17.
//  Copyright © 2017 Joseph DeYoung. All rights reserved.
//

import UIKit
import SpriteKit
class GameViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = MainMenuScene(size:CGSize(width: 1334, height: 750))
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .aspectFill
        scene.anchorPoint = CGPoint.zero
        skView.presentScene(scene)
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
