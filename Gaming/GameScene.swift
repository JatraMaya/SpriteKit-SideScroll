//
//  GameScene.swift
//  Gaming
//
//  Created by Ahmad Fadly Iksan on 11/10/23.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

    var player: SKSpriteNode!
    var npc: SKSpriteNode!
    var buttonLeft: SKLabelNode!
    var buttonRight: SKLabelNode!


    // Setup texture for player character for use in animation
    private var playerTexture1: SKTexture {
        return SKTexture(imageNamed: "player1")
    }

    private var playerTexture2: SKTexture {
        return SKTexture(imageNamed: "player2")
    }


    // Enable touch interaction in scene node so user can tap the button
    override var isUserInteractionEnabled: Bool {
        set { }
        get { return true }
    }

    // variable setup for updating player movement, tracking if player move either to the left or right
    var playerMoveLeft = false
    var playerMoveRight = false


    // Call all the necessary function when game first load
    override func didMove(to view: SKView) {
        createPlayer()
        createButton()
        createGround()
        // createNPC()
    }

    // Update Scene (including node location) accroding to delta time
    override func update(_ currentTime: TimeInterval) {
        updatePlayerPosition()
    }

    // control functionality when button is touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let node = self.atPoint(location)

            // Track which node is touch according to node name
            if node.name == "buttonLeft" {
                player.xScale = 1 // set image flip to normal
                print("leftTouch")
                print(player.position)
                walkAnimation("left")
                playerMoveLeft = true
            } else if node.name == "buttonRight" {
                player.xScale = -1 // set image flip to other direction when facing left
                walkAnimation("right")
                print("right touch")
                print(player.position)
                playerMoveRight = true
            } else {
                print(player.position)
                return
            }
        }
    }

    // Tracking to stop functionality when button is no longer pressed
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        player.removeAllActions()
        playerMoveLeft = false
        playerMoveRight = false
    }

    // function to setup player sprite
    func createPlayer() {

        let playerFrame1 = SKTexture(imageNamed: "player1")

        player = SKSpriteNode(texture: playerFrame1)

        // Setup physic body for player character
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.texture!.size())
        player.physicsBody?.affectedByGravity = true // set to true so player node can use gravity
        player.position = CGPoint(x: frame.midX, y: frame.midY) // setup player position inside the scene

        addChild(player)
    }

    // Temporary function to test npc creation
//    func createNPC() {
//        npc = SKSpriteNode(imageNamed: "npc-a-1")
//
//        npc.physicsBody = SKPhysicsBody(texture: npc.texture!, size: npc.texture!.size())
//        npc.physicsBody?.affectedByGravity = true
//        npc.position = CGPoint(x: frame.midX + 10, y: 0)
//
//        addChild(npc)
//    }

    // function to create ground node
    func createGround() {

        // Use basic color as Sprite
        let ground = SKSpriteNode(color: .brown, size: CGSize(width: frame.width, height: 100))

        // Applying physic body to ground node
        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
        ground.physicsBody?.affectedByGravity = false  // set so ground node doesn't get affected by gravity
        ground.physicsBody?.isDynamic = false // set to false so when player node touch the ground, the ground will mantain position

        // Setup ground node positon inside the scene
        ground.position = CGPoint(x: frame.width / 2, y: 0)
        addChild(ground)
    }

    // Function to create button
    func createButton() {

        // use SKLabel so we can just use SF Symbol as button instead of image, can be replace with SKSPrite if we want to use image instead
        buttonLeft = SKLabelNode(text: "◀️")
        buttonRight = SKLabelNode(text: "▶️")

        // Setup button position inside the scene
        buttonLeft.position = CGPoint(x: frame.minX + 35, y: frame.minY + 40)
        buttonRight.position = CGPoint(x: frame.minX + 85, y: frame.minY + 40)

        // Setup node name so it can be recognized in TouchBegin method
        buttonLeft.name = "buttonLeft"
        buttonRight.name = "buttonRight"

        // Setup node z position so it always stay ontop of every single node it the scene
        buttonLeft.zPosition = 50
        buttonRight.zPosition = 50

        // Setup node transparency
        buttonLeft.alpha = 0.5
        buttonRight.alpha = 0.5

        addChild(buttonLeft)
        addChild(buttonRight)

    }

    // control player animation with SKAction node
    func walkAnimation(_ direction: String) {

        // repeatForever method make the animation loop forever when the SKAction run
        player.run(SKAction.repeatForever(SKAction.animate(with: [playerTexture1, playerTexture2], timePerFrame: 0.10)))
    }

    // function to update player position in a scene
    func updatePlayerPosition() {

        // move player either left or right depend on either playerMoveLeft/playerMoveRight is true or false
        if playerMoveLeft {
            player.position.x -= 1
        }

        if playerMoveRight {
            player.position.x += 1
        }
    }
}
