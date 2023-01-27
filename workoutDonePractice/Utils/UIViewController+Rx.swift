//
//  UIViewController+Rx.swift
//  workoutDonePractice
//
//  Created by 류창휘 on 2023/01/18.
//

import RxSwift
import RxCocoa
import UIKit

extension Reactive where Base: UIViewController {
    var viewWillAppear: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewWillAppear(_:))).map { _ in }
        return ControlEvent(events: source)
    }
}
