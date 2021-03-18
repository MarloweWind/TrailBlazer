//
//  SceneDelegate.swift
//  TrailBlazer
//
//  Created by Алексей Мальков on 17.02.2021.
//  Copyright © 2021 Alexey Malkov. All rights reserved.
//

import UIKit
import UserNotifications

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        self.window?.viewWithTag(123)?.removeFromSuperview()
    }

    func sceneWillResignActive(_ scene: UIScene) {
        let blurScene = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurSceneView = UIVisualEffectView(effect: blurScene)
        blurSceneView.frame = window!.frame
        blurSceneView.tag = 123
        self.window?.addSubview(blurSceneView)
        
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { [unowned self] settings in
            switch settings.authorizationStatus {
                case .authorized:
                    print("Allowed")
                    self.sendNotificatioRequest(content: self.makeNotificationContent(), trigger: self.makeIntervalNotificatioTrigger())
                case .denied:
                    print("Denied")
                default:
                    break
            }
        }
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    private func makeNotificationContent() -> UNNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "Hello"
        content.subtitle = "Come back!"
        content.body = "Lets make a track"
        content.badge = 1
        return content
    }
    
    private func makeIntervalNotificatioTrigger() -> UNNotificationTrigger {
        return UNTimeIntervalNotificationTrigger(
            timeInterval: 30,
            repeats: false
        )
    }
    
    private func sendNotificatioRequest(
            content: UNNotificationContent,
            trigger: UNNotificationTrigger) {
            
        let request = UNNotificationRequest(
            identifier: "Hello",
            content: content,
            trigger: trigger
        )
        
        let center = UNUserNotificationCenter.current()
        center.add(request) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }


}

