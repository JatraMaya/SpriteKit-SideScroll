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

    let playerCategory: UInt32 = 1 >> 1

    var playerMoveLeft = false
    var playerMoveRight = false

    init() {
        super.init(texture: frame1, color: UIColor.clear, size: frame1.size())
        self.name = "player"
        self.physicsBody = SKPhysicsBody(texture: frame1, size: frame1.size())
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = playerCategory
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /// Handling Player walking animation with SKAction node
    func walkingAnimation() {
        let animate = SKAction.animate(with: [frame1, frame2], timePerFrame: 0.10)
        self.run(SKAction.repeatForever(animate))
    }
    
    /// Update player location in the screen based on delta time and condition either playerMoveLeft/playerMoveRight boolean value
    func updatePlayerPosition() {
        if playerMoveLeft {
            self.xScale = 1
            self.position.x -= 1
        } else if playerMoveRight {
            self.xScale = -1
            self.position.x += 1
        }
    }
    
    /// Set value for both playerMoveLeft & playerMoveRight back to false and remove all SKAction triggered by previous conditional
    func stopPlayerMovement() {
        playerMoveLeft = false
        playerMoveRight = false
        self.removeAllActions()
    }

}
