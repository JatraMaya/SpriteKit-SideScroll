//
//  Npc.swift
//  Gaming
//
//  Created by Ahmad Fadly Iksan on 13/10/23.
//

import Foundation
import SpriteKit

class Npc: SKSpriteNode {

    let playerCategory: UInt32 = 0x1 << 0
    let npcCategory: UInt32 = 0x1 << 1

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: UIColor.clear, size: CGSizeZero)

        self.zPosition = 10
    }
}
