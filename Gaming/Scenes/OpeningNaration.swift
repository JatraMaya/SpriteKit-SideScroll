//
//  OpenigNaration.swift
//  Gaming
//
//  Created by Ahmad Fadly Iksan on 31/10/23.
//

import Foundation
import SpriteKit

class OpeningNaration: SKScene {
    

    let layer1: SKSpriteNode
    let layer2: SKSpriteNode
    let layer3: SKSpriteNode
    let layer4: SKSpriteNode

    override init(size: CGSize) {

        layer1 = SKSpriteNode(imageNamed: "Narrative 1")
        layer2 = SKSpriteNode(imageNamed: "Narrative 2")
        layer3 = SKSpriteNode(imageNamed: "Narrative 3")
        layer4 = SKSpriteNode(imageNamed: "Narrative 4")

        layer1.name = "layer1"
        layer2.name = "layer2"
        layer3.name = "layer3"
        layer4.name = "layer4"

        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(to view: SKView) {

        for i in [layer1, layer2, layer3, layer4] {
            i.setScale(0.25)
            i.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            i.position = CGPoint(x: frame.width / 2, y: (frame.height / 2) + 5)
        }

        addChild(self.layer1)
        }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let node = self.atPoint(location)

            if node.name == "layer1" {
                layer1.removeFromParent()
                addChild(layer2)
            } else if node.name == "layer2" {
                layer2.removeFromParent()
                addChild(layer3)
            } else if node.name == "layer3" {
                layer3.removeFromParent()
                addChild(layer4)
            } else {
                SceneManager.shared.transition(self, toScene: .KomplekKerajaanScene, transition: SKTransition.fade(withDuration: 2))
            }
        }
    }
    }
