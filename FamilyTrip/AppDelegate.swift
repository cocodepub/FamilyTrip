//
//  AppDelegate.swift
//  FamilyTrip
//
//  Created by eve on 2021/11/1.
//

import UIKit
import Firebase
import FirebaseFirestore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var userBlogData: NetworkingBlog?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //Member page - Use Firebase library to configure APIs
        // let db = Firestore.firestore()
        FirebaseApp.configure()

        //Blog page
        userBlogData = NetworkingBlog()
        userBlogData!.get(author: "A8DFAF5E-62B1-4BAE-A17E-448E67FBE5B3")
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

