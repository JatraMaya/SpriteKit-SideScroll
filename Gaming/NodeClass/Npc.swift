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

    init(size: CGSize, imageName: String, imageNpc: String, npcName: String) {
        self.npcName = npcName
        let dialogBoxSize = CGSize(width: size.width - 25, height: 100)
        dialogLength = dialogs[self.npcName]?.count
        playerImage = SKSpriteNode(imageNamed: "player1")
        npcImage = SKSpriteNode(imageNamed: imageName)
        dialogText = SKLabelNode(text: dialogs[self.npcName]?[0])

        sprite = SKSpriteNode(imageNamed: imageName)
        sprite.name = npcName
        dialogBox = SKShapeNode(rectOf: dialogBoxSize)
        dialogBox.name = "dialogBox"
        dialogBox.fillColor = UIColor.red
        dialogBox.zPosition = 100

        dialogText.name = "dialogText"
        playerImage.name = "playerImage"
        npcImage.name = "npcImage"

        playerImage.position.x = dialogBox.frame.minX + 50
        npcImage.position.x = dialogBox.frame.maxX - 50
        dialogText.position = CGPoint(x: dialogBox.frame.midX, y: dialogBox.frame.midY)

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

}
