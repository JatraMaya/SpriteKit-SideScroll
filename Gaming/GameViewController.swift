//
//  GameViewController.swift
//  Gaming
//
//  Created by Ahmad Fadly Iksan on 11/10/23.
//

import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        let scene = SceneSecond(size: view.frame.size)
        let scene = GameScene(size: view.frame.size)
//        let scene = SingasanaScene(size: view.frame.size)
        if let skView = self.view as? SKView {
            skView.showsFPS = true
            skView.showsNodeCount = true
            skView.ignoresSiblingOrder = false
//            scene.scaleMode = .aspectFit
            skView.presentScene(scene)
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
