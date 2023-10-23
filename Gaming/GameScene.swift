//
//  GameScene.swift
//  Gaming
//
//  Created by Ahmad Fadly Iksan on 11/10/23.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

    var isActionButtonActive = false
    var buttonAction: SKSpriteNode
    let player: Player
    let cameraNode: SKCameraNode
    let npc1: Npc
    let npc2: Npc
    var activeNpc: String = ""

    let bg1: SKSpriteNode
    let bg2: SKSpriteNode
    let bg3: SKSpriteNode
    let bg4: SKSpriteNode

    override init(size: CGSize) {

        buttonAction = SKSpriteNode(color: UIColor.red, size: CGSize(width: 100, height: 50))
        buttonAction.zPosition = 5002
        cameraNode = SKCameraNode()
        player = Player()
        npc1 = Npc(size: size, imageName: "npc-b-1", imageNpc: "npc-b-1", npcName: "npc1")
        npc2 = Npc(size: size, imageName: "npc-a-1", imageNpc: "npc-a-1", npcName: "npc2")

        bg1 = SKSpriteNode(imageNamed: "BG-Layer1")
        bg2 = SKSpriteNode(imageNamed: "BG-Layer2")
        bg3 = SKSpriteNode(imageNamed: "BG-Layer3")
        bg4 = SKSpriteNode(imageNamed: "BG-Layer4")

        bg1.name = "bg1"



        super.init(size: size)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Call all the necessary function when game first load
    override func didMove(to view: SKView) {


        for i in [bg1, bg2, bg3, bg4] {
            i.size = (i.texture?.size())!

            if i.name != "bg1" {
                i.anchorPoint = CGPoint(x: 0.065, y: 0.5)

            } else {
                i.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            }
            i.size.height = frame.height
            i.position = CGPoint(x: frame.width / 2, y: frame.height / 2)
            addChild(i)
        }
        bg3.zPosition = 5000
        bg4.zPosition = 5001
        setupPlayer()
        setupCamera()
        setupNpc()
        setupActionButton()

        scene!.name = "scene"
        scene?.zPosition = 100000


    }

    // Update Scene (including node location) accroding to delta time
    override func update(_ currentTime: TimeInterval) {

        player.updatePlayerPosition(frame)

        for i in [npc1, npc2] {
            i.updateActionSpeechMark(player)
        }

        if npc1.isNpcActive {
            self.activeNpc = npc1.npcName
        } else if npc2.isNpcActive {
            self.activeNpc = npc2.npcName
        }

        if player.position.x >= size.width / 2 {
            camera?.position.x = player.position.x
            bg1.position.x = (camera?.position.x)!
            buttonAction.position.x = (cameraNode.frame.maxX * 3)
            for i in [npc1, npc2] {
                i.dialogBox.position.x = (cameraNode.frame.midX)
            }
        }

        if npc1.isNpcActive || npc2.isNpcActive {
            buttonAction.run(SKAction.moveTo(x: cameraNode.frame.maxX + 375, duration: 0.1))
            isActionButtonActive = true
        } else {
            buttonAction.run(SKAction.moveTo(x: cameraNode.frame.maxX * 3, duration: 1))
            isActionButtonActive = false
        }
    }

    // control functionality when button is touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in (touches) {
//            let location = touch.location(in: self)
            let location = touch.location(in: self)
            let node = self.atPoint(location)
//            let node = self.atPoint(location)
//
//            if node.name == "buttocAction" {
//
//            }

            if childNode(withName: "dialogBox") == nil && (node.name != "buttonAction") {
                player.handlePlayerMovement(touch, self.size)
            }

            if self.activeNpc == "npc1" {
                npc1.handleNpcDialog(touch)
            } else if self.activeNpc == "npc2"{
                npc2.handleNpcDialog(touch)
            }


        }
    }

    // Tracking to stop functionality when button is no longer pressed
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        player.stopPlayerMovement()
    }

    // MARK: Various setup functions needed to build a scene
    /// Function to setup player to the scene,
    func setupPlayer() {
        player.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        player.position = CGPoint(x: frame.minX + 80, y: size.height / 4.5)
        addChild(player)
        player.zPosition = 10

    }

    func setupCamera() {
        cameraNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        camera = cameraNode
    }

    func setupNpc() {
        for i in [npc1, npc2] {
            addChild(i.sprite)
            i.dialogBox.position = CGPoint(x: size.width / 2, y: size.height / 5)
            i.dialogBox.zPosition = 5005

        }
        npc1.sprite.position = CGPoint(x: bg2.size.width / 2, y: size.height / 4.5)
        npc2.sprite.position = CGPoint(x: frame.maxX + 800, y: size.height / 4.5)

    }

    func setupActionButton() {
    buttonAction.name = "buttonAction"
    addChild(buttonAction)
    buttonAction.position = CGPoint(x: cameraNode.frame.maxX * 3, y: (frame.height / 2))
    }
}
