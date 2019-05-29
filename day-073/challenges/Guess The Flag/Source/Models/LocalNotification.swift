//
//  LocalNotification.swift
//  Guess the Flag
//
//  Created by Brian Sipple on 5/29/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//


import UserNotifications


enum LocalNotification {
    static var remindPlayer: UNNotificationRequest {
        return UNNotificationRequest(
            identifier: uuid,
            content: Content.remindToPlay.requestContent,
            trigger: Trigger.repeatingEachDay
        )
    }
}


extension LocalNotification {
    private static var uuid: String {
        return UUID().uuidString
    }
}


extension LocalNotification {
    enum Action {
        case remindPlayer
        
        var identifier: String {
            switch self {
            case .remindPlayer:
                return "Remind user to play"
            }
        }
        
        var title: String {
            switch self {
            case .remindPlayer:
                return "Let's Go!"
            }
        }
        
        var notificationAction: UNNotificationAction {
            switch self {
            case .remindPlayer:
                return .init(identifier: self.identifier, title: self.title, options: [.foreground])
            }
        }
    }
}


extension LocalNotification {
    enum Category {
        case playReminder
        
        var identifier: String {
            switch self {
            case .playReminder:
                return "Play Reminder"
            }
        }
        
        var notificationCategory: UNNotificationCategory {
            switch self {
            case .playReminder:
                return .init(
                    identifier: self.identifier,
                    actions: [Action.remindPlayer.notificationAction],
                    intentIdentifiers: []
                )
            }
        }
    }
}


extension LocalNotification {
    
    enum Trigger {
        static var firstSecondOfDay: UNCalendarNotificationTrigger {
            var dateComponents = DateComponents()
            
            dateComponents.calendar = Calendar.current
            dateComponents.hour = 0
            dateComponents.minute = 0
            dateComponents.second = 1
            
            return UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        }
        
        static var repeatingEachDay: UNCalendarNotificationTrigger {
            let now = Date()
            let calendar = Calendar.current
            let tomorrow = calendar.date(byAdding: .day, value: 1, to: now)!
            
            let components = calendar.dateComponents([.day], from: tomorrow)
            
            return UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        }
    }
}


extension LocalNotification {
    enum ContentUserInfoKey {
        static let message = "Custom Data Message"
        static let title = "Custom Data Title"
    }
}


extension LocalNotification {
    enum Content {
        case remindToPlay
        
        var requestContent: UNNotificationContent {
            switch self {
            case .remindToPlay:
                return makePlayReminderContent()
            }
        }
    }
}


private extension LocalNotification {
    static func makePlayReminderContent() -> UNNotificationContent {
        let content = UNMutableNotificationContent()
        
        content.title = "🇫🇷 Whose flag is this?"
        content.body = "Guess country flags like this and others. Start playing Guess the Flag now!"
        
        content.sound = .defaultCritical  // Join or die 😛
        content.categoryIdentifier = Category.playReminder.identifier
        
        return content as UNNotificationContent
    }
}

