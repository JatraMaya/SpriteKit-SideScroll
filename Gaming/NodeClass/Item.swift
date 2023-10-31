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
    let objectInteractionMark: SKSpriteNode
    let itemName: String
    var itemPopUp: SKSpriteNode
    var isItemActive = false


    init(size: CGSize, imageName: String, itemName: String, assetName: String, spriteSize: CGSize) {

        self.sprite = SKSpriteNode(imageNamed: imageName)
        self.sprite.size = spriteSize
        self.itemName = itemName
        self.objectInteractionMark = SKSpriteNode(imageNamed: "objectInteractionMark")
        self.itemPopUp = SKSpriteNode(imageNamed: assetName)

        self.sprite.addChild(objectInteractionMark)
        self.sprite.name = "item"

        self.itemPopUp.name = "itemDescription"
        self.itemPopUp.zPosition = 5
        self.itemPopUp.size = CGSize(width: 720, height: 310)
        self.itemPopUp.position = CGPoint(x: 0, y: 1200)

        self.objectInteractionMark.alpha = 1
        self.objectInteractionMark.size = CGSize(width: 35, height: 50)
        self.objectInteractionMark.name = "questionMarkBubble"
        self.objectInteractionMark.position.y = sprite.position.x + 90

//        self.dialogBox.fillColor = UIColor.red
//        self.dialogBox.name = "dialogBox"
//        self.dialogBox.zPosition = 100
    }

    func setupItem(_ parent: SKScene, x: CGFloat, y: CGFloat) {
        self.sprite.position = CGPoint(x: x, y: y)
//        self.dialogBox.position = CGPoint(x: size.width / 2, y: size.height / 5)
//        self.dialogBox.zPosition = 5005

        parent.addChild(self.sprite)
    }

    func updateActionCheckMark(_ playerSprite: SKSpriteNode) {
        let playerVsSpritePosition = (playerSprite.position.x - self.sprite.position.x)

        if (-distanceBetweenSpriteStart..<distanceBetweenSpriteEnd).contains(playerVsSpritePosition) {
                self.sprite.childNode(withName: "questionMarkBubble")?.alpha = 1
                self.isItemActive = true

        } else {
            self.sprite.childNode(withName: "questionMarkBubble")?.alpha = 0
            self.isItemActive = false
        }

    }

    func showItemDescription(_ touch: UITouch) {
        if let parent = self.sprite.parent {
            let location = touch.location(in: parent)
            let node = parent.atPoint(location)

            if (node.name == "buttonObjectInteraction") && (parent.childNode(withName: "itemDescription") == nil) {
//                    parent.addChild(dialogBox)
                    setupDescription()
            }

            if (node.name == "itemDescription") {
                removeDescription()
                }
        }
    }

    func setupDescription(){
        self.sprite.addChild(itemPopUp)
        self.itemPopUp.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        itemPopUp.position.y = itemPopUp.parent!.position.y + 50
    }

    func removeDescription() {
        itemPopUp.removeFromParent()
    }

}
