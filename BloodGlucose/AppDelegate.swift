//  AppDelegate.swift
//  BloodGlucose
//
//  Created by Sqluo on 6/2/15.
//  Copyright (c) 2015 Sqluo. All rights reserved.
//

/*
1.新浪开放平台帐号
帐号：zhaochenyu@59smart.com
密码：wujiuzhihui

2.腾讯开放平台帐号
帐号：2088858065
密码：83b07b9876

3.mob.com、微信开放平台帐号
帐号：644402920@qq.com
密码：aa123456

4.蒲公英
网址：http://www.pgyer.com
帐号：644402920@qq.com
密码：sql123…

5.企业打包分发帐号
网址：https://developer.apple.com
帐号：kefu@ufreet.com
密码：Ufreet2013

缓存路径
 /Users/wujiu/Library/Developer/Xcode/DerivedData

6.唯一标识符
企业：com.hanyou.ukang.bg.BloodGlucose
测试：com.wujiu.akluo.bg.BloodGlucose
AppStore:com.59medi.app.BloodGlucose

 
7.导入的字体库
ZoomlaShiShang-A022
PingFang SC 
PingFang TC
 
 
 
 8.
 alocsong@gmail.com
 Gnos@5711
 
 
*/




//------最新备份---------



import UIKit
//import CoreData



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
 
    var window: UIWindow?
    
 
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //隐藏导航栏时，更好的过渡体验
        self.window?.backgroundColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
        
        UINavigationBar.appearance().isTranslucent = false
        
        //设置状态栏文字颜色
        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: true)


        
        application.applicationIconBadgeNumber = 0
    
        
//        let url = URL(string: "http://www.baidu.com")
//        
//        let dic = [String:Any]()
//        
//        if #available(iOS 10.0, *) {
//            
//        } else {
//            // Fallback on earlier versions
//        }
        
        //print(UIFont.familyNames())
        
        //是否链接过蓝牙设备
        if let one:Bool = UserDefaults.standard.value(forKey: "oneNo") as? Bool{
            print("one\(one)")
        }else{
            //如果没有，就创建
            UserDefaults.standard.set(true, forKey: "oneNo")
        }
        //使用第三方库管理键盘
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        
//        ShareSDK.registerApp("f6a090182d32",
//            
//            activePlatforms: [
//                SSDKPlatformType.typeSinaWeibo.rawValue,
//                SSDKPlatformType.typeQQ.rawValue,
//                SSDKPlatformType.typeWechat.rawValue,
//            ],
//            onImport: {(platform : SSDKPlatformType) -> Void in
//                
//                switch platform{
//                    
//                case SSDKPlatformType.typeWechat:
//                    ShareSDKConnector.connectWeChat(WXApi.classForCoder())
//                    
//                case SSDKPlatformType.typeQQ:
//                    ShareSDKConnector.connectQQ(QQApiInterface.classForCoder(), tencentOAuthClass: TencentOAuth.classForCoder())
//                case SSDKPlatformType.typeSinaWeibo:
//                    ShareSDKConnector.connectWeibo(WeiboSDK.classForCoder())
//                default:
//                    break
//                }
//            },
//            onConfiguration: {(platform : SSDKPlatformType,appInfo : NSMutableDictionary!) -> Void in
//                switch platform {
//                    
//                case SSDKPlatformType.typeSinaWeibo:
//                    //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
//                    appInfo.ssdkSetupSinaWeibo(byAppKey: "4116292162",
//                        appSecret : "0e6bc6b530aff175cf28e6eb49012756",
//                        redirectUri : "http://youyitangweibo.com",
//                        authType : SSDKAuthTypeWeb)
//                    
//                    
//                case SSDKPlatformType.typeWechat:
//                    //设置微信应用信息
//                    appInfo.ssdkSetupWeChat(byAppId: "wxcd685bb6553039f5", appSecret: "aed6b79dc83b5cf472d3db755b59dbf3")
//                case SSDKPlatformType.typeQQ:
//                    appInfo.ssdkSetupQQ(byAppId: "1105108363", appKey: "mHDXLjaKPrCnwhrW", authType: SSDKAuthTypeBoth)
//                    
//                default:
//                    break
//                    
//                }
//       
//        })
        
        
        
        ShareSDK.registerApp("f6a090182d32",
                             activePlatforms: [
                                SSDKPlatformType.typeSinaWeibo.rawValue,
                                SSDKPlatformType.typeQQ.rawValue,
                                SSDKPlatformType.typeWechat.rawValue,
                                ],
                             onImport: { (platform: SSDKPlatformType) in
                
                                switch platform{
                    
                                case SSDKPlatformType.typeWechat:
                                    ShareSDKConnector.connectWeChat(WXApi.classForCoder())
                    
                                case SSDKPlatformType.typeQQ:
                                    ShareSDKConnector.connectQQ(QQApiInterface.classForCoder(), tencentOAuthClass: TencentOAuth.classForCoder())
                                case SSDKPlatformType.typeSinaWeibo:
                                    ShareSDKConnector.connectWeibo(WeiboSDK.classForCoder())
                                default:
                                    break
                                }
                
        }) { (platform: SSDKPlatformType, appInfo: NSMutableDictionary?) in
            
            switch platform {
                
            case SSDKPlatformType.typeSinaWeibo:
                //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                appInfo?.ssdkSetupSinaWeibo(byAppKey: "4116292162",
                                           appSecret : "0e6bc6b530aff175cf28e6eb49012756",
                                           redirectUri : "http://youyitangweibo.com",
                                           authType : SSDKAuthTypeWeb)
                
                
            case SSDKPlatformType.typeWechat:
                //设置微信应用信息
                appInfo?.ssdkSetupWeChat(byAppId: "wxcd685bb6553039f5", appSecret: "aed6b79dc83b5cf472d3db755b59dbf3")
            case SSDKPlatformType.typeQQ:
                appInfo?.ssdkSetupQQ(byAppId: "1105108363", appKey: "mHDXLjaKPrCnwhrW", authType: SSDKAuthTypeBoth)
                
            default:
                break
                
            }
        }
        
        
        
        
        //读取【设置】属性
        
        if let tmpRemindSetValueArray = UserDefaults.standard.object(forKey: "SetRemind") as? [String]{
            
            remindSetValueArray = tmpRemindSetValueArray
            
        }
        if let tmpisRemindArray = UserDefaults.standard.object(forKey: "isRemind") as? [Bool]{
            
            isRemind = tmpisRemindArray
            
        }
        
        
        //设置引导页
        
        guidePageStart()
        
        //设置本地推送
        let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(settings)
        

        //判断版本
        switch UIDevice.current.systemVersion.compare("9.0.0", options: NSString.CompareOptions.numeric) {
        case .orderedSame, .orderedDescending:
            PF_SC = "PingFang SC"
            PF_TC = "PingFang TC"
        default:
            PF_SC = "Heiti SC"
            PF_TC = "Heiti TC"
        }
        
        
     
        return true
    }
    
    func guidePageStart(){
        
        // 得到当前应用的版本号
        let infoDictionary = Bundle.main.infoDictionary
        let currentAppVersion = infoDictionary!["CFBundleShortVersionString"] as? String
        
        let userDefaults = UserDefaults.standard
        let appVersion = userDefaults.string(forKey: "appVersion")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // 如果appVersion为nil说明是第一次启动；如果appVersion不等于currentAppVersion说明是更新了
//        if appVersion == nil || appVersion != currentAppVersion {
        
        if appVersion == nil || appVersion != currentAppVersion {
            userDefaults.setValue(currentAppVersion, forKey: "appVersion")

            //引导页
            UserDefaults.standard.setValue(false, forKey: "isShowGuide")
            //监测页的免责声明
            UserDefaults.standard.setValue(true, forKey: "MYLiability")
            
            UserDefaults.standard.setValue(false, forKey: "SBMGGuide")
            
            let guidanceViewController = storyboard.instantiateViewController(withIdentifier: "GuidePageVC") as? GuidePageViewController
            self.window!.rootViewController = guidanceViewController
        }
        
        
    }
    
    

    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        
        
        guard notification.userInfo != nil else{
            return
        }
        
        application.applicationIconBadgeNumber = 0
        
        print("hahahahahahah")
        
    }
    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    
    //app进入后台
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

        
    }
    
    
    
    //app从后台到当前
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

    }
    //----------------
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
//        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
//    lazy var applicationDocumentsDirectory: URL = {
//        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.hanyou.ukang.bg..BloodGlucose" in the application's documents Application Support directory.
//        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        return urls[urls.count-1] 
//        }()
//    
//    lazy var managedObjectModel: NSManagedObjectModel = {
//        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
//        let modelURL = Bundle.main.url(forResource: "BloodGlucose", withExtension: "momd")!
//        return NSManagedObjectModel(contentsOf: modelURL)!
//        }()
//    
//    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
//        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
//        // Create the coordinator and store
//        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
//        let url = self.applicationDocumentsDirectory.appendingPathComponent("BloodGlucose.sqlite")
//        var error: NSError? = nil
//        var failureReason = "There was an error creating or loading the application's saved data."
//        do {
//            try coordinator!.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
//        } catch var error1 as NSError {
//            error = error1
//            coordinator = nil
//            // Report any error we got.
//            var dict = [String: AnyObject]()
//            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
//            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
//            dict[NSUnderlyingErrorKey] = error
//            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
//            // Replace this with code to handle the error appropriately.
//            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            NSLog("Unresolved error \(error), \(error!.userInfo)")
//            abort()
//        } catch {
//            fatalError()
//        }
//        
//        return coordinator
//        }()
//    
//    lazy var managedObjectContext: NSManagedObjectContext? = {
//        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
//        let coordinator = self.persistentStoreCoordinator
//        if coordinator == nil {
//            return nil
//        }
//        var managedObjectContext = NSManagedObjectContext()
//        managedObjectContext.persistentStoreCoordinator = coordinator
//        return managedObjectContext
//        }()
//    
//    // MARK: - Core Data Saving support
//    
//    func saveContext () {
//        if let moc = self.managedObjectContext {
//            var error: NSError? = nil
//            if moc.hasChanges {
//                do {
//                    try moc.save()
//                } catch let error1 as NSError {
//                    error = error1
//                    // Replace this implementation with code to handle the error appropriately.
//                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                    NSLog("Unresolved error \(error), \(error!.userInfo)")
//                    abort()
//                }
//            }
//        }
//    }
    
}

