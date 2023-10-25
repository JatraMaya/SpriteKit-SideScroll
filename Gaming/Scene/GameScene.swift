//
//  GameScene.swift
//  Gaming
//
//  Created by Ahmad Fadly Iksan on 11/10/23.
//

import SpriteKit
import AVFoundation

class GameScene: SKScene {

    var isActionButtonActive = false
    var buttonAction: SKSpriteNode
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

    override init(size: CGSize) {

        buttonAction = SKSpriteNode(color: UIColor.blue, size: CGSize(width: 100, height: 50))
        buttonAction.zPosition = 5002
        cameraNode = SKCameraNode()
        player = Player()
        npc1 = Npc(size: size, imageName: "npc-b-1", imageNpc: "npc-b-1", npcName: "npc1")
        npc2 = Npc(size: size, imageName: "npc-a-1", imageNpc: "npc-a-1", npcName: "npc2")
        item = Item(size: size, imageName: "key", itemName: "key", assetName: "asset")

        bg1 = SKSpriteNode(imageNamed: "BG-Layer1")
        bg2 = SKSpriteNode(imageNamed: "BG-Layer2")
        bg3 = SKSpriteNode(imageNamed: "BG-Layer3")
        bg4 = SKSpriteNode(imageNamed: "BG-Layer4")

        bg1.name = "bg1"

        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Call all the necessary function when game first load
    override func didMove(to view: SKView) {

        for background in [bg1, bg2, bg3, bg4] {
            background.setScale(0.5)

            if background.name != "bg1" {
                background.anchorPoint = CGPoint(x: 0.15, y: 0.5)
            } else {
                background.anchorPoint = CGPoint(x: 0.50, y: 0.5)
            }
            background.size.height = frame.height
            background.position = CGPoint(x: frame.width / 2, y: frame.height / 2)
            addChild(background)
        }

        bg3.zPosition = layerPosition.layer2
        bg4.zPosition = layerPosition.layer4
        player.setupPlayer()
        setupCamera()
        setupNpc()
        setupItem()
        setupActionButton()
        setupQuestInfoButton()
        setupSettingButton()



        scene!.name = "scene"
        scene?.zPosition = 100000
    }

    // Update Scene (including node location) accroding to delta time
    override func update(_ currentTime: TimeInterval) {
        // Define the trigger position
        /// Sungai 4200-4830
        /// Pantai 6100-6400
        let minTriggerPositionGayatriSong: CGFloat = 900
        let maxTriggerPositionGayatriSong: CGFloat = 4200// Define the trigger position based on your game logic

        // Check if the player's x position is within the trigger position range
            if player.position.x >= minTriggerPositionGayatriSong && player.position.x <= maxTriggerPositionGayatriSong {
                // The player is within the trigger position range
                if !isAudioPlayed {
                    isAudioPlayed = true
                    playSound(named: "villageSound", fileType: "mp3")
                    audioPlayer?.setVolume(1.0, fadeDuration: 5.0)
                }
            } else {
                // The player is outside the trigger position range
                if isAudioPlayed {
                    audioPlayer?.setVolume(0.0, fadeDuration: 5.0)
                    isAudioPlayed = false
                }
            }

        player.updatePlayerPositionLeftToRight(frame)

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

        if player.position.x >= size.width / 2  && player.position.x < bg2.size.width / 1.21 {
            camera?.position.x = player.position.x
            bg1.position.x = (camera?.position.x)!
            buttonAction.position.x = (cameraNode.frame.maxX * 3)
            for i in [npc1, npc2] {
                i.dialogBox.position.x = (cameraNode.frame.midX)
            }
            item.dialogBox.position.x = (cameraNode.frame.midX)
        } else if player.position.x > bg2.size.width / 1.21 {
            if player.position.x > 3059 {
                player.position.x = 3059
                player.stopPlayerMovement()
            }
        }

        if npc1.isNpcActive || npc2.isNpcActive || item.isItemActive {
            buttonAction.run(SKAction.moveTo(x: cameraNode.frame.maxX + 400, duration: 0.1))
            isActionButtonActive = true
        } else {
            buttonAction.run(SKAction.moveTo(x: cameraNode.frame.maxX * 3, duration: 5))
            isActionButtonActive = false
        }

        if player.position.x <= 270 {
            SceneManager.shared.transition(self, toScene: .SceneSecond, transition: SKTransition.fade(withDuration: 0.5))
        }
    }

    // control functionality when button is touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in (touches) {
            let location = touch.location(in: self)
            let node = self.atPoint(location)
//
//            if node.name == "buttocAction" {
//
//            }

            if childNode(withName: "dialogBox") == nil && (node.name != "buttonAction") {
                player.handlePlayerMovementLeftToRight(touch, self.size)
            }

            if self.activeNpc == "npc1" {
                npc1.handleNpcDialog(touch)
            } else if self.activeNpc == "npc2"{
                npc2.handleNpcDialog(touch)
            }
            
            if self.activeItem == self.item.itemName {
                item.handleItemDescription(touch)
            }

        }
    }

    // Tracking to stop functionality when button is no longer pressed
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        player.stopPlayerMovement()

    }

    // MARK: Various setup functions needed to build a scene
    func setupCamera() {
        cameraNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        camera = cameraNode
    }

    func setupNpc() {
        for i in [npc1, npc2] {
            addChild(i.sprite)
            i.dialogBox.position = CGPoint(x: size.width / 2, y: size.height / 5)
            i.dialogBox.zPosition = 5005
        }
        npc1.sprite.position = CGPoint(x: bg2.size.width / 2, y: size.height / 4.5)
        npc2.sprite.position = CGPoint(x: bg2.size.width / 2.8, y: size.height / 4.5)
    }

    func setupItem() {
        item.sprite.position = CGPoint(x: frame.maxX + 800, y: size.height / 4.5)
        item.dialogBox.position = CGPoint(x: size.width / 2, y: size.height / 5)
        item.dialogBox.zPosition = 5005
        
        addChild(item.sprite)
    }

    func setupActionButton() {
        buttonAction.name = "buttonAction"
        buttonAction.position = CGPoint(x: cameraNode.frame.maxX * 5, y: (frame.height / 2))

        addChild(buttonAction)
    }

    func setupQuestInfoButton() {
        lazy var questInfoButton: Button = {
            let button = Button(imagedName: "btnQuest", width: 44, height: 44) {
                SceneManager.shared.transition(self, toScene: .SecondScene, transition: SKTransition.fade(withDuration: 0.5))
            }
            button.zPosition = 5002
            return button
        }()

        anchorPoint = CGPoint(x: frame.width / 2, y: frame.height / 2)
        questInfoButton.position = CGPoint(x: frame.width * 0.05, y: (frame.height * 0.9))

        addChild(questInfoButton)
    }

    func setupSettingButton() {
        lazy var settingButton: Button = {
            let button = Button(imagedName: "btnSetting", width: 44, height: 44) {
                SceneManager.shared.transition(self, toScene: .SecondScene, transition: SKTransition.fade(withDuration: 0.5))
            }
            button.zPosition = 5002
            return button
        }()

        anchorPoint = CGPoint(x: frame.width / 2, y: frame.height / 2)
        settingButton.position = CGPoint(x: frame.width * 0.05, y: (frame.height * 0.75))

        addChild(settingButton)
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
