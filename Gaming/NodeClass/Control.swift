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

        self.buttonLeft.alpha = 0.3
        self.buttonRight.alpha = 0.3
        self.buttonAction.alpha = 0.3

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
