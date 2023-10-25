//
//  SceneSecond.swift
//  Gaming
//
//  Created by Ahmad Fadly Iksan on 24/10/23.
//

import SpriteKit

class SecondScene: SKScene {

//    var isActionButtonActive = false
//    var buttonAction: SKSpriteNode
    let player: Player
    let cameraNode: SKCameraNode

    let bg1: SKSpriteNode
    let bg2: SKSpriteNode

    override init(size: CGSize) {

        cameraNode = SKCameraNode()
        player = Player()

        bg1 = SKSpriteNode(imageNamed: "BG-Layer1")
        bg2 = SKSpriteNode(imageNamed: "keraton")

        bg1.name = "bg1"

        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(to view: SKView) {
        for i in [bg1, bg2] {

            if i.name != "bg1" {
                i.anchorPoint = CGPoint(x: 0.8, y: 0.5)
            } else {
                i.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            }

            i.setScale(0.5)
            i.position = CGPoint(x: frame.width / 2, y: frame.height / 2)
            addChild(i)
        }
        setupPlayer()
        setupCamera()
    }

    override func update(_ currentTime: TimeInterval) {
        player.updatePlayerPositionRightToLeft(frame)
//        print(player.position.x)

        if player.position.x < size.width / 2 {
            print(player.position.x)
        }

        if player.position.x <= size.width / 2  {
            camera?.position.x = player.position.x
            bg1.position.x = (camera?.position.x)!
        } else if player.position.x > bg2.size.width / 1.21 {
            if player.position.x > 3059 {
                player.position.x = 3059
                player.stopPlayerMovement()
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            player.handlePlayerMovementRightToLeft(touch, self.size)
        }

    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        player.stopPlayerMovement()
    }

    func setupPlayer() {
        player.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        player.position = CGPoint(x: frame.midX, y: size.height / 3)
        addChild(player)
        player.zPosition = 10

    }

    func setupCamera() {
        cameraNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        camera = cameraNode
    }

}
