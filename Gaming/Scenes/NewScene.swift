//
//  NewScene.swift
//  Gaming
//
//  Created by bernardus kanayari on 08/11/23.
//

import SpriteKit

class NewScene: SKScene {

    var player: Player!
    var buttonQuestInfo: SKSpriteNode!
    var cameraNode: SKCameraNode!
    let papanWitana: SKSpriteNode!
    let bg2: SKSpriteNode!

    var moveLeft = false
    var moveRight = false

    override init(size: CGSize) {
        player = Player()

        buttonQuestInfo = SKSpriteNode(imageNamed: "btnQuestInfo")
        buttonQuestInfo.zPosition = 5002

        cameraNode = SKCameraNode()

        papanWitana = SKSpriteNode(imageNamed: "compPapanWitana")

        bg2 = SKSpriteNode(imageNamed: "keraton2")

        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(to view: SKView) {
        cameraNode = SKCameraNode()
        cameraNode.position = CGPoint(x: frame.size.width/2, y: frame.size.height / 2)
        addChild(cameraNode)
        camera = cameraNode

        buttonQuestInfo.name = "buttonQuestInfo"
        buttonQuestInfo.size = CGSize(width: 44, height: 44)
        buttonQuestInfo.position = CGPoint(x: -(frame.size.width/2) + buttonQuestInfo.size.width, y: (frame.size.height/2) - 44)
        buttonQuestInfo.zPosition = 6002

        papanWitana.name = "papanWitana"
        papanWitana.size = CGSize(width: 85, height: 133.5)
//        papanWitana.position = CGPoint(x: -1750, y: -110)
        papanWitana.position = CGPoint(x: frame.size.width * 0.1, y: frame.size.height)
        papanWitana.setScale(4)
        papanWitana.zPosition = 5999

        bg2.position = CGPoint(x: frame.width / 2, y: frame.height / 2)
        bg2.setScale(0.25)
        addChild(bg2)
        bg2.addChild(papanWitana)

        player = Player()
        player.size = CGSize(width: 50, height: 135)
        player.position = CGPoint(x: bg2.position.x, y: -55)
        player.zPosition = 6000

        cameraNode.addChild(player)
        cameraNode.addChild(buttonQuestInfo)
    }


    override func update(_ currentTime: TimeInterval) {
        updateMovement()

        print("\(player.position)")
    }


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)

            if (location.x > (frame.size.width / 2)) {
                self.moveLeft = false
                self.moveRight = true

                player.playerMoveLeft = false
                player.playerMoveRight = true
            } else {
                self.moveLeft = true
                self.moveRight = false

                player.playerMoveLeft = true
                player.playerMoveRight = false
            }
            player.walkingAnimation()
        }
    }

    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        stopMovement()
    }


    /// Put everything here if want to update base on player movement
    func updateMovement() {
        if moveLeft {
            player.xScale = -1
            bg2.position.x += 2
        } else if moveRight {
            player.xScale = 1
            bg2.position.x -= 2
        }
    }
    
    func stopMovement() {
        player.stopPlayerMovement()
        
        moveLeft = false
        moveRight = false
    }

}
