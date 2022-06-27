//
//  NotificationViewController.swift
//  NotificationViewController
//
//  Created by 渴望 on 2021/9/8.
//  Copyright © 2021 guan. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet var label: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
        self.label?.text = notification.request.content.body
        self.label?.backgroundColor = .white
        self.label?.textColor = .white
    }

}
