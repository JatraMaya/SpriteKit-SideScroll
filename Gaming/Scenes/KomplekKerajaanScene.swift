//
//  SceneSecond.swift
//  Gaming
//
//  Created by Ahmad Fadly Iksan on 24/10/23.
//

import SpriteKit
import AVFoundation

class KomplekKerajaanScene: SKScene {
    var isTutorialDone: Bool
    let tutorial: Tutorial
    let player: Player
    let cameraNode: SKCameraNode

    let bg1: SKSpriteNode
    let bg2: SKSpriteNode
    let papanWitana: SKSpriteNode

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

        isTutorialDone = UserDefaults.standard.bool(forKey: "isTutorialDone")
        tutorial = Tutorial(size: size, parent: player)

        npcDalamKerajaan = Npc(imageName: "IdleNpc", npcName: "npcDalamKerajaan")

        buttonNPCInteraction = SKSpriteNode(imageNamed: "btnNPCInteraction")
        buttonNPCInteraction.zPosition = 5002

        buttonQuestInfo = SKSpriteNode(imageNamed: "btnQuestInfo")
        buttonQuestInfo.zPosition = 5002

        buttonSetting = SKSpriteNode(imageNamed: "btnSetting")
        buttonSetting.zPosition = 5002

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
        if !isTutorialDone {
            tutorial.presentText(player, frame: frame)
         }

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

        setupNPCInteractionButton()
        setupSettingButton()
        setupQuestInfoButton()
        setupPapanWitana()
        setupCamera()
        player.setupPlayer(self, frame, xPos: -540)
        npcDalamKerajaan.setupNpc(self, x: -200, y: 135, dialogBoxX: player.position.x, dialogBoxY: 90)
    }


    // MARK: Update Scene (including node location) accroding to delta time
    override func update(_ currentTime: TimeInterval) {
        player.updatePlayerPositionRightToLeft(frame)

        buttonQuestInfo.position = CGPoint(x: cameraNode.frame.minX + frame.width * -0.45, y: cameraNode.frame.maxY - frame.height * -0.4)

        buttonSetting.position = CGPoint(x: cameraNode.frame.minX + frame.width * -0.45, y: cameraNode.frame.maxY - frame.height * -0.27)

        for i in [npcDalamKerajaan] {
            i.updateActionSpeechMark(player)
        }

        if npcDalamKerajaan.isNpcActive {
            self.activeNpc = npcDalamKerajaan.npcName

            if !isTutorialDone {
                tutorial.presentText(player, frame: frame)
            }
        } else {
            self.activeNpc = ""
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
                print("hit")
            }
        }

        /// Setup Dialog Box Position
//        if player.position.x >= size.width / 2 {
//            camera?.position.x = player.position.x
//            bg1.position.x = (camera?.position.x)!
//            buttonNPCInteraction.position.x = (cameraNode.frame.maxX * 3)
//            for i in [npcDalamKerajaan] {
//                i.dialogBox.position.x = (cameraNode.frame.midX)
//            }
//        }

        if npcDalamKerajaan.isNpcActive {
            buttonNPCInteraction.run(SKAction.moveTo(x: cameraNode.frame.maxX + 400, duration: 0.1))
            isNPCInteractionButtonActive = true
        } else {
            buttonNPCInteraction.run(SKAction.moveTo(x: cameraNode.frame.maxX + 600, duration: 0.5))
            isNPCInteractionButtonActive = false
        }
    }


    // MARK: control functionality when button is touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isTutorialDone{
            self.tutorial.removeLabel(player)
        }

        for touch in touches {
            let location = touch.location(in: self)
            let node = self.atPoint(location)

            if childNode(withName: "dialogBox") == nil && (node.name != "buttonNPCInteraction") {
                player.handlePlayerMovementRightToLeft(touch, self.size)
            }

            if node.name == "buttonQuestInfo" {
                buttonQuestInfo.run(SKAction.scale(to: 0.8, duration: 0.1))
                print("button quest info pressed")
                SceneManager.shared.transition(self, toScene: .SingasanaScene, transition: SKTransition.fade(withDuration: 2))
            }

            if node.name == "buttonSetting" {
                buttonSetting.run(SKAction.scale(to: 0.8, duration: 0.1))
                print("button setting pressed")
                SceneManager.shared.transition(self, toScene: .DesaScene, transition: SKTransition.fade(withDuration: 2))
            }

            if self.activeNpc == "npcDalamKerajaan" {
                npcDalamKerajaan.handleNpcDialog(touch)

                if !isTutorialDone {
                    tutorial.removeLabel(player)
                    isTutorialDone = true
                    UserDefaults.standard.setValue(true, forKey: "isTutorialDone")
                }
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
