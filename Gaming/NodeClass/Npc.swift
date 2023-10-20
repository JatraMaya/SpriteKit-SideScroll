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
    var dialogBox: SKShapeNode
    var npcName: String
    var playerImage: SKSpriteNode
    var npcImage: SKSpriteNode
    var dialogText: SKLabelNode
    var dialogLength: Int?
    var dialogStatusCount = 0
    var isNpcActive = false
    var interactionMark: SKLabelNode

    init(size: CGSize, imageName: String, imageNpc: String, npcName: String) {
        self.npcName = npcName
        let dialogBoxSize = CGSize(width: size.width - 65, height: size.height / 3.5)
        interactionMark = SKLabelNode(text: "💬")
        dialogLength = dialogs[self.npcName]?.count
        playerImage = SKSpriteNode(imageNamed: "player1")
        npcImage = SKSpriteNode(imageNamed: imageName)
        dialogText = SKLabelNode(text: dialogs[self.npcName]?[0])

        sprite = SKSpriteNode(imageNamed: imageName)
        sprite.name = npcName
        sprite.addChild(interactionMark)

        dialogBox = SKShapeNode(rectOf: dialogBoxSize)
        dialogBox.name = "dialogBox"
        dialogBox.fillColor = UIColor.red
        dialogBox.zPosition = 100

        interactionMark.alpha = 1
        interactionMark.fontSize = 20
        interactionMark.name = "speechBubble"
        interactionMark.position.y = sprite.position.x + 15

        dialogText.name = "dialogText"
        playerImage.name = "playerImage"
        npcImage.name = "npcImage"

        playerImage.position.x = dialogBox.frame.minX + 25
        npcImage.position.x = dialogBox.frame.maxX - 25

    }

    func updateActionSpeechMark(_ playerSprite: SKSpriteNode) {
        let playerVsSpritePosition = (playerSprite.position.x - self.sprite.position.x)

        if (-distanceBetweenSpriteStart..<distanceBetweenSpriteEnd).contains(playerVsSpritePosition) {
            if playerSprite.xScale == -1 {
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

            if (node.name == "buttonAction") && (parent.childNode(withName: "dialogBox") == nil) {
                    parent.addChild(dialogBox)
                    setupDialog()
            }

            if (node.name == "dialogBox") {
                    updateDialog()
                }
        }

    }

}
