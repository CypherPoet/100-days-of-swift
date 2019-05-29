//
//  Constants.swift
//  LocalNotifications
//
//  Created by Brian Sipple on 5/27/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UserNotifications


enum LocalNotification {
    static var earthRotation: UNNotificationRequest {
        return UNNotificationRequest(
            identifier: uuid,
            content: Content.earthRotation.requestContent,
            trigger: Trigger.firstSecondOfDay
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
        case showInfo
        
        var identifier: String {
            switch self {
            case .showInfo:
                return "Show"
            }
        }
        
        var title: String {
            switch self {
            case .showInfo:
                return "Tell me more..."
            }
        }
        
        var notificationAction: UNNotificationAction {
            switch self {
            case .showInfo:
                return .init(identifier: self.identifier, title: self.title, options: [.foreground])
            }
        }
    }
}


extension LocalNotification {
    enum Category {
        case earthRotation
        
        var identifier: String {
            switch self {
            case .earthRotation:
                return "Earth Rotation Status"
            }
        }
        
        var notificationCategory: UNNotificationCategory {
            switch self {
            case .earthRotation:
                return .init(identifier: self.identifier, actions: [Action.showInfo.notificationAction], intentIdentifiers: [])
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
        
        static func repeatingAfterSeconds(_ seconds: Double) -> UNTimeIntervalNotificationTrigger {
            guard seconds >= 60 else {
                preconditionFailure("time interval must be at least 60 for repeating triggers")
            }
            return UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: true)
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
        case earthRotation
        
        var requestContent: UNNotificationContent {
            let content = UNMutableNotificationContent()
            
            content.title = "🤯 Woah!"
            content.body = "The Earth has spun 0.00417 degrees on its axis since its day began in your time zone."
            
            content.userInfo[ContentUserInfoKey.title] = "🌎🌏🌍🌍🌏🌎"
            content.userInfo[ContentUserInfoKey.message] = """
            Earthlings use the concept of a "day" to represent a complete rotation \
            of their planet on its axis.
            
            This notification detected the passing \
            of a full Earth second. Progress!
            """
            
            content.sound = .default
            content.categoryIdentifier = Category.earthRotation.identifier
            
            return content as UNNotificationContent
        }
    }
}
