//
//  SceneDelegate.swift
//  mood
//
//  Created by Harrison Borges on 5/24/20.
//  Copyright © 2020 hbb. All rights reserved.
//

import UIKit
import SwiftUI
import UserNotifications
import Firebase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
	var window: UIWindow?

	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		// Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
		// If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
		// This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

		// Use a UIHostingController as window root view controller.
		if let windowScene = scene as? UIWindowScene {
		    let window = UIWindow(windowScene: windowScene)
		    window.rootViewController = UIHostingController(rootView: MoodView())
		    self.window = window
		    window.makeKeyAndVisible()
		}
	}

	func sceneDidDisconnect(_ scene: UIScene) {
		// Called as the scene is being released by the system.
		// This occurs shortly after the scene enters the background, or when its session is discarded.
		// Release any resources associated with this scene that can be re-created the next time the scene connects.
		// The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
	}

	func sceneDidBecomeActive(_ scene: UIScene) {
		// Called when the scene has moved from an inactive state to an active state.
		// Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.

		let center = UNUserNotificationCenter.current()

		center.requestAuthorization(options: [.alert, .badge, .sound]) { [weak self] (granted, error) in
			if granted {
				self?.scheduleNotification()
			} else {
					print("Rejected")
			}
		}
	}

	func sceneWillResignActive(_ scene: UIScene) {
		// Called when the scene will move from an active state to an inactive state.
		// This may occur due to temporary interruptions (ex. an incoming phone call).
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

	func scheduleNotification() {
		let center = UNUserNotificationCenter.current()

		let content = UNMutableNotificationContent()
		content.title = "How are you feeling?"
		content.body = "Take a minute to check in with yourself"
		content.categoryIdentifier = "mood"
		content.sound = UNNotificationSound.default

		var morning = DateComponents()
		morning.hour = 11
		morning.minute = 0

		var afternoon = DateComponents()
		afternoon.hour = 15
		afternoon.minute = 30

		var evening = DateComponents()
		evening.hour = 22
		evening.minute = 30

		let morningTrigger = UNCalendarNotificationTrigger(dateMatching: morning, repeats: true)
		let afternoonTrigger = UNCalendarNotificationTrigger(dateMatching: afternoon, repeats: true)
		let eveningTrigger = UNCalendarNotificationTrigger(dateMatching: evening, repeats: true)

//		var test = DateComponents()
//		test.hour = 21
//		test.minute = 12
//		let testTrigger = UNCalendarNotificationTrigger(dateMatching: test, repeats: true)
//		let testRequest = UNNotificationRequest(identifier: "test", content: content, trigger: testTrigger)
//		center.add(testRequest) { (error : Error?) in
//			if let error = error {
//				print(error)
//			}
//		}

		let morningRequest = UNNotificationRequest(identifier: "mood-morning", content: content, trigger: morningTrigger)
		let afternoonRequest = UNNotificationRequest(identifier: "mood-afternoon", content: content, trigger: afternoonTrigger)
		let eveningRequest = UNNotificationRequest(identifier: "mood-evening", content: content, trigger: eveningTrigger)

		center.add(morningRequest)
		center.add(afternoonRequest)
		center.add(eveningRequest)
	}
}

