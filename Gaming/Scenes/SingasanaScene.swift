//
//  SingasanaScene.swift
//  Gaming
//
//  Created by Ahmad Fadly Iksan on 25/10/23.
//

import Foundation
import SpriteKit

class SingasanaScene: SKScene {
    let player: Player
    let bg1: SKSpriteNode
    let bg2: SKSpriteNode

    override init(size: CGSize) {
        player = Player()
        bg1 = SKSpriteNode(imageNamed: "BG-Layer1")
        bg2 = SKSpriteNode(imageNamed: "singgasana")
        bg2.setScale(0.5)
        bg2.anchorPoint = CGPoint(x: 0.5, y: 0.5)


        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(to view: SKView) {
        player.setupPlayer(self, frame)

        for background in [bg1, bg2] {
            background.setScale(0.5)
            background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            background.position = CGPoint(x: frame.width / 2, y: frame.height / 2)
            addChild(background)
        }
    }
}
