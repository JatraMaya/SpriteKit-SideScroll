//
//  Tutorial.swift
//  Gaming
//
//  Created by Ahmad Fadly Iksan on 29/10/23.
//

import Foundation
import SpriteKit

let tutorialDialog = [
    "Tekan bagian layar sebelah kanan atau kiri untuk menggerakkan Mahapatih Gajah Mada",
    "Tekan tombol di sebelah kanan untuk berinteraksi dengan npc atau item di dalam game"
    ]


class Tutorial {

    let label: SKLabelNode
    let dialogBox: SKSpriteNode

    init(size: CGSize, parent: SKNode) {

        UserDefaults.standard.set(false, forKey: "isTutorialDone")
        self.dialogBox = SKSpriteNode(imageNamed: "frameConversation")
        self.dialogBox.name = "tutorialLabel"
        self.label = SKLabelNode(fontNamed: "SFProRounded")
        self.label.scene?.size.width = self.dialogBox.frame.maxX
        self.label.text = tutorialDialog[0]
        self.dialogBox.position = CGPoint(x: parent.position.x, y: parent.position.y + 150)

    }

    func presentText(_ parent: SKNode, frame: CGRect) {
        self.dialogBox.setScale(0.5)

        self.dialogBox.zPosition = layerPosition.layer4.rawValue
        self.dialogBox.size = CGSize(width: 720, height: 110)

        if parent.childNode(withName: "tutorialLabel") == nil {
            self.dialogBox.addChild(self.label)
            parent.addChild(self.dialogBox)

        }
    }

    func removeLabel(_ parent: SKNode) {
        if parent.childNode(withName: "tutorialLabel") != nil {
            self.label.text = tutorialDialog[1]
            self.label.removeFromParent()
            self.dialogBox.removeFromParent()
        }
    }

}

// Extention to resize Label node font size to it's parent container
extension SKLabelNode {
    func fitToWidth(maxWidth:CGFloat){
        while frame.size.width >= maxWidth {
            fontSize-=1.0
        }
    }
}
