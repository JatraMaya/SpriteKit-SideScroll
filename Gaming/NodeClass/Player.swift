//
//  Player.swift
//  Gaming
//
//  Created by Ahmad Fadly Iksan on 12/10/23.
//

import Foundation
import SpriteKit

class Player: SKSpriteNode {

    let frame0 = SKTexture(imageNamed: "Frame_0")
    let frame1 = SKTexture(imageNamed: "Frame_1")
    let frame2 = SKTexture(imageNamed: "Frame_2")
    let frame3 = SKTexture(imageNamed: "Frame_3")
    let frame4 = SKTexture(imageNamed: "Frame_4")
    let frame5 = SKTexture(imageNamed: "Frame_5")
    let frame6 = SKTexture(imageNamed: "Frame_6")
    let frame7 = SKTexture(imageNamed: "Frame_7")
    let frame8 = SKTexture(imageNamed: "Frame_8")

    var playerMoveLeft = false
    var playerMoveRight = false

    init() {
        super.init(texture: frame0, color: UIColor.clear, size: frame0.size())
        self.name = "player"
        self.size = CGSize(width: 50, height: 135)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /// Handling Player walking animation with SKAction node
    func walkingAnimation() {
        let animate = SKAction.animate(with: [frame1, frame2, frame3,
                                              frame4, frame5,  frame6,
                                              frame7, frame8], timePerFrame: 0.10)
        self.run(SKAction.repeatForever(animate))
    }
    
    /// Update player location in the screen based on delta time and condition either playerMoveLeft/playerMoveRight boolean value
    /// - Parameter frame: Frame of parent scene
    func updatePlayerPositionLeftToRight(_ frame: CGRect) {
        if playerMoveLeft {
            self.xScale = -1
            self.position.x -= 3

            if self.position.x < frame.minX + 10 {
                self.position.x = frame.minX + 10
                self.stopPlayerMovement()
            }
        } else if playerMoveRight {
            self.xScale = 1
            self.position.x += 3

            if self.position.x > 6314 {
                self.position.x = 6314
            }
        }
    }

    func updatePlayerPositionRightToLeft(_ frame: CGRect) {
        if playerMoveLeft {
            self.xScale = -1
            self.position.x -= playerSpeed

//            if self.position.x > frame.minX + 10 {
//                self.position.x = frame.minX + 10
//                self.stopPlayerMovement()
//            }
        } else if playerMoveRight {
            self.xScale = 1
            self.position.x += playerSpeed
//
//            if self.position.x > 6314 {
//                self.position.x = 6314
//            }
        }
    }

    /// Set value for both playerMoveLeft & playerMoveRight back to false and remove all SKAction triggered by previous conditional
    func stopPlayerMovement() {
        playerMoveLeft = false
        playerMoveRight = false
        self.removeAllActions()
        self.texture = frame0
    }
    
    /// Funcrion to handle player movement from Left to Right
    /// - Parameters:
    ///   - touch: Value of UITouch
    ///   - size: size of parent scene
    func handlePlayerMovementLeftToRight(_ touch: UITouch, _ size: CGSize) {

        if let parent = self.parent {
            let location = touch.location(in: parent)
//            let node = self.parent?.atPoint(location)

            if (location.x < self.position.x || location.x < (size.width / 2)) {
                self.playerMoveRight = false
                self.playerMoveLeft = true
                self.walkingAnimation()
            } else {
                    self.playerMoveRight = true
                    self.playerMoveLeft = false
                    self.walkingAnimation()
                }
            }
//        }
    }

    /// Funcrion to handle player movement from Right to Left
    /// - Parameters:
    ///   - touch: Value of UITouch
    ///   - size: size of parent scene
    func handlePlayerMovementRightToLeft(_ touch: UITouch, _ size: CGSize) {

        if let parent = self.parent {
            let location = touch.location(in: parent)
//            let node = self.parent?.atPoint(location)

            if (location.x > self.position.x || location.x > (size.width / 2)) {
                self.playerMoveLeft = false
                self.playerMoveRight = true
                self.walkingAnimation()
            } else {
                    self.playerMoveLeft = true
                    self.playerMoveRight = false
                    self.walkingAnimation()
                }
            }
//        }
    }
}
