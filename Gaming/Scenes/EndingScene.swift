//
//  EndingScene.swift
//  Gaming
//
//  Created by Ahmad Fadly Iksan on 01/11/23.
//

import Foundation
import SpriteKit

class EndingScene: SKScene {
    var isWinning = UserDefaults.standard.bool(forKey: "isWinning")

    let background: SKSpriteNode

    override init(size: CGSize) {

        background = SKSpriteNode(imageNamed: "Onboarding")
        background.setScale(0.25)
        background.anchorPoint = .zero

        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(to view: SKView) {

        addChild(background)

        let result = SKLabelNode()
        if isWinning {
            result.text = "You Win"
        } else {
            result.text = "You Lose"
        }

        addChild(result)
    }

    
}
