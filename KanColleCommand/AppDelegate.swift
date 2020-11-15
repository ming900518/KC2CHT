import UIKit
import CoreData
import AVFoundation
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var landscape: Bool = true
    var optionallyStoreTheFirstLaunchFlag = false
    let notificationCenter = UNUserNotificationCenter.current()
    let isFirstLaunch = UserDefaults.isFirstLaunch()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {optionallyStoreTheFirstLaunchFlag = UserDefaults.isFirstLaunch()
        URLProtocol.registerClass(WebHandler.self)
        do {
            let audioSession: AVAudioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(AVAudioSession.Category(rawValue: convertFromAVAudioSessionCategory(AVAudioSession.Category.playback)), options:AVAudioSession.CategoryOptions(rawValue: AVAudioSession.CategoryOptions.mixWithOthers.rawValue))//AVAudioSessionCategoryPlayback
        } catch {
            print("Got error in set AVAudioSession")
        }
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.requestAuthorization(options: options) {
            (didAllow, error) in
            if !didAllow {
                print("User has declined notifications")
                if self.isFirstLaunch == true {
                    Setting.savewarningAlert(value: 1)
                }
            } else {
                if self.isFirstLaunch == true {
                    Setting.savewarningAlert(value: 2)
                }
            }
        }
        notificationCenter.getNotificationSettings { (settings) in
            if settings.authorizationStatus != .authorized {
                print("User has declined notifications (in settings)")
                if Setting.getwarningAlert() == 2 {
                    Setting.savewarningAlert(value: 1)
                }
            }
        }
        return true
    }


    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.

    }


    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        window?.rootViewController?.beginAppearanceTransition(false, animated: false)
        window?.rootViewController?.endAppearanceTransition()
    }


    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        window?.rootViewController?.beginAppearanceTransition(true, animated: false)
        window?.rootViewController?.endAppearanceTransition()
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { (settings) in
            if settings.authorizationStatus != .authorized {
                print("User has declined notifications (in settings)")
                if Setting.getwarningAlert() == 2 {
                    Setting.savewarningAlert(value: 1)
                }
            }
        }
    }


    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { (settings) in
            if settings.authorizationStatus != .authorized {
                print("User has declined notifications (in settings)")
                if Setting.getwarningAlert() == 2 {
                    Setting.savewarningAlert(value: 1)
                }
            }
        }
    }


    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
    }
    
    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        print("RAM Warning!")
        let notificationCenter = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "RAM用量提醒"
        content.body = "RAM即將用盡，請盡快結束當前遊戲階段"
        content.sound = UNNotificationSound.default
        let identifier = "RAM Warning Notification"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: nil)
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
    }
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if (self.landscape) {
            if (UIScreen.current >= .iPhone6_1) {
                if (UIScreen.current < .iPad9_7) {
                    return .landscapeRight;
                } else {
                    return .landscape
                }
            } else {
                return .landscape
            }
        } else {
            return .landscape
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
	return input.rawValue
}

extension UserDefaults {
    // check for is first launch - only true on first invocation after app install, false on all further invocations
    // Note: Store this value in AppDelegate if you have multiple places where you are checking for this flag
    static func isFirstLaunch() -> Bool {
        let hasBeenLaunchedBeforeFlag = "hasBeenLaunchedBeforeFlag"
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: hasBeenLaunchedBeforeFlag)
        if (isFirstLaunch) {
            UserDefaults.standard.set(true, forKey: hasBeenLaunchedBeforeFlag)
            UserDefaults.standard.synchronize()
        }
        return isFirstLaunch
    }
}
