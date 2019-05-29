//
//  ViewController.swift
//  LocalNotifications
//
//  Created by Brian Sipple on 5/26/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit
import UserNotifications


class MainViewController: UIViewController {
    @IBOutlet weak var scheduleNotificationsButton: UIButton!
    
    lazy var notificationCenter = UNUserNotificationCenter.current()
    
    lazy var notificationCategories: Set<UNNotificationCategory> = {
        return [
            LocalNotification.Category.earthRotation.notificationCategory
        ]
    }()
    
    var canScheduleNotifications = false {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.notificationPermissionsChanged()
            }
        }
    }
}


// MARK: - Lifecycle

extension MainViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkNotificationPermissions()
    }
}


// MARK: - Event handling

extension MainViewController {
    
    @IBAction func authorizeButtonTapped(_ sender: UIButton) {
        authorizeLocalNotifications()
    }
    
    @IBAction func scheduleButtonTapped(_ sender: UIButton) {
        notificationCenter.removeAllPendingNotificationRequests()
        scheduleLocalNotifications()
    }
    
}


// MARK: - Private Helper Methods

private extension MainViewController {
    
    func authorizeLocalNotifications() {
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) {
            [weak self] (wasGranted, error) in
            
            guard error == nil else {
                return print("Error while attempting to authorize local notifications:\n\n\(error!)")
            }
            
            if wasGranted {
                print("🙂 Notification permission was granted!")
                self?.canScheduleNotifications = true
            } else {
                print("😞 Notification permission was not granted.")
            }
        }
    }
    
    
    func scheduleLocalNotifications() {
        notificationCenter.add(LocalNotification.earthRotation)
    }


    func registerNoticiationCategories() {
        print("registerNoticiationCategories")
        notificationCenter.setNotificationCategories(notificationCategories)
    }
    
    
    func checkNotificationPermissions() {
        notificationCenter.getNotificationSettings { [weak self] (settings) in
            self?.canScheduleNotifications = settings.authorizationStatus == .authorized
        }
    }
    
    
    func notificationPermissionsChanged() {
        UIView.animate(
            withDuration: 0.3,
            animations: {
                self.scheduleNotificationsButton.isEnabled = self.canScheduleNotifications
                self.scheduleNotificationsButton.alpha = self.canScheduleNotifications ? 1 : 0.4
            }
        )
        
        if canScheduleNotifications {
            notificationCenter.delegate = self
            registerNoticiationCategories()
        }
    }
}


// MARK: - UNUserNotificationCenterDelegate

extension MainViewController: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        switch response.actionIdentifier {
        case LocalNotification.Action.showInfo.identifier:
            let userInfo = response.notification.request.content.userInfo
            
            guard
                let title = userInfo[LocalNotification.ContentUserInfoKey.title] as? String,
                let message = userInfo[LocalNotification.ContentUserInfoKey.message] as? String
            else {
                preconditionFailure("Failed to find data from content user info")
            }
            
            display(alertMessage: message, titled: title)
        case UNNotificationDefaultActionIdentifier:
            display(
                alertMessage: "We heard you like alerts. So here's another alert to respond to your alert.",
                titled: "Yo Dawg!",
                confirmButtonTitle: "Sweet, Thanks!"
            )
        default:
            print("Unknown action identifier")
        }
        
        completionHandler()
    }
    
}
