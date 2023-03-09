//
//  NotificationHandler.swift
//  Financy
//
//  Created by Marvin Hülsmann on 06.03.23.
//

import Foundation
import UserNotifications
import SwiftUI

class NotificationHandler: ObservableObject {
    /// current notification
    var notifications = [Notification]()
    
    init() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted == true && error == nil {
                print("Notifications permitted")
                SettingsView().allowNotifications = true
            } else {
                print("Notifications not permitted")
                SettingsView().allowNotifications = false
            }
        }
    }
    
    /// Get the UNCalendarNotificationTrigger for the notification
    /// - Parameter launchIn: the date when the notification will be launched
    /// - Returns: UNCalendarNotificationTrigger for the request
    private func getTrigger(launchIn: Date) -> UNCalendarNotificationTrigger {
        // define the time when the notification will be called
        var dateComponents = DateComponents()
        dateComponents.hour = Calendar.current.component(.hour, from: launchIn)
        dateComponents.minute = Calendar.current.component(.minute, from: launchIn)
        dateComponents.month = Calendar.current.component(.month, from: launchIn)
        dateComponents.day = Calendar.current.component(.day, from: launchIn)
        dateComponents.weekOfMonth = Calendar.current.component(.weekOfMonth, from: launchIn)
        dateComponents.year = Calendar.current.component(.year, from: launchIn)
        return UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
    }
    
    /// Send a raw Push Notification
    /// - Parameters:
    ///   - title: Notification title
    ///   - body: Notification body
    ///   - launchIn: Notification will be launched on this date
    func sendNotificationRaw(title: String, body: String, launchIn: Int) {
        if SettingsView().allowNotifications {
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = body
            content.sound = UNNotificationSound.default
            
            // show this notification five seconds from now
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(launchIn), repeats: false)
            
            // choose a random identifier
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            // add our notification request
            UNUserNotificationCenter.current().add(request)
        }
    }
}
