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
    var activeNpc = ""

    var buttonAction: SKSpriteNode
    let player: Player
    let cameraNode: SKCameraNode
    let npc1: Npc
    let npc2: Npc
    let shape = SKSpriteNode(color: UIColor.blue, size: CGSize(width: 10, height: 10))

    override init(size: CGSize) {

        buttonAction = SKSpriteNode(color: UIColor.brown, size: CGSize(width: 30, height: 30))
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

    }

    // Update Scene (including node location) accroding to delta time
    override func update(_ currentTime: TimeInterval) {
        player.updatePlayerPosition()
        updateActionSpeechMark()
        camera?.position.x = player.position.x

//        print((scene?.size.width)! / 2)
//        print((scene?.size.width)! - 50)
//        print((scene?.size.width)!)

        if isActionButtonActive {
            buttonAction.run(SKAction.moveTo(x: (scene?.size.width)! / 2.080, duration: 0.1))
        } else {
            buttonAction.run(SKAction.moveTo(x: (scene?.size.width)!, duration: 0.1))
        }
    }

    // control functionality when button is touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in (touches) {
            let location = touch.location(in: self.camera!)
            print(location.x)
            if location.x < 1 {
                player.playerMoveLeft = true
                player.playerMoveRight = false
                player.walkingAnimation()
            }else {
                player.playerMoveRight = true
                player.playerMoveLeft = false
                player.walkingAnimation()
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
//        let questionMark = SKLabelNode(text: "💬")
//        questionMark.alpha = 0
//        questionMark.fontSize = 20
//        questionMark.name = "speechBubble"
        player.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        player.position = CGPoint(x: frame.minX + 80, y: frame.minY + 120)
        addChild(player)
//        player.addChild(questionMark)
//        questionMark.position.y = player.position.x - 65

    }

    func setupCamera() {
        cameraNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(cameraNode)
        camera = cameraNode
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

    func updateActionSpeechMark() {
                if (-distanceBetweenSprite..<distanceBetweenSprite).contains(player.position.x - npc1.sprite.position.x) {
                    npc1.sprite.childNode(withName: "speechBubble")?.alpha = 1
                    activeNpc = "npc1"
                    self.isActionButtonActive = true
                } else if (-distanceBetweenSprite..<distanceBetweenSprite).contains(player.position.x - npc2.sprite.position.x) {
                    player.childNode(withName: "speechBubble")?.alpha = 1
                    activeNpc = "npc2"
                    self.isActionButtonActive = true
                    print(self.isActionButtonActive)
                } else {
                    npc2.sprite.childNode(withName: "speechBubble")?.alpha = 0
                    self.isActionButtonActive = false
                    print(self.isActionButtonActive)
                }
        }

    func setupActionButton() {
        cameraNode.addChild(self.buttonAction)
        self.buttonAction.position.x = (scene?.frame.width)!
    }
}
