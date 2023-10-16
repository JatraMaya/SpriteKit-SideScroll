//
//  Control.swift
//  Gaming
//
//  Created by Ahmad Fadly Iksan on 12/10/23.
//

import Foundation
import SpriteKit

class Control {

    enum actionButtonState {
        case isAction
        case isTalking
    }

    let alphaTransaparancy = 0.5
    let buttonZPosition: CGFloat = 100

    var buttonLeft = SKLabelNode(text: "◀️")
    var buttonRight = SKLabelNode(text: "▶️")
    var buttonAction = SKLabelNode(text: "🤚")

    init(buttonLeft: SKLabelNode = SKLabelNode(text: "◀️"), buttonRight: SKLabelNode = SKLabelNode(text: "▶️"), buttonAction: SKLabelNode = SKLabelNode(text: "🤚")) {

        self.buttonLeft = buttonLeft
        self.buttonRight = buttonRight
        self.buttonAction = buttonAction

        self.buttonLeft.name = "buttonLeft"
        self.buttonRight.name = "buttonRight"
        self.buttonAction.name = "buttonAction"

        self.buttonLeft.alpha = alphaTransaparancy
        self.buttonRight.alpha = alphaTransaparancy
        self.buttonAction.alpha = alphaTransaparancy

        self.buttonLeft.zPosition = buttonZPosition
        self.buttonRight.zPosition = buttonZPosition
        self.buttonAction.zPosition = buttonZPosition

    }

    func updateButtonAlpha(_ buttonName: String) {
        switch buttonName{
        case "buttonLeft":
            self.buttonLeft.alpha = 1
        case "buttonRight":
            self.buttonRight.alpha = 1
        default:
            self.buttonAction.alpha = 1
        }
    }

    func resetButtonAlpha() {
        for i in [buttonLeft, buttonRight, buttonAction] {
            i.alpha = self.alphaTransaparancy
        }
    }

    /// Handle the text/icon for buttonAction dependent either the action state is isAction/isTalking
    /// - Parameter state: from enum value of actionButtonState
    func updateButtonState(state: actionButtonState){
        let state = state
        switch state {
        case .isAction:
            buttonAction.text = "🤚"
        case .isTalking:
            buttonAction.text = "👄"
        }
    }
}
