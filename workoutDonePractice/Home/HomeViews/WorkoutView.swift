//
//  WorkoutView.swift
//  workoutDonePractice
//
//  Created by 류창휘 on 2022/12/08.
//

import UIKit
import Then
import SnapKit

class WorkoutView : UIView {
    //components
    private let workoutLabel = UILabel().then {
        $0.text = "운동하기"
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 24, weight: .bold)
    }
    private let workoutRoutineBaseView = UIView().then {
        $0.backgroundColor = HexColor.lightPurpleColor.getHexColor()
        $0.layer.cornerRadius = 12
    }
    private let workoutRoutineInfoLabel = UILabel().then {
        $0.text = "어떤 운동을 할까?"
        $0.textColor = .gray
        $0.font = .systemFont(ofSize: 16, weight: .bold)
    }
    private let workoutRoutineChoiceButton = UIButton().then {
        $0.setTitle("루틴 선택", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        $0.backgroundColor = UIColor.purple
        $0.layer.cornerRadius = 8
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    func setupView() {
        addSubview(workoutLabel)
        addSubview(workoutRoutineBaseView)
        addSubview(workoutRoutineChoiceButton)
        addSubview(workoutRoutineInfoLabel)
        workoutLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(30)
            make.height.equalTo(26)
        }
        workoutRoutineBaseView.snp.makeConstraints { make in
            make.top.equalTo(workoutLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(18)
            make.height.equalTo(82)
        }
        workoutRoutineChoiceButton.snp.makeConstraints { make in
            make.centerY.equalTo(workoutRoutineBaseView)
            make.height.equalTo(47)
            make.width.equalTo(119)
            make.trailing.equalTo(workoutRoutineBaseView.snp.trailing).offset(-14)
        }
        workoutRoutineInfoLabel.snp.makeConstraints { make in
            make.centerY.equalTo(workoutRoutineBaseView)
            make.leading.equalTo(workoutRoutineBaseView.snp.leading).offset(19)
        }
    }
    
    
    
    
    
    enum HexColor {
        case backgroundColor
        case lightPurpleColor
        case mediumPurpleColor
        case purpleColor
        
        func getHexColor() -> UIColor {
            switch self {
            case .backgroundColor:
                return UIColor(hex: 0xFFFFF)
            case .mediumPurpleColor:
                return UIColor(hex: 0xE6E0FF)
            case .lightPurpleColor:
                return UIColor(hex: 0xF8F6FF)
            case .purpleColor:
                return UIColor(hex: 0x7442FF)
            }
        }
    }
}
