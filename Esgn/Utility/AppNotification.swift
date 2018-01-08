//
//  AppNotification.swift
//  Skylane
//
//  Created by Somsak Wongsinsakul on 8/18/17.
//  Copyright © 2017 Maya Wizard. All rights reserved.
//

import UIKit

protocol NotificationName {
    var name: Notification.Name { get }
}

extension RawRepresentable where RawValue == String, Self: NotificationName {
    var name: Notification.Name {
        get {
            return Notification.Name(self.rawValue)
        }
    }
}

enum Notifications: String, NotificationName {
    case login
    case logout
    case sellingItem
    case cancelSellingItem
    case UpdateChatroom
}
