//
//  GameViewController.swift
//  Phi Squad Game
//
//  Created by Joseph DeYoung on 3/14/17.
//  Copyright © 2017 Joseph DeYoung. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    /*func readPropertyList(){
        var format = PropertyListSerialization.PropertyListFormat.xml //format of the property list
        var plistData:[String:AnyObject] = [:]  //our data
        let plistPath:String? = Bundle.main.path(forResource: "data", ofType: "plist")!
        let plistXML = FileManager.default.contents(atPath: plistPath!)!
        do{
            plistData = try PropertyListSerialization.propertyList(from: plistXML,
                                                                             options: .mutableContainersAndLeaves,
                                                                             format: &format)
                as! [String:AnyObject]
            var highScore = plistData["High Score"] as! CGFloat
            var name = plistData["Name"] as! String
        }
        catch{
            print("Error reading plist: \(error), format: \(format)")
        }
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
    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
