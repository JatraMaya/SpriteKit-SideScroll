//
//  Item.swift
//  Gaming
//
//  Created by Ahmad Fadly Iksan on 20/10/23.
//

import Foundation
import SpriteKit

class Item {
    
    var sprite: SKSpriteNode
    var dialogBox: SKSpriteNode
    var dialogText: SKLabelNode
    var isItemActive = false
    var imageName: String

    init(size: CGSize, imageName: String) {
        self.imageName = imageName
        self.dialogBox = dialogBox
        self.dialogText = dialogText
        self.isItemActive = isItemActive

        sprite = SK
    }

    
}
