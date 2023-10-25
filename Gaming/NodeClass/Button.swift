//
//  Button.swift
//  Gaming
//
//  Created by bernardus kanayari on 25/10/23.
//

import Foundation
import SpriteKit

class Button: SKNode {
    var isEnabled = true
    var button: SKSpriteNode
    private var mask: SKSpriteNode
    private var cropNode: SKCropNode
    private var action: () -> Void

    init(imagedName: String, width: CGFloat, height: CGFloat,buttonAction: @escaping () -> Void) {
        button = SKSpriteNode(imageNamed: imagedName)
        button.size = CGSize(width: width, height: height)

        mask = SKSpriteNode(color: SKColor.black, size: button.size)
        mask.alpha = 0

        cropNode = SKCropNode()
        cropNode.maskNode = button
        cropNode.zPosition = 3
        cropNode.addChild(mask)

        action = buttonAction

        super.init()

        isUserInteractionEnabled = true

        setupNode()
        addNode()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupNode() {
        button.zPosition = 0
    }

    func addNode() {
        addChild(button)
        addChild(cropNode)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isEnabled {
            mask.alpha = 0.8
            run(SKAction.scale(by: 1.0, duration: 0.01))
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isEnabled {
            for touch in touches {
                let location: CGPoint = touch.location(in: self)

                if button.contains(location) {
                    mask.alpha = 0.5
                } else {
                    mask.alpha = 0.0
                }
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isEnabled {
            for touch in touches {
                let location: CGPoint = touch.location(in: self)

                if button.contains(location) {
                    disable()
                    action()
                    run(SKAction.sequence([SKAction.wait(forDuration: 0.2), SKAction.run({
                        self.enable()
                    })]))
                }
            }
        }
    }

    func disable() {
        isEnabled = false
        mask.alpha = 0.0
        button.alpha = 0.5
    }

    func enable() {
        isEnabled = true
        mask.alpha = 0.0
        button.alpha = 1.0
    }
}
