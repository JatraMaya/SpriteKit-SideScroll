//
//  GameScene.swift
//  Gaming
//
//  Created by Ahmad Fadly Iksan on 11/10/23.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

    var player: Player
    var control: Control
    var npcDialog: NpcDialog

    override init(size: CGSize) {
        player = Player()
        control = Control()
        npcDialog = NpcDialog(size: size, imageName: "npc-b-1", imagePlayer: "player1", imageNpc: "npc-b-1")
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

//    private var npcDialog = NpcDialog(size: frame.size, imageNama: "npc-b-1")
    private var npc = Npc(texture: SKTexture(imageNamed: "npc-a-1"), size: SKTexture(imageNamed: "npc-a-1").size())
    var ucapan = SKLabelNode(text: "Heyooooooooo, I'm an NPC!!")

    // Call all the necessary function when game first load
    override func didMove(to view: SKView) {

        setupPlayer()
        setupControl()
        setupDialog()

//        addChild(npcDialog.sprite)
//        npcDialog.sprite.position = CGPoint(x: frame.minX + 400, y: frame.minY + 120)

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

    func setupDialog() {
        npcDialog.sprite.position = CGPoint(x: frame.minX + 400, y: frame.minY + 120)
        addChild(npcDialog.sprite)
//        npcDialog.dialogBox.position = CGPoint(x: frame.minX + 400, y: frame.minY + 120)
        npcDialog.dialogBox.position = CGPoint(x: frame.midX, y: frame.midY - 50)
        addChild(npcDialog.dialogBox)
    }
}
