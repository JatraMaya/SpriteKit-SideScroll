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
        
//        let scene = OnBoardingScene(size: view.frame.size)
        let scene = KomplekKerajaanScene(size: view.frame.size)
//        let scene = NewScene(size: view.frame.size)
//        let scene = OpeningNaration(size: view.frame.size)
//        let scene = KomplekKerajaanScene(size: view.frame.size)
//        let scene = OpeningNaration(size: view.frame.size)
//        let scene = KomplekKerajaanScene(size: view.frame.size)
//        let scene = DesaScene(size: view.frame.size)
//        let scene = SingasanaScene(size: view.frame.size)
//        let scene = BaliScene(size: view.frame.size)
//        let scene = PendopoBaliScene(size: view.frame.size)

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
