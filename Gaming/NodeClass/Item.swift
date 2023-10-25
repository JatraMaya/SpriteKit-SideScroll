//
//  Item.swift
//  Gaming
//
//  Created by Ahmad Fadly Iksan on 20/10/23.
//

import Foundation
import SpriteKit

class Item {
    
    let sprite: SKSpriteNode
    let dialogBox: SKShapeNode
    let dialogText: SKLabelNode
    let interactionMark: SKLabelNode
    let itemName: String
    var itemPopUp: SKSpriteNode
    var isItemActive = false


    init(size: CGSize, imageName: String, itemName: String, assetName: String) {
        let dialogBoxSize = CGSize(width: size.width - 65, height: size.height / 3.5)

        self.sprite = SKSpriteNode(imageNamed: imageName)
        self.itemName = itemName
        self.dialogBox = SKShapeNode(rectOf: dialogBoxSize)
        self.interactionMark = SKLabelNode(text: "🔍")
        self.dialogText = SKLabelNode(text: "")
        self.itemPopUp = SKSpriteNode(imageNamed: assetName)

        self.sprite.addChild(interactionMark)
        self.sprite.name = "item"

        self.itemPopUp.name = "itemDesctiption"
        self.itemPopUp.zPosition = 5
        self.itemPopUp.size = CGSize(width: size.width, height: size.height)

        self.interactionMark.alpha = 1
        self.interactionMark.fontSize = 20
        self.interactionMark.name = "magnifier"
        self.interactionMark.position.y = sprite.position.x + 15
        
        self.dialogBox.fillColor = UIColor.red
        self.dialogBox.name = "dialogBox"
        self.dialogBox.zPosition = 100
    }

    func setupItem(_ parent: SKScene, x: CGFloat, y: CGFloat) {
        self.sprite.position = CGPoint(x: x, y: y)
//        self.dialogBox.position = CGPoint(x: size.width / 2, y: size.height / 5)
        self.dialogBox.zPosition = 5005

        parent.addChild(self.sprite)
    }

    func updateActionCheckMark(_ playerSprite: SKSpriteNode) {
        let playerVsSpritePosition = (playerSprite.position.x - self.sprite.position.x)

        if (-distanceBetweenSpriteStart..<distanceBetweenSpriteEnd).contains(playerVsSpritePosition) {
                self.sprite.childNode(withName: "magnifier")?.alpha = 1
                self.isItemActive = true

        } else {
            self.sprite.childNode(withName: "magnifier")?.alpha = 0
            self.isItemActive = false
        }

    }

    func handleItemDescription(_ touch: UITouch) {
        if let parent = self.sprite.parent {
            let location = touch.location(in: parent)
            let node = parent.atPoint(location)

            if (node.name == "buttonAction") && (parent.childNode(withName: "dialogBox") == nil) {
                    parent.addChild(dialogBox)
                    setupDescription()

            }

            if (node.name == "itemDesctiption") {
                removeDescription()
                }
        }
    }

    func setupDescription(){
        dialogText.text = itemDescriptions[self.itemName]
        dialogBox.addChild(itemPopUp)
        dialogBox.addChild(dialogText)
        itemPopUp.position.y = itemPopUp.parent!.position.y / 2
//        itemPopUp.anchorPoint = itemPopUp.parent!.position

    }

    func removeDescription() {
        dialogText.removeFromParent()
        dialogBox.removeFromParent()
        itemPopUp.removeFromParent()
    }

}
