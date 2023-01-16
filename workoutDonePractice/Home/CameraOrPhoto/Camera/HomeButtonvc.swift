//
//  HomeButtonvc.swift
//  workoutDonePractice
//
//  Created by 류창휘 on 2022/12/17.
//

import UIKit
import SnapKit
import Then
class HomeButtonVC : UIViewController {
    // MARK: - PROPERTIES
    let label = UILabel().then {
        $0.text = "홈버튼이 있는 VC"
    }
    
    
    // MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    // MARK: - ACTIONS
}
// MARK: - EXTENSIONs
extension HomeButtonVC {
    
}

