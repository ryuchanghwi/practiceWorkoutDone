//
//  SceneDelegate.swift
//  workoutDonePractice
//
//  Created by 류창휘 on 2022/12/02.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: UIScreen.main.bounds)
        
        var viewController = UIViewController() //처음 보일 VC
//        let navigationController = UINavigationController(rootViewController: viewController)
//        navigationController.navigationBar.isTranslucent = true
        
//        if UserDefaults.standard.hasOnboarded {
//            viewController = TabBarController()
//        } else {
            viewController = OnboardingViewController()
//        }
        
        
        window?.rootViewController = viewController //위에서 만든 view controller를 첫 화면으로 띄우기
//        let appearance = UINavigationBarAppearance()
//        appearance.configureWithOpaqueBackground()
//        appearance.backgroundColor = UIColor.yellow
//        navigationController.navigationBar.standardAppearance = appearance
//        navigationController.navigationBar.scrollEdgeAppearance = navigationController.navigationBar.standardAppearance
        window?.makeKeyAndVisible() //화면 보이게끔
        window?.windowScene = windowScene
    }

    func sceneDidDisconnect(_ scene: UIScene) {

    }

    func sceneDidBecomeActive(_ scene: UIScene) {

    }

    func sceneWillResignActive(_ scene: UIScene) {

    }

    func sceneWillEnterForeground(_ scene: UIScene) {

    }

    func sceneDidEnterBackground(_ scene: UIScene) {

    }


}

