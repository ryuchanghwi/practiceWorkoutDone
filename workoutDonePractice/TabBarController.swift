//
//  TabBarController.swift
//  workoutDonePractice
//
//  Created by 류창휘 on 2022/12/02.
//

import UIKit

class TabBarController : UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let firstTab = HomeViewController()
        let firstTabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "mic"), tag: 0)
        firstTab.tabBarItem = firstTabBarItem
        let secondTab = SecondViewController()
        secondTab.tabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "heart.fill"), tag: 1)
        let thirdTab = ThirdViewController()
        let thirdTabBarItem = UITabBarItem(title: "3번째", image: UIImage(systemName: "heart.fill"), tag: 2)
        thirdTab.tabBarItem = thirdTabBarItem
        
        viewControllers = [firstTab, secondTab, thirdTab]
//        tabBar.barTintColor = .purple
        tabBar.isTranslucent = false
        tabBar.barTintColor = .purple
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.blue
        
    }
}
