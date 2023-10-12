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
    var control = Control()


    // Call all the necessary function when game first load
    override func didMove(to view: SKView) {
        setupPlayer()
        setupControl()
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

            if node.name == "buttonLeft" {
                player.playerMoveLeft = true
                player.playerMoveRight = false
                player.walkingAnimation()
            } else if node.name == "buttonRight" {
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

    // Setup function to build Scene
    func setupPlayer() {
        player.position = CGPoint(x: frame.minX + 80, y: frame.minY + 120)
        addChild(player)
    }

    func setupControl() {
        control.buttonLeft.position = CGPoint(x: frame.minX + 45, y: frame.minY + 50)
        control.buttonRight.position = CGPoint(x: frame.minX + 100, y: frame.minY + 50)
        control.buttonAction.position = CGPoint(x: frame.maxX - 45, y: frame.minY + 50)
        addChild(control.buttonLeft)
        addChild(control.buttonRight)
        addChild(control.buttonAction)
    }
}
