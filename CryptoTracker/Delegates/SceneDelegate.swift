//
//  SceneDelegate.swift
//  CryptoTracker
//
//  Created by yash pindiwala on 2023-09-29.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        let coreDataStack = CoreDataStack(dataModelName: "CryptoTracker") // sharing a single object around the application
        guard let _ = (scene as? UIWindowScene) else { return }
        guard let rootVc = window?.rootViewController as? UITabBarController else {return}
        guard let nav1 = rootVc.viewControllers?[0] as? UINavigationController else {return}
        guard let view1 = nav1.topViewController as? ViewController else {return} // Main page
        view1.coreDataStack = coreDataStack
        guard let nav2 = rootVc.viewControllers?[1] as? UINavigationController else {return}
        guard let view2 = nav2.topViewController as? FavoriteViewController else {return} // Favorite page
        view2.coreDataStack = coreDataStack
        guard let nav3 = rootVc.viewControllers?[2] as? UINavigationController else {return}
        guard let view3 = nav3.topViewController as? InvestmentsViewController else {return}
        view3.coreDataStack = coreDataStack
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

