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

    var buttonNPCInteraction: SKSpriteNode
    var buttonQuestInfo: SKSpriteNode

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

        bg1 = SKSpriteNode(imageNamed: "BG-Layer1")
        bg2 = SKSpriteNode(imageNamed: "keraton2")

        bg1.name = "bg1"

        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(to view: SKView) {

        if !isTutorialDone {
            tutorial.presentText(player, frame: frame)
         }

        if !isAudioPlayed {
            isAudioPlayed = true
            playSound(named: "komplekKerajaan", fileType: "mp3")
            audioPlayer?.setVolume(1.0, fadeDuration: 10)
        }

        bg1.setScale(0.5)
        bg2.setScale(0.25)

        for i in [bg1, bg2] {

            if i.name != "bg1" {
                i.anchorPoint = CGPoint(x: 0.8, y: 0.5)
            } else {
                i.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            }

            i.position = CGPoint(x: frame.width / 2, y: frame.height / 2)
            addChild(i)
        }
        setupNPCInteractionButton()
        setupQuestInfoButton()
        setupCamera()
        player.setupPlayer(self, frame, xPos: -540)
        npcDalamKerajaan.setupNpc(self, x: -200, y: 135)

        print("\(npcDalamKerajaan.sprite)")
    }

    override func update(_ currentTime: TimeInterval) {
        player.updatePlayerPositionRightToLeft(frame)

        buttonQuestInfo.position = CGPoint(x: cameraNode.frame.minX + frame.width * -0.45, y: cameraNode.frame.maxY - frame.height * -0.4)

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

        if player.position.x >= size.width / 2 {
            camera?.position.x = player.position.x
            bg1.position.x = (camera?.position.x)!
            buttonNPCInteraction.position.x = (cameraNode.frame.maxX * 3)
            for i in [npcDalamKerajaan] {
                i.dialogBox.position.x = (cameraNode.frame.midX)
            }
        }

        if player.position.x <= size.width / 2  {
            if !(player.position.x <= size.width / -0.72) {
                camera?.position.x = player.position.x
                bg1.position.x = (camera?.position.x)!
            }
            if player.position.x < -1480 {
                player.position.x = -1480
                player.stopPlayerMovement()
            }
            if player.position.x > 576 {
                player.position.x = 576
                player.stopPlayerMovement()
            }
        }

        if npcDalamKerajaan.isNpcActive {
            buttonNPCInteraction.run(SKAction.moveTo(x: cameraNode.frame.maxX + 400, duration: 0.1))
            isNPCInteractionButtonActive = true
        } else {
            buttonNPCInteraction.run(SKAction.moveTo(x: cameraNode.frame.maxX + 600, duration: 0.5))
            isNPCInteractionButtonActive = false
        }
    }

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
                SceneManager.shared.transition(self, toScene: .DesaScene, transition: SKTransition.fade(withDuration: 1))
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

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let node = self.atPoint(location)

            player.stopPlayerMovement()

            if node.name == "buttonQuestInfo" {
                buttonQuestInfo.run(SKAction.scale(to: 1, duration: 0.1))
                print("button quest info pressed")
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
