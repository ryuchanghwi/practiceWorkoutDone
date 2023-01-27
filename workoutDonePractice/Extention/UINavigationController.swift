//
//  UINavigationController.swift
//  workoutDonePractice
//
//  Created by 류창휘 on 2023/01/25.
//

import UIKit
extension UINavigationController {
    func popViewController(animated: Bool, completion:@escaping (()->())) -> UIViewController? {
        CATransaction.setCompletionBlock(completion)
        CATransaction.begin()
        let poppedViewController = self.popViewController(animated: animated)
        CATransaction.commit()
        return poppedViewController
    }
    
    func pushViewController(_ viewController: UIViewController, animated: Bool, completion:@escaping (()->())) {
        CATransaction.setCompletionBlock(completion)
        CATransaction.begin()
        self.pushViewController(viewController, animated: animated)
        CATransaction.commit()
    }
}
