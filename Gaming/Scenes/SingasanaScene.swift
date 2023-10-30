//
//  SingasanaScene.swift
//  Gaming
//
//  Created by Ahmad Fadly Iksan on 25/10/23.
//

import SpriteKit
import AVFoundation


class SingasanaScene: SKScene {
    let player: Player
    let bg1: SKSpriteNode
    let bg2: SKSpriteNode
    let cameraNode: SKCameraNode

    var audioPlayer: AVAudioPlayer?
    var isAudioPlayed = false

    var buttonQuestInfo: SKSpriteNode
    var buttonSetting: SKSpriteNode

    override init(size: CGSize) {
        player = Player()
        bg1 = SKSpriteNode(imageNamed: "gunungPenanggungan")
        bg2 = SKSpriteNode(imageNamed: "SinggasanaNew")
        bg2.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        cameraNode = SKCameraNode()

        buttonQuestInfo = SKSpriteNode(imageNamed: "btnQuestInfo")
        buttonQuestInfo.zPosition = 5002

        buttonSetting = SKSpriteNode(imageNamed: "btnSetting")
        buttonSetting.zPosition = 5002

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
            audioPlayer?.setVolume(0.5, fadeDuration: 10)
        }

        for background in [bg1, bg2] {
            background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            background.position = CGPoint(x: frame.width / 2, y: frame.height / 2)
            addChild(background)
        }

        bg1.setScale(0.5)
        bg2.setScale(0.25)

        player.setupPlayer(self, frame, false, xPos: 700, yPos: 150)

        setupCamera()
        setupSettingButton()
        setupQuestInfoButton()
    }


    // MARK: Update Scene (including node location) accroding to delta time
    override func update(_ currentTime: TimeInterval) {
        print("\(player.position)")

        buttonQuestInfo.position = CGPoint(x: cameraNode.frame.minX + frame.width * -0.45, y: cameraNode.frame.maxY - frame.height * -0.4)

        buttonSetting.position = CGPoint(x: cameraNode.frame.minX + frame.width * -0.45, y: cameraNode.frame.maxY - frame.height * -0.27)
    }


    // MARK: control functionality when button is touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let node = self.atPoint(location)

            if node.name == "buttonQuestInfo" {
                buttonQuestInfo.run(SKAction.scale(to: 0.8, duration: 0.1))
                print("button quest info pressed")
                SceneManager.shared.transition(self, toScene: .KomplekKerajaanScene, transition: SKTransition.fade(withDuration: 2))
            }

            if node.name == "buttonSetting" {
                buttonSetting.run(SKAction.scale(to: 0.8, duration: 0.1))
                print("button setting pressed")
                SceneManager.shared.transition(self, toScene: .SingasanaScene, transition: SKTransition.fade(withDuration: 2))
            }
        }
    }


    // MARK: Tracking to stop functionality when button is no longer pressed
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
    }

    
    // MARK: Various setup functions needed to build a scene
    func setupCamera() {
        cameraNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        camera = cameraNode
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
