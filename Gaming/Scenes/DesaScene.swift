//
//  GameScene.swift
//  Gaming
//
//  Created by Ahmad Fadly Iksan on 11/10/23.
//


import SpriteKit
import AVFoundation

class DesaScene: SKScene {

    var isNPCInteractionButtonActive = false
    var buttonNPCInteraction: SKSpriteNode

    var isObjectInteractionButtonActive = false
    var buttonObjectInteraction: SKSpriteNode
    var buttonQuestInfo: SKSpriteNode
    var buttonSetting: SKSpriteNode

    let player: Player
    let cameraNode: SKCameraNode
    let npc1: Npc
    let npc2: Npc
    let item: Item
    var activeNpc: String = ""
    var activeItem: String = ""

    var audioPlayer: AVAudioPlayer?
    var isAudioPlayed = false

    let bg1: SKSpriteNode
    let bg2: SKSpriteNode
    let bg3: SKSpriteNode
    let bg4: SKSpriteNode
    let kapalJungJawa: SKSpriteNode

    override init(size: CGSize) {

        buttonNPCInteraction = SKSpriteNode(imageNamed: "btnNPCInteraction")
        buttonNPCInteraction.zPosition = 5002

        buttonObjectInteraction = SKSpriteNode(imageNamed: "btnObjectInteraction")
        buttonObjectInteraction.zPosition = 5002
        buttonObjectInteraction.size = CGSize(width: 100, height: 60)

        buttonQuestInfo = SKSpriteNode(imageNamed: "btnQuestInfo")
        buttonQuestInfo.zPosition = 5002

        buttonSetting = SKSpriteNode(imageNamed: "btnSetting")
        buttonSetting.zPosition = 5002

        cameraNode = SKCameraNode()
        player = Player()
        npc1 = Npc(imageName: "npc-b-1", npcName: "npc1")
        npc2 = Npc(imageName: "npc-a-1", npcName: "npc2")
        item = Item(size: size, imageName: "key", itemName: "key", assetName: "asset")

        bg1 = SKSpriteNode(imageNamed: "gunungPenanggungan")
        bg2 = SKSpriteNode(imageNamed: "Layer1")
        bg3 = SKSpriteNode(imageNamed: "Layer2")
        bg4 = SKSpriteNode(imageNamed: "BG-Layer4")
        kapalJungJawa = SKSpriteNode(imageNamed: "compDjongPolos")

        bg1.name = "bg1"

        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Call all the necessary function when game first load
    override func didMove(to view: SKView) {
        if !isAudioPlayed {
            isAudioPlayed = true
            playSound(named: "Depan Kerajaan", fileType: "mp3")
            audioPlayer?.setVolume(0.5, fadeDuration: 10)
        }

        for background in [bg1, bg2, bg3, bg4] {
            if background.name != "bg1" {
                background.anchorPoint = CGPoint(x: 0.15, y: 0.5)
            } else {
                background.anchorPoint = CGPoint(x: 0.50, y: 0.5)
            }
            background.position = CGPoint(x: frame.width / 2, y: frame.height / 2)
            addChild(background)
        }
        
        bg1.setScale(0.5)
        bg2.setScale(0.25)
        bg3.setScale(0.25)

        bg3.zPosition = layerPosition.layer3.rawValue
        bg4.zPosition = layerPosition.layer4.rawValue
        player.setupPlayer(self, frame, xPos: 300, yPos: 125, width: 45, height: 125)
        setupCamera()
        npc1.setupNpc(self, x: (bg2.size.width / 2), y: (size.height / 4.5))
        npc2.setupNpc(self, x: (bg2.size.width / 2.8), y: (size.height / 4.5))
        item.setupItem(self, x: (frame.maxX + 800), y: (size.height / 5))
        setupNPCInteractionButton()
        setupObjectInteractionButton()
        setupQuestInfoButton()
        setupSettingButton()
        setupKapalJungJawa()
    }

    // Update Scene (including node location) accroding to delta time
    override func update(_ currentTime: TimeInterval) {
        // Define the trigger position
        /// Sungai 4200-4830
        /// Pantai 6100-6400
//        let minTriggerPositionGayatriSong: CGFloat = 900
//        let maxTriggerPositionGayatriSong: CGFloat = 4200// Define the trigger position based on your game logic
//
//        // Check if the player's x position is within the trigger position range
//        if player.position.x >= minTriggerPositionGayatriSong && player.position.x <= maxTriggerPositionGayatriSong {
//            // The player is within the trigger position range
//            if !isAudioPlayed {
//                isAudioPlayed = true
//                playSound(named: "villageSound", fileType: "mp3")
//                audioPlayer?.setVolume(1.0, fadeDuration: 5.0)
//            }
//        } else {
//            // The player is outside the trigger position range
//            if isAudioPlayed {
//                audioPlayer?.setVolume(0.0, fadeDuration: 5.0)
//                isAudioPlayed = false
//            }
//        }
        print("\(player.position)")
        player.updatePlayerPositionLeftToRight(frame)

        buttonQuestInfo.position = CGPoint(x: cameraNode.frame.minX + frame.width * -0.45, y: cameraNode.frame.maxY - frame.height * -0.4)

        buttonSetting.position = CGPoint(x: cameraNode.frame.minX + frame.width * -0.45, y: cameraNode.frame.maxY - frame.height * -0.27)

        for i in [npc1, npc2] {
            i.updateActionSpeechMark(player)
        }

        item.updateActionCheckMark(player)

        if npc1.isNpcActive {
            self.activeNpc = npc1.npcName
        } else if npc2.isNpcActive {
            self.activeNpc = npc2.npcName
        } else {
            self.activeNpc = ""
        }

        if item.isItemActive {
            self.activeItem = item.itemName
        } else {
            self.activeItem = ""
        }

        if player.position.x >= size.width / 2 {
            camera?.position.x = player.position.x
            bg1.position.x = (camera?.position.x)!
            buttonNPCInteraction.position.x = (cameraNode.frame.maxX * 3)
            for i in [npc1, npc2] {
                i.dialogBox.position.x = (cameraNode.frame.midX)
            }
            item.dialogBox.position.x = (cameraNode.frame.midX)
        }

        if npc1.isNpcActive || npc2.isNpcActive {
            buttonNPCInteraction.run(SKAction.moveTo(x: cameraNode.frame.maxX + 400, duration: 0.1))
            isNPCInteractionButtonActive = true
        } else {
            buttonNPCInteraction.run(SKAction.moveTo(x: cameraNode.frame.maxX * 3, duration: 5))
            isNPCInteractionButtonActive = false
        }

        if item.isItemActive {
            buttonObjectInteraction.run(SKAction.moveTo(x: cameraNode.frame.maxX + 400, duration: 0.1))
            isObjectInteractionButtonActive = true
        } else {
            buttonObjectInteraction.run(SKAction.moveTo(x: cameraNode.frame.maxX * 3, duration: 5))
            isObjectInteractionButtonActive = false
        }

        if player.position.x < 234 {
            player.position.x = 234
            player.stopPlayerMovement()
        }
    }

    // control functionality when button is touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in (touches) {
            let location = touch.location(in: self)
            let node = self.atPoint(location)

            if childNode(withName: "dialogBox") == nil && (node.name != "buttonNPCInteraction") {
                player.handlePlayerMovementLeftToRight(touch, self.size)
            }

            if self.activeNpc == "npc1" {
                npc1.handleNpcDialog(touch)
            } else if self.activeNpc == "npc2"{
                npc2.handleNpcDialog(touch)
            }

            if self.activeItem == self.item.itemName {
                item.showItemDescription(touch)
            }

            if node.name == "buttonQuestInfo" {
                buttonQuestInfo.run(SKAction.scale(to: 0.8, duration: 0.1))
                print("button quest info pressed")
                SceneManager.shared.transition(self, toScene: .KomplekKerajaanScene, transition: SKTransition.fade(withDuration: 1))
            }

            if node.name == "buttonSetting" {
                buttonSetting.run(SKAction.scale(to: 0.8, duration: 0.1))
                print("button setting pressed")
                SceneManager.shared.transition(self, toScene: .SingasanaScene, transition: SKTransition.fade(withDuration: 1))
            }
        }
    }

    // Tracking to stop functionality when button is no longer pressed
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let node = self.atPoint(location)

            if node.name == "buttonQuestInfo" {
                buttonQuestInfo.run(SKAction.scale(to: 1, duration: 0.1))
            }

            if node.name == "buttonSetting" {
                buttonSetting.run(SKAction.scale(to: 1, duration: 0.1))
            }
        }

        player.stopPlayerMovement()
    }

    // MARK: Various setup functions needed to build a scene
    func setupCamera() {
        cameraNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        camera = cameraNode
    }

    func setupNPCInteractionButton() {
        buttonNPCInteraction.name = "buttonNPCInteraction"
        buttonNPCInteraction.position = CGPoint(x: cameraNode.frame.maxX * 5, y: (frame.height / 2))

        addChild(buttonNPCInteraction)
    }

    func setupObjectInteractionButton() {
        buttonObjectInteraction.name = "buttonObjectInteraction"
        buttonObjectInteraction.position = CGPoint(x: cameraNode.frame.maxX * 5, y: (frame.height / 2))

        addChild(buttonObjectInteraction)
    }

    func setupQuestInfoButton() {
        buttonQuestInfo.name = "buttonQuestInfo"
        buttonQuestInfo.size = CGSize(width: 44, height: 44)

        addChild(buttonQuestInfo)
    }

    func setupSettingButton() {
        buttonSetting.name = "buttonSetting"
        buttonSetting.size = CGSize(width: 44, height: 44)

        addChild(buttonSetting)
    }

    func setupKapalJungJawa() {
        kapalJungJawa.name = "kapalJungJawa"
        kapalJungJawa.size = CGSize(width: 578, height: 501)
        kapalJungJawa.position = CGPoint(x: 3350, y: 300)

        addChild(kapalJungJawa)
    }

    // MARK: Function to handle play and pause sound
    // Function to play and pause sound
    func playSound(named: String, fileType: String) {
        guard let path = Bundle.main.path(forResource: named, ofType: fileType) else {
            print("Sound file not found")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.volume = 0.0
            audioPlayer?.play()
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }

    func stopSound() {
        audioPlayer?.stop()
    }
}
