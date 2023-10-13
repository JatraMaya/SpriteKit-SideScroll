//
//  GameScene.swift
//  Gaming
//
//  Created by Ahmad Fadly Iksan on 11/10/23.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {

    var player = Player()
    var control = Control()

    var npc: SKSpriteNode!


    // Call all the necessary function when game first load
    override func didMove(to view: SKView) {

        physicsWorld.contactDelegate = self
        setupPlayer()
        setupControl()

//        let enemyCategory: UInt32 = 1 >> 2

        npc = SKSpriteNode(imageNamed: "npc-a-1")
        npc.position = CGPoint(x: frame.minX + 200, y: frame.minY + 120)
        npc.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        npc.physicsBody = SKPhysicsBody(rectangleOf: npc.texture!.size())
        npc.physicsBody?.affectedByGravity = false
        npc.physicsBody?.isDynamic = true
        npc.physicsBody?.categoryBitMask = 1 >> 2
        addChild(npc)

        for node in [player, npc] {
            node?.physicsBody?.collisionBitMask = 0
        }

    }

    // Update Scene (including node location) accroding to delta time
    override func update(_ currentTime: TimeInterval) {
        player.updatePlayerPosition()

    }

    // control functionality when button is touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        setupControlTouches(touches)

    }

    // Tracking to stop functionality when button is no longer pressed
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        player.stopPlayerMovement()
    }

    func didBegin(_ contact: SKPhysicsContact) {
        print("test")
       
    }

    // MARK: Various setup functions needed to build a scene
    /// Function to setup player to the scene,
    func setupPlayer() {
        player.position = CGPoint(x: frame.minX + 80, y: frame.minY + 120)
        player.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        addChild(player)
    }
    
    /// Function to setup three buttons control on the scene
    func setupControl() {
        control.buttonLeft.position = CGPoint(x: frame.minX + 45, y: frame.minY + 50)
        control.buttonRight.position = CGPoint(x: frame.minX + 100, y: frame.minY + 50)
        control.buttonAction.position = CGPoint(x: frame.maxX - 45, y: frame.minY + 50)
        addChild(control.buttonLeft)
        addChild(control.buttonRight)
        addChild(control.buttonAction)
    }
    
    /// Function to handle player touches to the controller node
    /// - Parameter touches: require Set of UITouch
    func setupControlTouches(_ touches: Set<UITouch>) {
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
}
