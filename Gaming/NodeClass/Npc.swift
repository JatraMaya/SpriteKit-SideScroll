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
    var dialogLength: Int?
    var dialogStatusCount = 0
    var isNpcActive = false
    var interactionMark: SKSpriteNode
    var dialogBoxAssets: [String]
    var currentDialogBoxAssetIndex = 0

    init(imageName: String, npcName: String, npcSize: CGSize, dialogBoxAssets: [String]) {
        self.npcName = npcName
        
        interactionMark = SKSpriteNode(imageNamed: "frame11")
        dialogLength = dialogs[self.npcName]?.count
        self.dialogBoxAssets = dialogBoxAssets

        /// Set Npc size here
        sprite = SKSpriteNode(imageNamed: imageName)
        sprite.size = npcSize
        sprite.name = self.npcName
        sprite.addChild(interactionMark)

        dialogBox = SKSpriteNode(imageNamed: "dialogPembawaPesan1")
        dialogBox.name = "dialogBox"
        dialogBox.zPosition = 100
        dialogBox.size = CGSize(width: 720, height: 110)

        interactionMark.alpha = 1
        interactionMark.size = CGSize(width: 35, height: 50)
        interactionMark.name = "speechBubble"
        interactionMark.position.y = sprite.position.x + 80
    }

    func setupNpc(_ parent: SKNode, x: CGFloat, y: CGFloat, dialogBoxX: CGFloat? = nil, dialogBoxY: CGFloat? = nil) {
        parent.addChild(self.sprite)
        let dialogBoxPositionX = dialogBoxX ?? x
        let dialogBoxPositionY = dialogBoxY ?? y
        self.dialogBox.position = CGPoint(x: dialogBoxPositionX, y: dialogBoxPositionY)
        self.dialogBox.zPosition = layerPosition.layer5.rawValue
        self.sprite.position = CGPoint(x: x, y: y)
    }

    func updateActionSpeechMark(_ playerSprite: SKSpriteNode) {
        let playerVsSpritePosition = (playerSprite.position.x - self.sprite.position.x)

        if (-distanceBetweenSpriteStart..<distanceBetweenSpriteEnd).contains(playerVsSpritePosition) {
            if playerSprite.xScale == 1 {
                self.sprite.childNode(withName: "speechBubble")?.alpha = 1
                self.isNpcActive = true
            }

            self.dialogBox.position.x = playerSprite.position.x
            self.dialogBox.position.y = playerSprite.position.y - 55

        } else {
            self.sprite.childNode(withName: "speechBubble")?.alpha = 0
            self.isNpcActive = false
        }

    }

    func setupDialog() {
        let dialogBoxAsset = dialogBoxAssets[currentDialogBoxAssetIndex]
        dialogBox.texture = SKTexture(imageNamed: dialogBoxAsset)

        currentDialogBoxAssetIndex += 1
        if currentDialogBoxAssetIndex == dialogBoxAssets.count {
            currentDialogBoxAssetIndex = 0
        }
    }

    func removeDialog() {
        dialogStatusCount = 0
        dialogBox.removeFromParent()
    }

    func updateDialog() {
        if dialogStatusCount != dialogLength! - 1 {
            dialogStatusCount += 1
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
                let randomIndex = Int.random(in: 0..<dialogBoxAssets.count)
                let dialogBoxAsset = dialogBoxAssets[randomIndex]
                dialogBox.texture = SKTexture(imageNamed: dialogBoxAsset)
            }
        }
    }
}
