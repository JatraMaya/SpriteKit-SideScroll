//
//  Dialog.swift
//  Gaming
//
//  Created by Ahmad Fadly Iksan on 16/10/23.
//

import Foundation
import SpriteKit

class NpcDialog: SKNode {



    private let isDisplayed = false
    var listText: [String] = []

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    init(listText: [String]) {
        super.init()
        self.listText = listText
        self.position = CGPoint(x: 100, y: 100)
    }

    func removeDialog() {
        if self.isDisplayed {
            self.removeFromParent()
        }
    }

}
