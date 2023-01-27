//
//  EnterBodyInformationViewController.swift
//  workoutDonePractice
//
//  Created by 류창휘 on 2022/12/16.
//

import UIKit
import Then
import SnapKit
import SwiftUI
import RxKeyboard
import RxSwift
import RxCocoa

class EnterBodyInformationViewController : UIViewController {
    let disposeBag = DisposeBag()
    var viewModel = EnterBodyInformationViewModel()
    var selectedDate: String
    init(selectedDate: String) {
        self.selectedDate = selectedDate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - PROPERTIES
    let baseView = UIView().then {
        $0.backgroundColor = UIColor(hex: 0xFFFFFF)
        $0.layer.cornerRadius = 15
    }
    let cancelButton = UIButton().then {
        $0.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
    }
    
    let saveButton = UIButton().then {
        $0.setTitle("저장하기", for: .normal)
        $0.backgroundColor = UIColor(hex: 0x7442FF)
    }
    
    let myBodyInformationLabel = UILabel().then {
        $0.text = "나의 신체 정보"
    }
    
    let weightLabel = UILabel().then {
        $0.text = "체중"
        $0.textAlignment = .right
    }
    
    let weightTextField = UITextField().then {
        $0.backgroundColor = .gray
    }
    
    let weightKGLabel = UILabel().then {
        $0.text = "KG"
        $0.textAlignment = .left
    }
    
    let skeletalMuscleMassLabel = UILabel().then {
        $0.text = "골격근량"
        $0.textAlignment = .right
    }
    
    let skeletalMuscleMassTextField = UITextField().then {
        $0.backgroundColor = .gray
    }
    
    let skeletalMuscleMassKGLabel = UILabel().then {
        $0.text = "KG"
        $0.textAlignment = .left
    }
    
    let fatPercentageLabel = UILabel().then {
        $0.text = "체지방률"
        $0.textAlignment = .right
    }
    
    let fatPercentageTextField = UITextField().then {
        $0.backgroundColor = .gray
    }
    
    let fatPercentage = UILabel().then {
        $0.text = "%"
        $0.textAlignment = .left
    }
    
    //stackView
    let weightStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = 47
    }
    
    let skeletalMuscleMassStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = 47
    }
    
    let fatPercentageStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = 47
    }
    
    let weightEntireStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = 13
    }
    
    let skeletalMuscleMassEntireStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = 13
    }
    
    let fatPercentageEntireStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = 13
    }
    
    // MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubview()
        

        print(selectedDate, "선택된 날짜")
        layout()
        actions()
        keyboardSetting()
        bind()
    }
    func keyboardSetting() {
        let offsetValue = UIScreen.main.bounds.height / 2 - 346 / 2
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { keyboardHeight in
                let height = keyboardHeight > 0 ? -keyboardHeight + offsetValue : 0
                self.baseView.snp.updateConstraints { make in
                    make.centerY.equalToSuperview().offset(height)
                }
                self.view.layoutIfNeeded()
            })
            .disposed(by: disposeBag)
    }
    

    func actions() {
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    @objc func cancelButtonTapped() {
        dismiss(animated: true)
    }
    @objc func saveButtonTapped() {
//        dismiss(animated: true)
    }
    
    ///질문
    private func bind() {
        let driverSelectedDate = Driver.just(selectedDate)
        let input = EnterBodyInformationViewModel.Input(
            selectedDate: driverSelectedDate,
            weightValue: weightTextField.rx.text.orEmpty.asDriver(),
            skeletalMusleMassValue: skeletalMuscleMassTextField.rx.text.orEmpty.asDriver(),
            fatPercentageValue: fatPercentageTextField.rx.text.orEmpty.asDriver(),
            saveTrigger: saveButton.rx.tap.asDriver())
        let output = viewModel.transform(input: input)
        
        output.saveState
            .drive(onNext: { [weak self] value in
                if value {
                    self?.saveButton.isEnabled = true
                    self?.saveButton.alpha = 1
                }
                else {
                    self?.saveButton.isEnabled = false
                    self?.saveButton.alpha = 0.7
                }
            })
            .disposed(by: disposeBag)
        output.save.drive()
            .disposed(by: disposeBag)
        
        output.read.drive(onNext: { [weak self] value in
            if let weight = value?.first?.weight {
                self?.weightTextField.text = String(weight)
            } else { self?.weightTextField.text = "" }
            if let skeletalMusle = value?.first?.skelatalMusleMass {
                self?.skeletalMuscleMassTextField.text = String(skeletalMusle)
            } else { self?.skeletalMuscleMassTextField.text = "" }
            if let fatPercentage = value?.first?.fatPercentage {
                self?.fatPercentageTextField.text = String(fatPercentage)
            } else { self?.fatPercentageTextField.text = "" }
        })
            .disposed(by: disposeBag)
        
        //        viewModel.readBodyInfoText(date: selectedDate)
        //        if let weight = (viewModel.bodyInfoText?.first?.weight) {
        //            weightTextField.text = String(weight)
        //        } else { weightTextField.text = "" }
        //        if let skeletalMusle = (viewModel.bodyInfoText?.first?.skelatalMusleMass) {
        //            skeletalMuscleMassTextField.text = String(skeletalMusle)
        //        } else { skeletalMuscleMassTextField.text = "" }
        //        if let fatPercentage = (viewModel.bodyInfoText?.first?.fatPercentage) {
        //            fatPercentageTextField.text = String(fatPercentage)
        //        } else { fatPercentageTextField.text = "" }
    }
    
    // MARK: - ACTIONS
}
// MARK: - EXTENSIONs
extension EnterBodyInformationViewController {
    func addSubview() {
        weightTextField.keyboardType = .numberPad
        skeletalMuscleMassTextField.keyboardType = .numberPad
        fatPercentageTextField.keyboardType = .numberPad
        self.view.backgroundColor = UIColor(hex: 0x000000, alpha: 0.15)
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let visualEffetView = UIVisualEffectView(effect: blurEffect)
        visualEffetView.frame = view.frame
        view.addSubview(visualEffetView)
        
        view.addSubview(baseView)
        view.addSubview(saveButton)
        view.addSubview(myBodyInformationLabel)
        view.addSubview(weightEntireStackView)
        view.addSubview(skeletalMuscleMassEntireStackView)
        view.addSubview(fatPercentageEntireStackView)
        view.addSubview(cancelButton)
        view.addSubview(cancelButton)
    }
    
    func layout() {
        
        [weightLabel, weightTextField].forEach({
            weightStackView.addArrangedSubview($0)
        })
        [weightStackView, weightKGLabel].forEach({
            weightEntireStackView.addArrangedSubview($0)
        })
        [skeletalMuscleMassLabel, skeletalMuscleMassTextField].forEach({
            skeletalMuscleMassStackView.addArrangedSubview($0)
        })
        [skeletalMuscleMassStackView, skeletalMuscleMassKGLabel].forEach({
            skeletalMuscleMassEntireStackView.addArrangedSubview($0)
        })
        [fatPercentageLabel, fatPercentageTextField].forEach({
            fatPercentageStackView.addArrangedSubview($0)
        })
        [fatPercentageStackView, fatPercentage].forEach {
            fatPercentageEntireStackView.addArrangedSubview($0)
        }
        
        
        baseView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.height.equalTo(346)
        }
        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(baseView.snp.top).offset(11)
            make.trailing.equalTo(baseView.snp.trailing).offset(-12)
        }
        weightLabel.snp.makeConstraints { make in
            make.width.equalTo(63)
        }
        weightTextField.snp.makeConstraints { make in
            make.width.equalTo(101)
            make.height.equalTo(35)
        }
        weightKGLabel.snp.makeConstraints { make in
            make.width.equalTo(24)
        }
        weightEntireStackView.snp.makeConstraints { make in
            make.centerX.equalTo(baseView)
            make.top.equalTo(myBodyInformationLabel.snp.bottom).offset(36)
        }
        
        skeletalMuscleMassLabel.snp.makeConstraints { make in
            make.width.equalTo(63)
        }
        skeletalMuscleMassTextField.snp.makeConstraints { make in
            make.width.equalTo(101)
            make.height.equalTo(35)
        }
        skeletalMuscleMassEntireStackView.snp.makeConstraints { make in
            make.centerX.equalTo(baseView)
            make.top.equalTo(weightEntireStackView.snp.bottom).offset(22)
        }
        
        fatPercentageLabel.snp.makeConstraints { make in
            make.width.equalTo(63)
        }
        fatPercentageTextField.snp.makeConstraints { make in
            make.width.equalTo(101)
            make.height.equalTo(35)
        }
        fatPercentage.snp.makeConstraints { make in
            make.width.equalTo(24)
        }
        fatPercentageEntireStackView.snp.makeConstraints { make in
            make.centerX.equalTo(baseView)
            make.top.equalTo(skeletalMuscleMassEntireStackView.snp.bottom).offset(22)
        }
        
    
        
        saveButton.snp.makeConstraints { make in
            make.height.equalTo(51)
            make.centerX.equalTo(baseView)
            make.leading.equalTo(baseView.snp.leading).offset(16)
            make.bottom.equalTo(baseView.snp.bottom).offset(-16)
        }
        
        myBodyInformationLabel.snp.makeConstraints { make in
            make.centerX.equalTo(baseView)
            make.top.equalTo(baseView.snp.top).offset(31)
            make.height.equalTo(24)
        }
    }
}


