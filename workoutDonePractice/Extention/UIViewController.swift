//
//  UIViewController.swift
//  workoutDonePractice
//
//  Created by 류창휘 on 2022/12/17.
//

import Foundation
import UIKit

extension UIViewController {
    // MARK: UIWindow의 rootViewController를 변경하여 화면전환
    func changeRootViewController(_ viewControllerToPresent: UIViewController) {
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = viewControllerToPresent
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil)
        } else {
            viewControllerToPresent.modalPresentationStyle = .overFullScreen
            self.present(viewControllerToPresent, animated: true, completion: nil)
        }
    }
}
