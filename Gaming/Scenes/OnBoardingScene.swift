//
//  OnBoardingScene.swift
//  Gaming
//
//  Created by Ahmad Fadly Iksan on 01/11/23.
//

import Foundation
import SpriteKit

class OnBoardingScene: SKScene {
    let background: SKSpriteNode
    let newGame: SKLabelNode
    let continueGame: SKLabelNode

    override init(size: CGSize) {
        background = SKSpriteNode(imageNamed: "Onboarding")
        background.setScale(0.25)
        background.anchorPoint = .zero
        continueGame = SKLabelNode(text: "Lanjutkan Permainan")
        continueGame.name = "continue game"
        newGame = SKLabelNode(text: "Mulai Permainan Baru")
        newGame.name = "new game"




        for label in [newGame, continueGame] {
            label.fontName = "SFProRounded"
            label.fontColor = UIColor.brown
        }

        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(to view: SKView) {
        newGame.position = CGPoint(x: frame.width / 2, y: frame.height / 2.6)
        continueGame.position = CGPoint(x: frame.width / 2, y: frame.height / 2)
        addChild(background)
        addChild(newGame)
        addChild(continueGame)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let node = self.atPoint(location)

            if node.name == "new game" {
                newGame.fontColor = UIColor.white
                UserDefaults.standard.set(false, forKey: "isTutorialDone")
                SceneManager.shared.transition(self, toScene: .OpeningNaration, transition: SKTransition.fade(withDuration: 2))
            } else if node.name == "continue game" {
                print("continue game")
                continueGame.fontColor = UIColor.white
            }

        }
    }
}
