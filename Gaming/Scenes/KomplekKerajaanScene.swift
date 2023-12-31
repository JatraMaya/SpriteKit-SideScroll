//
//  SceneSecond.swift
//  Gaming
//
//  Created by Ahmad Fadly Iksan on 24/10/23.
//

import SpriteKit
import AVFoundation

class KomplekKerajaanScene: SKScene {

    let tutorialMovement: SKSpriteNode
//    let tutorialObjectInteraction: SKSpriteNode

    let player: Player
    let cameraNode: SKCameraNode

    let questInfo = SKSpriteNode()
    let questInfoImages: [String: String] = ["quest1": "questBali0"]

    let bg1: SKSpriteNode
    let bg2: SKSpriteNode
    let papanWitana: SKSpriteNode

    let objectPatakaNareswara: Item
    var isObjectInteractionButtonActive = false
    var buttonObjectInteraction: SKSpriteNode
    var activeItem: String = ""
    var isItemDescriptionShown = false

    var buttonSceneShifterToDesa: SKSpriteNode
    var buttonSceneShifterToSinggasana: SKSpriteNode

    var buttonNPCInteraction: SKSpriteNode
    var buttonQuestInfo: SKSpriteNode
    var buttonSetting: SKSpriteNode

    let npcDalamKerajaan: Npc
    var activeNpc: String = ""
    var isNPCInteractionButtonActive = false

    var audioPlayer: AVAudioPlayer?
    var isAudioPlayed = false

    override init(size: CGSize) {
        cameraNode = SKCameraNode()
        player = Player()

        tutorialMovement = SKSpriteNode(imageNamed: "TutorialMovement")

        npcDalamKerajaan = Npc(imageName: "IdleNpc", npcName: "npcDalamKerajaan", npcSize: CGSize(width: 55, height: 120), dialogBoxAssets: ["dialogPembawaPesan1", "dialogPembawaPesan2"])

        buttonNPCInteraction = SKSpriteNode(imageNamed: "btnNPCInteraction")
        buttonNPCInteraction.zPosition = layerPosition.layer4.rawValue
        buttonNPCInteraction.size = CGSize(width: 100, height: 60)

        buttonObjectInteraction = SKSpriteNode(imageNamed: "btnObjectInteraction")
        buttonObjectInteraction.zPosition = layerPosition.layer4.rawValue
        buttonObjectInteraction.size = CGSize(width: 100, height: 60)

        buttonSceneShifterToDesa = SKSpriteNode(imageNamed: "btnTransition")
        buttonSceneShifterToDesa.zPosition = layerPosition.layer4.rawValue
        buttonSceneShifterToDesa.size = CGSize(width: 100, height: 60)

        buttonSceneShifterToSinggasana = SKSpriteNode(imageNamed: "btnTransition")
        buttonSceneShifterToSinggasana.zPosition = layerPosition.layer4.rawValue
        buttonSceneShifterToSinggasana.size = CGSize(width: 100, height: 60)

        buttonQuestInfo = SKSpriteNode(imageNamed: "btnQuestInfo")
        buttonQuestInfo.zPosition = 5002

        buttonSetting = SKSpriteNode(imageNamed: "btnSetting")
        buttonSetting.zPosition = 5002

        objectPatakaNareswara = Item(size: size, imageName: "compNareswara", itemName: "nareswara", assetName: "ObjectInteractionPatakaSangDwijaNagaNareswara", spriteSize: CGSize(width: 35, height: 138))

        bg1 = SKSpriteNode(imageNamed: "gunungPenanggungan")
        bg2 = SKSpriteNode(imageNamed: "keraton2")
        papanWitana = SKSpriteNode(imageNamed: "compPapanWitana")

        bg1.name = "bg1"

        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: Call all the necessary function when game first load
    override func didMove(to view: SKView) {
        if !isAudioPlayed {
            isAudioPlayed = true
            playSound(named: "komplekKerajaan", fileType: "mp3")
            audioPlayer?.setVolume(0.1, fadeDuration: 10)
        }

        for background in [bg1, bg2] {
            if background.name != "bg1" {
                background.anchorPoint = CGPoint(x: 0.8, y: 0.5)
            } else {
                background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            }
            background.position = CGPoint(x: frame.width / 2, y: frame.height / 2)
            addChild(background)
        }

        bg1.setScale(0.5)
        bg2.setScale(0.25)

        setupNode()
    }


    // MARK: Update Scene (including node location) accroding to delta time
    override func update(_ currentTime: TimeInterval) {
        player.updatePlayerPositionRightToLeft(frame)
        
        buttonQuestInfo.position = CGPoint(x: cameraNode.frame.minX + frame.width * -0.45, y: cameraNode.frame.maxY - frame.height * -0.4)

        buttonSetting.position = CGPoint(x: cameraNode.frame.minX + frame.width * -0.45, y: cameraNode.frame.maxY - frame.height * -0.27)

        for i in [npcDalamKerajaan] {
            i.updateActionSpeechMark(player)
        }

        // Show the notification when the player finishes interacting with the NPC
        if npcDalamKerajaan.questisShow == true {
            let _ = buttonQuestInfo.position
            questInfo.position = CGPoint(x: cameraNode.frame.minX + frame.width * -0.25, y: cameraNode.frame.maxY - frame.height * -0.4) // Adjust the offset as needed
            // Update the image of the notification node based on the completed quest
                if let imageName = questInfoImages["quest1"] { // Replace 'completedQuest' with the variable that holds the name of the completed quest
                    questInfo.texture = SKTexture(imageNamed: imageName)
                    npcDalamKerajaan.questisShow = false
                }
            if childNode(withName: "questInfo") == nil {
                self.addChild(questInfo)
                let wait = SKAction.wait(forDuration: 4.0)
                let remove = SKAction.removeFromParent()
                let sequence = SKAction.sequence([wait, remove])
                questInfo.run(sequence)
            }
        }

        /// Update visibility of object interaction mark
        objectPatakaNareswara.updateActionCheckMark(player)

        if npcDalamKerajaan.isNpcActive {
            self.activeNpc = npcDalamKerajaan.npcName
        } else {
            self.activeNpc = ""
        }

        /// Check active object name
        if objectPatakaNareswara.isItemActive {
            self.activeItem = objectPatakaNareswara.itemName
        } else {
            self.activeItem = ""
        }

        /// Left Scene Barrier
        if player.position.x <= size.width / 2  {
            if !(player.position.x <= size.width / -0.72) {
                camera?.position.x = player.position.x
                bg1.position.x = (camera?.position.x)!
            }

            if player.position.x < -1480 {
                player.position.x = -1480
                player.stopPlayerMovement()
            }
        }

        /// Right Scene Barrier
        if player.position.x >= size.width / 2  {
            if !(player.position.x >= size.width / -0.72) {
                camera?.position.x = player.position.x
                bg1.position.x = (camera?.position.x)!
            }

            if player.position.x > 515 {
                player.position.x = 515
                player.stopPlayerMovement()
            }
        }

        /// Show Scene Shifter Button to Dese Majapahit
        if player.position.x >= 410 && player.position.x <= 515 {
            buttonSceneShifterToDesa.run(SKAction.moveTo(x: cameraNode.frame.maxX + 400, duration: 0.1))
        } else {
            buttonSceneShifterToDesa.run(SKAction.moveTo(x: cameraNode.frame.maxX + 600, duration: 0.5))
        }

        // Show Scene Shifter Button to Singgasana
        if player.position.x <= -780 && player.position.x >= -850 {
            buttonSceneShifterToSinggasana.run(SKAction.moveTo(x: cameraNode.frame.maxX + 400, duration: 0.1))
        } else {
            buttonSceneShifterToSinggasana.run(SKAction.moveTo(x: cameraNode.frame.maxX + 600, duration: 0.5))
        }

        /// Show NPC Interaction Button
        if npcDalamKerajaan.isNpcActive {
            buttonNPCInteraction.run(SKAction.moveTo(x: cameraNode.frame.maxX + 400, duration: 0.1))
            isNPCInteractionButtonActive = true
        } else {
            buttonNPCInteraction.run(SKAction.moveTo(x: cameraNode.frame.maxX + 600, duration: 0.5))
            isNPCInteractionButtonActive = false
        }

        /// Show Object Interaction Button
        if objectPatakaNareswara.isItemActive {
            buttonObjectInteraction.run(SKAction.moveTo(x: cameraNode.frame.maxX + 400, duration: 0.1))
            isObjectInteractionButtonActive = true
        } else {
            buttonObjectInteraction.run(SKAction.moveTo(x: cameraNode.frame.maxX + 600, duration: 0.5))
            isObjectInteractionButtonActive = false
        }
    }


    // MARK: control functionality when button is touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        for touch in touches {
            let location = touch.location(in: self)
            let node = self.atPoint(location)

            /// Touch show quest info
            if node.name == "buttonQuestInfo" {
                let _ = buttonQuestInfo.position
                questInfo.position = CGPoint(x: player.position.x, y: cameraNode.frame.maxY - frame.height * -0.4) // Adjust the offset as needed
                self.addChild(questInfo)
                let wait = SKAction.wait(forDuration: 3.0)
                let remove = SKAction.removeFromParent()
                let sequence = SKAction.sequence([wait, remove])
                questInfo.run(sequence)
            }

            /// Remove tutorial movement from scene
            if node.name == "movementTutorial" {
                tutorialMovement.removeFromParent()
            }

            /// Touch show dialog box
            if childNode(withName: "dialogBox") == nil && (node.name != "buttonNPCInteraction") {
                player.handlePlayerMovementRightToLeft(touch, self.size)
            }

            /// Touch run scene transition to desa majapahit
            if node.name == "buttonSceneShifterToDesa" {
                    SceneManager.shared.transition(self, toScene: .DesaScene, transition: SKTransition.fade(withDuration: 2))
                }

            /// Show item description
            if self.activeItem == self.objectPatakaNareswara.itemName {
                objectPatakaNareswara.showItemDescription(touch)
                isItemDescriptionShown = true
            }

            /// Touch run scene transition to Singgasana
            if node.name == "buttonSceneShifterToSinggasana" {
                let questTracker = UserDefaults.standard.integer(forKey: "questTracker")

                if questTracker == 2 {
                    SceneManager.shared.transition(self, toScene: .SingasanaScene, transition: SKTransition.fade(withDuration: 2))
                }
            }

            if node.name == "buttonQuestInfo" {
                buttonQuestInfo.run(SKAction.scale(to: 0.8, duration: 0.1))
                print("button quest info pressed")
            }

            if node.name == "buttonSetting" {
                buttonSetting.run(SKAction.scale(to: 0.8, duration: 0.1))
                print("button setting pressed")
            }

            if self.activeNpc == "npcDalamKerajaan" {
                npcDalamKerajaan.handleNpcDialog(touch)

            }
        }
    }


    // MARK: Tracking to stop functionality when button is no longer pressed
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let node = self.atPoint(location)

            player.stopPlayerMovement()

            if node.name == "buttonQuestInfo" {
                buttonQuestInfo.run(SKAction.scale(to: 1, duration: 0.1))
            }

            if node.name == "buttonSetting" {
                buttonSetting.run(SKAction.scale(to: 1, duration: 0.1))
            }
        }
    }

    // MARK: Various setup functions needed to build a scene
    func setupCamera() {
        cameraNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        camera = cameraNode
    }

    func setupNPCInteractionButton() {
        buttonNPCInteraction.name = "buttonNPCInteraction"
        buttonNPCInteraction.position = CGPoint(x: cameraNode.frame.maxX + 600, y: frame.height / 2)

        addChild(buttonNPCInteraction)
    }

    func setupObjectInteractionButton() {
        buttonObjectInteraction.name = "buttonObjectInteraction"
        buttonObjectInteraction.position = CGPoint(x: cameraNode.frame.maxX + 600, y: frame.height / 2)

        addChild(buttonObjectInteraction)
    }

    func setupSceneShifterToDesaButton() {
        buttonSceneShifterToDesa.name = "buttonSceneShifterToDesa"
        buttonSceneShifterToDesa.position = CGPoint(x: cameraNode.frame.maxX + 600, y: frame.height / 2)

        addChild(buttonSceneShifterToDesa)
    }

    func setupSceneShifterToSinggasanaButton() {
        buttonSceneShifterToSinggasana.name = "buttonSceneShifterToSinggasana"
        buttonSceneShifterToSinggasana.position = CGPoint(x: cameraNode.frame.maxX + 600, y: frame.height / 2)

        addChild(buttonSceneShifterToSinggasana)
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

    func setupPapanWitana() {
        papanWitana.name = "papanWitana"
        papanWitana.size = CGSize(width: 85, height: 133.5)
        papanWitana.position = CGPoint(x: -760, y: 165)

        addChild(papanWitana)
    }

    func setupTutorialMovement() {
        tutorialMovement.name = "movementTutorial"
        tutorialMovement.position = CGPoint(x: player.position.x - 1170, y: size.height / 2)
        tutorialMovement.size = CGSize(width: 852, height: 393)
        tutorialMovement.zPosition = 5010

        addChild(tutorialMovement)
    }

    func setupNode() {
//        setupSettingButton()
        setupQuestInfoButton()
        setupPapanWitana()
        setupCamera()
        setupNPCInteractionButton()
        setupObjectInteractionButton()
        setupSceneShifterToDesaButton()
        setupSceneShifterToSinggasanaButton()
        setupTutorialMovement()
        questInfo.name = "questInfo"
        questInfo.size = CGSize(width: 280, height: 44)
        player.setupPlayer(self, frame, xPos: -1170)
        objectPatakaNareswara.setupItem(self, x: -1070, y: 170)
        npcDalamKerajaan.setupNpc(self, x: -200, y: 135, dialogBoxX: player.position.x, dialogBoxY: 90)
    }


    // MARK: Function to handle play and pause sound
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
