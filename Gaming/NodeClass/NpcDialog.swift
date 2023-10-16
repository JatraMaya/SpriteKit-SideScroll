//
//  Dialog.swift
//  Gaming
//
//  Created by Ahmad Fadly Iksan on 16/10/23.
//

import Foundation
import SpriteKit

class NpcDialog {

    var sprite: SKSpriteNode
    var dialogBox: SKShapeNode

    init(size: CGSize, imageName: String, imagePlayer: String, imageNpc: String) {

        let dialogBoxSize = CGSize(width: size.width - 25, height: 100)
        let playerImage = SKSpriteNode(imageNamed: imagePlayer)
        let npcImage = SKSpriteNode(imageNamed: imageNpc)
        sprite = SKSpriteNode(imageNamed: imageName)
        dialogBox = SKShapeNode(rectOf: dialogBoxSize)
        dialogBox.fillColor = UIColor.red
        dialogBox.zPosition = 100

        playerImage.position.x = dialogBox.frame.minX + 50
        npcImage.position.x = dialogBox.frame.maxX - 50
        dialogBox.addChild(playerImage)
        dialogBox.addChild(npcImage)

    }

}
