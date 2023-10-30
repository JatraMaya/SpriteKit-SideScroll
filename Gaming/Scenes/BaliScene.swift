//
//  BaliScene.swift
//  Gaming
//
//  Created by bernardus kanayari on 29/10/23.
//

import SpriteKit

class BaliScene: SKScene {
    var buttonQuestInfo: SKSpriteNode
    var buttonSetting: SKSpriteNode

    let player: Player
    let cameraNode: SKCameraNode

    let bg1: SKSpriteNode
    let bg2: SKSpriteNode
    let bg3: SKSpriteNode

    override init(size: CGSize) {
        buttonQuestInfo = SKSpriteNode(imageNamed: "btnQuestInfo")
        buttonQuestInfo.zPosition = 5002

        buttonSetting = SKSpriteNode(imageNamed: "btnSetting")
        buttonSetting.zPosition = 5002

        cameraNode = SKCameraNode()
        player = Player()

        bg1 = SKSpriteNode(imageNamed: "gunungPenanggungan")
        bg2 = SKSpriteNode(imageNamed: "bali1")
        bg3 = SKSpriteNode(imageNamed: "bali2")

        bg1.name = "bg1"

        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: Call all the necessary function when game first load
    override func didMove(to view: SKView) {
        for background in [bg1, bg2, bg3] {
            if background.name != "bg1" {
                background.anchorPoint = CGPoint(x: 0.15, y: 0.5)
            } else {
                background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            }

            background.position = CGPoint(x: frame.width / 2 , y: frame.height / 2)

            addChild(background)
        }

        bg1.setScale(0.5)
        bg2.setScale(0.25)
        bg3.setScale(0.25)

        bg3.zPosition = layerPosition.layer3.rawValue

        player.setupPlayer(self, frame, xPos: 500, yPos: 138, width: 45, height: 125)

        setupCamera()

        setupQuestInfoButton()
        setupSettingButton()
    }


    // MARK: Update Scene (including node location) accroding to delta time
    override func update(_ currentTime: TimeInterval) {
        player.updatePlayerPositionLeftToRight(frame)

        buttonQuestInfo.position = CGPoint(x: cameraNode.frame.minX + frame.width * -0.45, y: cameraNode.frame.maxY - frame.height * -0.4)

        buttonSetting.position = CGPoint(x: cameraNode.frame.minX + frame.width * -0.45, y: cameraNode.frame.maxY - frame.height * -0.27)

        if player.position.x >= size.width / 2 {
            camera?.position.x = player.position.x
            bg1.position.x = (camera?.position.x)!
            print(player.position.x)
            if player.position.x > 2228 {
                player.position.x = 2228
                player.stopPlayerMovement()
            } else if player.position.x < 448 {
                player.position.x = 448
                player.stopPlayerMovement()
            }
        }
    }


    // MARK: Control functionality when button is touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let node = self.atPoint(location)

            player.handlePlayerMovementLeftToRight(touch, self.size)

            if node.name == "buttonQuestInfo" {
                buttonQuestInfo.run(SKAction.scale(to: 0.8, duration: 0.1))
                print("button quest info pressed")
                SceneManager.shared.transition(self, toScene: .DesaScene, transition: SKTransition.fade(withDuration: 1))
            }

            if node.name == "buttonSetting" {
                buttonSetting.run(SKAction.scale(to: 0.8, duration: 0.1))
                print("button setting pressed")
                SceneManager.shared.transition(self, toScene: .PendopoScene, transition: SKTransition.fade(withDuration: 1))
            }
        }
    }


    // MARK: Tracking to stop functionality when button is no longer pressed
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let node = self.atPoint(location)

            if node.name == "buttonQuestInfo" {
                buttonQuestInfo.run(SKAction.scale(to: 1, duration: 0.1))
            }

            if node.name == "buttonSetting" {
                buttonSetting.run(SKAction.scale(to: 1, duration: 0.1))
            }
        }

        player.stopPlayerMovement()
    }

    // MARK: Various setup function neede to build a scene
    func setupCamera() {
        cameraNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        camera = cameraNode
    }

    func setupQuestInfoButton() {
        buttonQuestInfo.name = "buttonQuestInfo"
        buttonQuestInfo.size = CGSize(width: 44, height: 44)

        addChild(buttonQuestInfo)
    }

    func setupSettingButton() {
        buttonSetting.name = "buttonSetting"
        buttonSetting.size = CGSize(width: 44, height: 44)

        addChild(buttonSetting)
    }
}

