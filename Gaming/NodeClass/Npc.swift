//
//  Dialog.swift
//  Gaming
//
//  Created by Ahmad Fadly Iksan on 16/10/23.
//

import Foundation
import SpriteKit

class Npc {

    var sprite: SKSpriteNode
    var dialogBox: SKSpriteNode
    var npcName: String
    var playerImage: SKSpriteNode
    var npcImage: SKSpriteNode
    var dialogText: SKLabelNode
    var dialogLength: Int?
    var dialogStatusCount = 0
    var isNpcActive = false
    var interactionMark: SKSpriteNode

    init(imageName: String, npcName: String) {
        self.npcName = npcName
        
        interactionMark = SKSpriteNode(imageNamed: "frame11")
        dialogLength = dialogs[self.npcName]?.count
        playerImage = SKSpriteNode(imageNamed: "imgMada")
        npcImage = SKSpriteNode(imageNamed: imageName)
        dialogText = SKLabelNode(text: dialogs[self.npcName]?[0])

        /// Set Npc size here
        sprite = SKSpriteNode(imageNamed: imageName)
        sprite.size = CGSize(width: 55, height: 120)
        sprite.name = self.npcName
        sprite.addChild(interactionMark)

        dialogBox = SKSpriteNode(imageNamed: "frameConversation")
        dialogBox.name = "dialogBox"
        dialogBox.zPosition = 100
        dialogBox.size = CGSize(width: 720, height: 110)

        interactionMark.alpha = 1
        interactionMark.size = CGSize(width: 35, height: 50)
        interactionMark.name = "speechBubble"
        interactionMark.position.y = sprite.position.x + 80

        dialogText.name = "dialogText"
        npcImage.name = "npcImage"
        npcImage.position.x = dialogBox.frame.maxX - 25

        playerImage.name = "playerImage"
        playerImage.position.x = dialogBox.frame.minX + 80
        playerImage.size = CGSize(width: 90, height: 90)

    }

    func setupNpc(_ parent: SKNode, x: CGFloat, y: CGFloat, dialogBoxX: CGFloat? = nil, dialogBoxY: CGFloat? = nil) {
        parent.addChild(self.sprite)
        let dialogBoxPositionX = dialogBoxX ?? x
        let dialogBoxPositionY = dialogBoxY ?? y
        self.dialogBox.position = CGPoint(x: dialogBoxPositionX, y: dialogBoxPositionY)
        self.dialogBox.zPosition = 5005
        self.sprite.position = CGPoint(x: x, y: y)
    }

    func updateActionSpeechMark(_ playerSprite: SKSpriteNode) {
        let playerVsSpritePosition = (playerSprite.position.x - self.sprite.position.x)

        if (-distanceBetweenSpriteStart..<distanceBetweenSpriteEnd).contains(playerVsSpritePosition) {
            if playerSprite.xScale == 1 {
                self.sprite.childNode(withName: "speechBubble")?.alpha = 1
                self.isNpcActive = true
            }

        } else {
            self.sprite.childNode(withName: "speechBubble")?.alpha = 0
            self.isNpcActive = false
        }

    }

    func setupDialog() {
        dialogBox.addChild(dialogText)
        dialogBox.addChild(playerImage)
    }

    func removeDialog() {
        playerImage.removeFromParent()
        npcImage.removeFromParent()
        dialogText.removeFromParent()
        dialogStatusCount = 0
        dialogText.text = dialogs[self.npcName]?[0]
        dialogBox.removeFromParent()
    }

    func updateDialog() {
        if dialogStatusCount % 2 == 1 {
            if dialogBox.childNode(withName: "playerImage") == nil {
                dialogBox.addChild(playerImage)
            }
            if dialogBox.childNode(withName: "npcImage") != nil {
                npcImage.removeFromParent()
            }
        } else {
            if dialogBox.childNode(withName: "npcImage") == nil {
                dialogBox.addChild(npcImage)
            }
            if dialogBox.childNode(withName: "playerImage") != nil {
                playerImage.removeFromParent()
            }
        }

        if dialogStatusCount != dialogLength! - 1 {
            dialogStatusCount += 1
            dialogText.text = dialogs[self.npcName]?[dialogStatusCount]
        } else {
            removeDialog()
            dialogBox.removeFromParent()
        }
    }

    func handleNpcDialog(_ touch: UITouch) {
        if let parent = self.sprite.parent {
            let location = touch.location(in: parent)
            let node = parent.atPoint(location)

            if (node.name == "buttonNPCInteraction") && (parent.childNode(withName: "dialogBox") == nil) {
                    parent.addChild(dialogBox)
                    setupDialog()
            }

            if (node.name == "dialogBox") {
                    updateDialog()
                }
        }

    }

}
