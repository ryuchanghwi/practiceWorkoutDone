//
//  RecordView.swift
//  workoutDonePractice
//
//  Created by 류창휘 on 2022/12/04.
//

import UIKit
import Then
import SnapKit

class RecordView : UIView {
    //component
    let recordLabel = UILabel().then {
        $0.text = "기록하기"
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 24)
    }
    let recordView = UIView().then {
        $0.backgroundColor = HexColor.lightPurpleColor.getHexColor()
        $0.layer.cornerRadius = 12
    }
    let workoutImageBaseView = UIView().then {
        $0.backgroundColor = HexColor.mediumPurpleColor.getHexColor()
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 0.5
        $0.layer.borderColor = UIColor(hex: 0x7442FF).cgColor
    }
    let workoutNotDoneInfoLabel = UILabel().then {
        $0.text = "아직 오늘의 운동 사진이 없습니다. \n운동을 하고 인증을 해 봅시다!"
        $0.textColor = UIColor(hex: 0xA5A5A5)
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 14, weight: .medium)
        $0.numberOfLines = 2
    }
    let clickImage = UIImageView().then {
        $0.image = UIImage(systemName: "cursorarrow.rays")
        $0.contentMode = .scaleAspectFill
    }
    let clickAlertLabel = UILabel().then {
        $0.text = "오늘의 운동을 마쳤다면 클릭!"
        $0.textColor = UIColor(hex: 0x7442FF)
        $0.font = .systemFont(ofSize: 16, weight: .medium)
    }
    let bodyImageView = UIImageView().then {
        $0.image = UIImage(named: "")
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 0.5
        $0.layer.borderColor = UIColor(hex: 0x7442FF).cgColor
    }
    let workoutDoneCameraButton = UIButton()
    
    
    let bodyDataBaseView = UIView().then {
        $0.layer.cornerRadius = 10
        $0.backgroundColor = .white
    }
    
    
    
    let bodyDataEntryButton = UIButton().then {
        $0.layer.cornerRadius = 10
        $0.setImage(UIImage(systemName: "pencil"), for: .normal)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(hex: 0x7442FF).cgColor
        
    }
    
    let bodyInfoView = UIView().then {
        $0.backgroundColor = .orange
    }
    let separateView = UIView().then {
        $0.backgroundColor = .black
    }
    
    let weightLabel = UILabel().then {
        $0.text = "체중"
    }
    
    let weightInputLabel = UILabel().then {
        $0.text = "120 KG"
    }
    
    let skeletalMuscleMassLabel = UILabel().then {
        $0.text = "골격근량"
    }
    
    let skeletalMuscleMassInputLabel = UILabel().then {
        $0.text = "20 %"
    }
    
    let fatPercentageLabel = UILabel().then {
        $0.text = "체지방량"
    }
    
    let fatPercentageInputLabel = UILabel().then {
        $0.text = "20 kg"
    }
    
    
    let skelatalMuscleMassAndFatPercentageLabelStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = 0
    }
    let skelatalMuscleMassAndFatPercentageInputLabelStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = 0
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
        addSubview(recordLabel)
        addSubview(recordView)
        addSubview(workoutImageBaseView)
        addSubview(workoutNotDoneInfoLabel)
        addSubview(clickImage)
        addSubview(clickAlertLabel)
        addSubview(bodyDataEntryButton)
        addSubview(bodyImageView)
        addSubview(workoutDoneCameraButton)
        addSubview(bodyInfoView)
        addSubview(separateView)
        addSubview(weightLabel)
        addSubview(weightInputLabel)
        addSubview(skelatalMuscleMassAndFatPercentageLabelStackView)
        addSubview(skelatalMuscleMassAndFatPercentageInputLabelStackView)
        [skeletalMuscleMassLabel, fatPercentageLabel].forEach({
            skelatalMuscleMassAndFatPercentageLabelStackView.addArrangedSubview($0)
        })
        [skeletalMuscleMassInputLabel, fatPercentageInputLabel].forEach({
            skelatalMuscleMassAndFatPercentageInputLabelStackView.addArrangedSubview($0)
        })
        //체지방량, 골격근량 라벨
        skelatalMuscleMassAndFatPercentageLabelStackView.snp.makeConstraints { make in
            make.centerY.equalTo(bodyInfoView)
            make.leading.equalTo(separateView.snp.trailing).offset(11)
        }
        skelatalMuscleMassAndFatPercentageInputLabelStackView.snp.makeConstraints { make in
            make.centerY.equalTo(bodyInfoView)
            make.trailing.equalTo(bodyInfoView.snp.trailing).offset(-10)
        }
        fatPercentageLabel.snp.makeConstraints { make in
            make.height.equalTo(26)
        }
        fatPercentageInputLabel.snp.makeConstraints { make in
            make.height.equalTo(26)
        }
        skeletalMuscleMassLabel.snp.makeConstraints { make in
            make.height.equalTo(26)
        }
        skeletalMuscleMassInputLabel.snp.makeConstraints { make in
            make.height.equalTo(26)
        }
        
        
        
        //바디정보 입력 뷰
        bodyInfoView.snp.makeConstraints { make in
            make.top.equalTo(workoutImageBaseView.snp.bottom).offset(16)
            make.leading.equalTo(recordView.snp.leading).offset(11)
            make.bottom.equalTo(recordView.snp.bottom).offset(-13)
            make.trailing.equalTo(bodyDataEntryButton.snp.leading).offset(-10)
        }
        //바디정보 구분선 뷰
        separateView.snp.makeConstraints { make in
            make.top.equalTo(bodyInfoView.snp.top).offset(8)
            make.centerY.centerX.equalTo(bodyInfoView)
            make.width.equalTo(0.5)
        }
        //바디정보 입력 버튼
        bodyDataEntryButton.snp.makeConstraints { make in
            make.top.equalTo(workoutImageBaseView.snp.bottom).offset(16)
            make.trailing.equalTo(recordView.snp.trailing).offset(-11)
            make.bottom.equalTo(recordView.snp.bottom).offset(-13)
            make.width.equalTo(51)
        }
        //체중라벨
        weightLabel.snp.makeConstraints { make in
            make.centerY.equalTo(bodyInfoView)
            make.leading.equalTo(bodyInfoView.snp.leading).offset(10)
            make.height.equalTo(26)
            make.width.equalTo(38)
        }
        //체중입력 정보라벨
        weightInputLabel.snp.makeConstraints { make in
            make.centerY.equalTo(bodyInfoView)
            make.trailing.equalTo(separateView.snp.leading).offset(-8)
        }
        
        
        
        recordLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(30)
            make.height.equalTo(26)
        }
        recordView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(18)
            make.top.equalTo(recordLabel.snp.bottom).offset(8)
            make.height.equalTo(445)
        }
        workoutImageBaseView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.equalTo(recordView.snp.leading).offset(12)
            make.top.equalTo(recordView.snp.top).offset(13)
            make.height.equalTo(318)
        }
        workoutNotDoneInfoLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(44)
            make.top.equalTo(workoutImageBaseView.snp.top).offset(58)
        }
        clickImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(workoutNotDoneInfoLabel.snp.bottom).offset(31)
            make.height.width.equalTo(41)
        }
        clickAlertLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(26)
            make.top.equalTo(clickImage.snp.bottom).offset(7)
        }
        bodyImageView.snp.makeConstraints { make in
            make.top.equalTo(workoutImageBaseView.snp.top).offset(0)
            make.leading.equalTo(workoutImageBaseView.snp.leading).offset(0)
            make.trailing.equalTo(workoutImageBaseView.snp.trailing).offset(0)
            make.bottom.equalTo(workoutImageBaseView.snp.bottom).offset(0)
        }
        workoutDoneCameraButton.snp.makeConstraints { make in
            make.top.equalTo(bodyImageView.snp.top).offset(0)
            make.leading.equalTo(bodyImageView.snp.leading).offset(0)
            make.trailing.equalTo(bodyImageView.snp.trailing).offset(0)
            make.bottom.equalTo(bodyImageView.snp.bottom).offset(0)
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
////text 행간 조절
//let paragraghStyle = NSMutableParagraphStyle()
//paragraghStyle.lineHeightMultiple = 1.2
//let infoLabelAttrString = NSMutableAttributedString(string: infoLabel.text ?? "")
//infoLabelAttrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraghStyle, range: NSMakeRange(0, infoLabelAttrString.length))
//infoLabel.attributedText = infoLabelAttrString
//}
