//
//  Player.swift
//  Gaming
//
//  Created by Ahmad Fadly Iksan on 12/10/23.
//

import Foundation
import SpriteKit

class Player: SKSpriteNode {

    let frame1 = SKTexture(imageNamed: "player1")
    let frame2 = SKTexture(imageNamed: "player2")

    var playerMoveLeft = false
    var playerMoveRight = false

    init() {
        super.init(texture: frame1, color: UIColor.clear, size: frame1.size())
        self.name = "player"
        self.physicsBody = SKPhysicsBody(texture: frame1, size: frame1.size())
        self.physicsBody?.affectedByGravity = false
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func walkingAnimation() {
        let animate = SKAction.animate(with: [frame1, frame2], timePerFrame: 0.10)
        self.run(SKAction.repeatForever(animate))
    }

    func updatePlayerPosition() {
        if playerMoveLeft {
            self.xScale = -1
            self.position.x += 1
        } else if playerMoveRight {
            self.xScale = 1
            self.position.x -= 1
        }
    }

    func stopPlayerMovement() {
        playerMoveLeft = false
        playerMoveRight = false
        self.removeAllActions()
    }

}
