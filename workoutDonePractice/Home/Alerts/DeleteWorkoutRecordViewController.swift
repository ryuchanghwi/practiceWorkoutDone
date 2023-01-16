//
//  DeleteWorkoutRecordViewController.swift
//  workoutDonePractice
//
//  Created by 류창휘 on 2022/12/13.
//

import UIKit
import SnapKit
import Then
import SwiftUI

class DeleteWorkoutRecordViewController : UIViewController {
    // MARK: - PROPERTIES
    private let alertView = UIView().then {
        $0.backgroundColor = UIColor(hex: 0xFFFFFF)
        $0.layer.cornerRadius = 15
    }
    private let deleteInfoLabel = UILabel().then {
        $0.text = "오늘의 운동 기록을 \n삭제할까요?"
        $0.numberOfLines = 2
        $0.font = .systemFont(ofSize: 20, weight: .bold)
        $0.textAlignment = .center
        $0.textColor = UIColor(hex: 0x000000)
    }
    private let deleteButton = UIButton().then {
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.setTitle("지울래요", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        $0.backgroundColor = UIColor(hex: 0xF54968)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(hex: 0xF54968).cgColor
    }
    private let cancelButton = UIButton().then {
        $0.setTitle("아니요", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        $0.setTitleColor(UIColor(hex: 0x929292), for: .normal)
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(hex: 0x929292).cgColor
    }
    
    // MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(hex: 0x000000, alpha: 0.2)
        view.addSubview(alertView)
        view.addSubview(deleteInfoLabel)
        view.addSubview(deleteButton)
        view.addSubview(cancelButton)
        layout()
    }
    
    func layout() {
        alertView.snp.makeConstraints { make in
            make.height.equalTo(227)
            make.width.equalTo(267)
            make.centerX.centerY.equalToSuperview()
        }
        deleteInfoLabel.snp.makeConstraints { make in
            make.centerX.equalTo(alertView)
            make.top.equalTo(alertView.snp.top).offset(47)
            make.height.equalTo(56)
        }
        cancelButton.snp.makeConstraints { make in
            make.leading.equalTo(alertView.snp.leading).offset(14)
            make.height.equalTo(57)
            make.width.equalTo(114)
            make.bottom.equalTo(alertView.snp.bottom).offset(-15)
        }
        deleteButton.snp.makeConstraints { make in
            make.trailing.equalTo(alertView.snp.trailing).offset(-14)
            make.height.equalTo(57)
            make.width.equalTo(114)
            make.bottom.equalTo(alertView.snp.bottom).offset(-15)
        }
    }
    
    // MARK: - ACTIONS
}
// MARK: - EXTENSIONs
extension DeleteWorkoutRecordViewController {
    
}



struct DeleteWorkoutRecordViewController_PreViews: PreviewProvider {
    static var previews: some View {
        DeleteWorkoutRecordViewController().toPreview().previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)")) //원하는 VC를 여기다 입력하면 된다.
    }
}


