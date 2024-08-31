//
//  SceneDelegate.swift
//  InfiniteScrollWithAVPlayer
//
//  Created by Jiwon Yoon on 8/31/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)


        let navgationController = UINavigationController()
        let navigator = MainViewNavigator(navigationController: navgationController)
        navigator.toMain()

        window?.rootViewController = navgationController

        window?.makeKeyAndVisible()
    }

}

