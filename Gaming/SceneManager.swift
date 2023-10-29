//
//  SceneManager.swift
//  Gaming
//
//  Created by bernardus kanayari on 24/10/23.
//

import Foundation
import SpriteKit

class SceneManager {
    
    enum SceneType: Int {
        case DesaScene, KomplekKerajaanScene, SingasanaScene
    }
    
    private init() {}
    
    static let shared = SceneManager()
    
    /// Handle the scene transition
    func transition(_ fromScene: SKScene, toScene: SceneType, transition: SKTransition? = nil) {
        guard let scene = getScene(toScene) else {return}
        
        if let transition = transition {
            scene.scaleMode = .resizeFill
            fromScene.view?.presentScene(scene, transition: transition)
        } else {
            scene.scaleMode = .resizeFill
            fromScene.view?.presentScene(scene)
        }
    }
    
    func getScene(_ sceneType: SceneType) -> SKScene? {
        switch sceneType {
        case SceneType.DesaScene:
            return DesaScene(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        case SceneType.KomplekKerajaanScene:
            return KomplekKerajaanScene(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        case SceneType.SingasanaScene:
            return SingasanaScene(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        }
    }
}
