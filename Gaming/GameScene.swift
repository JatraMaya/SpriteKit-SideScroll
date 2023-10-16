//
//  GameScene.swift
//  Gaming
//
//  Created by Ahmad Fadly Iksan on 11/10/23.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

    private var player = Player()
    private var control = Control()
    private var npc = Npc(texture: SKTexture(imageNamed: "npc-a-1"), size: SKTexture(imageNamed: "npc-a-1").size())
//    private var npc2 = Npc(texture: SKTexture(imageNamed: "npc-b-1"), size: SKTexture(imageNamed: "npc-b-1").size())
    var ucapan = SKLabelNode(text: "Heyooooooooo, I'm an NPC!!")

    // Call all the necessary function when game first load
    override func didMove(to view: SKView) {

        setupPlayer()
        setupControl()

        npc.position = CGPoint(x: frame.minX + 200, y: frame.minY + 120)
        npc.name = "npc1"
        addChild(npc)

        ucapan.position = CGPoint(x: frame.midX / 2, y: frame.midY)
        ucapan.name =  "ucapan"

        scene?.name = "scene"

    }

    // Update Scene (including node location) accroding to delta time
    override func update(_ currentTime: TimeInterval) {
        player.updatePlayerPosition()
        updateActionButtonText()
    }

    // control functionality when button is touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        setupControlTouches(touches)

        for touch in touches {
            let location = touch.location(in: self)
            let node = self.atPoint(location)

            if node.name == "scene"  {
                if (childNode(withName: "ucapan") != nil) {
                    ucapan.removeFromParent()
                }
            }

        }
    }

    // Tracking to stop functionality when button is no longer pressed
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        player.stopPlayerMovement()
        control.resetButtonAlpha()
    }

    // MARK: Various setup functions needed to build a scene
    /// Function to setup player to the scene,
    func setupPlayer() {
        player.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        player.position = CGPoint(x: frame.minX + 80, y: frame.minY + 120)
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
                control.updateButtonAlpha("buttonLeft")
                player.walkingAnimation()
            } else if node.name == "buttonRight" {
                player.playerMoveLeft = false
                player.playerMoveRight = true
                control.updateButtonAlpha("buttonRight")
                player.walkingAnimation()
            } else if node.name == "buttonAction" {
                if control.buttonAction.text == "👄" {
                    addChild(ucapan)
                }
            }
        }
    }

    func updateActionButtonText() {
        if (-40..<35).contains(player.position.x - npc.position.x) {
            control.updateButtonState(state: .isTalking)
        } else {
            control.updateButtonState(state: .isAction)
        }
    }
}
