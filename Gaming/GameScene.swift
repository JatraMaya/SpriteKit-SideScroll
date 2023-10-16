//
//  GameScene.swift
//  Gaming
//
//  Created by Ahmad Fadly Iksan on 11/10/23.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

    var dialogIsActive = false
    var activeNpc = ""

    var player: Player
    var control: Control
    var npc1: Npc
    var npc2: Npc

    override init(size: CGSize) {
        player = Player()
        control = Control()
        npc1 = Npc(size: size, imageName: "npc-b-1", imageNpc: "npc-b-1", npcName: "npc1")
        npc2 = Npc(size: size, imageName: "npc-a-1", imageNpc: "npc-a-1", npcName: "npc2")
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Call all the necessary function when game first load
    override func didMove(to view: SKView) {

        setupPlayer()
        setupControl()
        setupNpc()

        scene!.name = "scene"

    }

    // Update Scene (including node location) accroding to delta time
    override func update(_ currentTime: TimeInterval) {
        player.updatePlayerPosition()
        updateActionButtonText()
    }

    // control functionality when button is touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        setupControlTouches(touches)
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
                    if scene?.childNode(withName: "dialogBox") == nil {
                        if activeNpc == "npc1" {
                            addChild(npc1.dialogBox)
                            npc1.setupDialog()
                        } else if activeNpc == "npc2" {
                            addChild(npc2.dialogBox)
                            npc2.setupDialog()
                        }
                    }
                }
            }

            if node.name == "dialogBox" {
                if activeNpc == "npc1" {
                    npc1.updateDialog()
                } else if activeNpc == "npc2" {
                    npc2.updateDialog()
                }
            }
        }
    }

    func updateActionButtonText() {
            if (-40..<35).contains(player.position.x - npc1.sprite.position.x) {
                control.updateButtonState(state: .isTalking)
                activeNpc = "npc1"
            } else if (-40..<35).contains(player.position.x - npc2.sprite.position.x) {
                control.updateButtonState(state: .isTalking)
                activeNpc = "npc2"
            } else {
                control.updateButtonState(state: .isAction)
            }
    }

    func setupNpc() {
        npc1.sprite.position = CGPoint(x: frame.minX + 400, y: frame.minY + 120)
        addChild(npc1.sprite)
        npc2.sprite.position = CGPoint(x: frame.minX + 200, y: frame.minY + 120)
        addChild(npc2.sprite)
        for i in [npc1, npc2] {
            i.dialogBox.position = CGPoint(x: frame.minX + 400, y: frame.minY + 100)
        }
    }
}
