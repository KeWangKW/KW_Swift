//
//  AppDelegate.swift
//  KW_Swift
//
//  Created by 渴望 on 2020/9/17.
//  Copyright © 2020 渴望. All rights reserved.
//

//                       .::::.
//                     .::::::::.
//                    :::::::::::
//                 ..:::::::::::'
//              '::::::::::::'
//                .::::::::::
//           '::::::::::::::..
//                ..::::::::::::.
//              ``::::::::::::::::
//               ::::``:::::::::'        .:::.
//              ::::'   ':::::'       .::::::::.
//            .::::'      ::::     .:::::::'::::.
//           .:::'       :::::  .:::::::::' ':::::.
//          .::'        :::::.:::::::::'      ':::::.
//         .::'         ::::::::::::::'         ``::::.
//     ...:::           ::::::::::::'              ``::.
//    ```` ':.          ':::::::::'                  ::::..
//                       '.:::::'                    ':'````..
//



import UIKit
import CoreData

import AppTrackingTransparency
import AdSupport

import AVKit

//#if DEBUG
//import LeakEyeLib
//#endif

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate  ,UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    
    var application: UIApplication?
    var launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.application = application
        self.launchOptions = launchOptions ?? [:]
        
        window = UIWindow.init()
        window?.frame = UIScreen.main.bounds
        window?.makeKeyAndVisible()
        
        
        
        AppConfig.shared.NewShowInitialController(in: window)
        
        return true
    }
    
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "KW_Swift")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    
    //MARK: 支付处理 web跳进app处理
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.absoluteString.contains("xds-scheme") {
            print(url.absoluteString)
//            AppPush.shared.pushToVC(urlStr: url.absoluteString)
        }else{
            DYPayment.shared.application(open: url)
            OpenUrlManager.open(url: url)
        }
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        return DYPayment.shared.application(open: userActivity)
    }
    
    
    
    
    
//    app初始化
//    func application(_:willFinishLaunchingWithOptions:)
//    func application(_:didFinishLaunchingWithOptions:)

    //app已经被激活
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        if #available(iOS 14, *) { //隐私权限
            ATTrackingManager.requestTrackingAuthorization(completionHandler: {     status in
                // Tracking authorization completed. Start loading ads here.
                // loadAd()
            })
        } else {
            // Fallback on earlier versions
        }
        
    }
    //app即将被挂起
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    //app回到前台
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    //app进入后台
    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }
    //app即将被杀死
    func applicationWillTerminate(_ application: UIApplication) {
        
    }
    
}


