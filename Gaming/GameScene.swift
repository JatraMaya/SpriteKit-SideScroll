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

    override init(size: CGSize) {

        buttonAction = SKSpriteNode(color: UIColor.red, size: CGSize(width: 100, height: 50))
        buttonAction.zPosition = 1000
        cameraNode = SKCameraNode()
        player = Player()
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
        setupCamera()
        setupNpc()
        setupActionButton()

        scene!.name = "scene"
        cameraNode.name = "camera"

    }

    // Update Scene (including node location) accroding to delta time
    override func update(_ currentTime: TimeInterval) {

        player.updatePlayerPosition(frame)
        npc1.updateActionSpeechMark(player)
        npc2.updateActionSpeechMark(player)

        if player.position.x >= size.width / 2 {
            camera?.position.x = player.position.x
            buttonAction.position.x = (cameraNode.frame.maxX * 3)
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
            let location = touch.location(in: self)
            let node = self.atPoint(location)

            if childNode(withName: "dialogBox") == nil {
                player.handlePlayerMovement(touch, self.size)
            }

            for i in [npc1, npc2] {
                i.handleNpcDialog(touch)
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
        player.position = CGPoint(x: frame.minX + 80, y: frame.minY + 120)
        addChild(player)

    }

    func setupCamera() {
        cameraNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        camera = cameraNode
    }

    func setupNpc() {
        for i in [npc1, npc2] {
            addChild(i.sprite)
                 
        }
        npc1.sprite.position = CGPoint(x: frame.minX + 200, y: frame.minY + 120)
        npc2.sprite.position = CGPoint(x: frame.minX + 300, y: frame.minY + 120)

    }

    func setupActionButton() {
    buttonAction.name = "buttonAction"
    addChild(buttonAction)
    buttonAction.position = CGPoint(x: cameraNode.frame.maxX * 3, y: (frame.height / 2))
    }
}
