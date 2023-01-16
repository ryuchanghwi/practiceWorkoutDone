//
//  WorkoutResultView.swift
//  workoutDonePractice
//
//  Created by 류창휘 on 2022/12/19.
//

import UIKit
import Then
import SnapKit
class WorkoutResultView : UIView {
    //components
    private let workoutResultLabel = UILabel().then {
        $0.text = "운동 결과"
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 24, weight: .bold)
        
    }
    private let workoutResultBaseView = UIView().then {
        $0.backgroundColor = HexColor.lightPurpleColor.getHexColor()
        $0.layer.cornerRadius = 12
    }
    private let workoutTimeLabel = UILabel().then {
        $0.textColor = HexColor.purpleColor.getHexColor()
        $0.text = "운동 시간"
        $0.font = .systemFont(ofSize: 12, weight: .medium)
        $0.textColor = .black
    }
    private let workoutTypeLabel = UILabel().then {
        $0.text = "운동 종목"
        $0.font = .systemFont(ofSize: 12, weight: .medium)
        $0.textColor = .black
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
        addSubview(workoutResultLabel)
        addSubview(workoutResultBaseView)
        addSubview(workoutTimeLabel)
        addSubview(workoutTypeLabel)
        
        workoutResultLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(30)
            make.height.equalTo(26)
        }
        workoutResultBaseView.snp.makeConstraints { make in
            make.top.equalTo(workoutResultLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(18)
            make.height.equalTo(82)
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
