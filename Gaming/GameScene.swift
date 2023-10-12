//
//  GameScene.swift
//  Gaming
//
//  Created by Ahmad Fadly Iksan on 11/10/23.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

    var player = Player()

    // Call all the necessary function when game first load
    override func didMove(to view: SKView) {
        player.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(player)
    }

    // Update Scene (including node location) accroding to delta time
    override func update(_ currentTime: TimeInterval) {
        player.updatePlayerPosition()

    }

    // control functionality when button is touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let node = self.atPoint(location)

            if node.name == "player" {
                player.playerMoveLeft = true
                player.playerMoveRight = false
                player.walkingAnimation()
            } else {
                player.playerMoveLeft = false
                player.playerMoveRight = true
                player.walkingAnimation()
            }
        }

    }

    // Tracking to stop functionality when button is no longer pressed
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        player.stopPlayerMovement()
    }


}
