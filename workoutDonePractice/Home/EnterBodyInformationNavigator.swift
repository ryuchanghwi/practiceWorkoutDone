//
//  EnterBodyInformationNavigator.swift
//  workoutDonePractice
//
//  Created by 류창휘 on 2023/01/27.
//

import Foundation
import UIKit

protocol EnterBodyInformationNavigator {
    func toHome()
}

final class DefaultEnterBodyInformationNavigator: EnterBodyInformationNavigator {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func toHome() {
        navigationController.dismiss(animated: true)
    }
    
    
}
//    func transform(input: Input) -> Output {
//
//        let weightValueValidState = input.weightValue.map { value in
//            print(value)
//            return value.count > 0 ? true : false
//        }
//        let skeletalMusleMassValueValidState = input.skeletalMusleMassValue.map { value in
//            return value.count > 0 ? true : false
//        }
//        let fatPercentageValueValidState = input.fatPercentageValue.map { value in
//            return value.count > 0 ? true : false
//        }
//        let saveState = Driver.combineLatest(weightValueValidState, skeletalMusleMassValueValidState, fatPercentageValueValidState) { weightState, skeletalMusleState, fatPercentageState in
//            return weightState || skeletalMusleState || fatPercentageState ? true : false
//        }
//
////        let saveData = input.buttonTap.combineLatest(input.weightValue, input.fatPercentageValue, input.fatPercentageValue) { weightValue, skeletalMusleValue, fatPercentageValue in
////            let bodyinfoText = BodyInfoText()
////            bodyinfoText.weight = Int(weightValue!)
////            bodyinfoText.fatPercentage = Int(fatPercentageValue!)
////            bodyinfoText.skelatalMusleMass = Int(skeletalMusleValue!)
////            self.createdBodyInfoText(bodyInfoText: bodyinfoText)
////        }
//        let bodyInformationData = Driver.combineLatest(input.weightValue, input.fatPercentageValue, input.fatPercentageValue) { weightValue, skeletalMusleValue, fatPercentageValue in
//            let bodyinfoText = BodyInfoText()
//            bodyinfoText.weight = Int(weightValue)
//            bodyinfoText.fatPercentage = Int(fatPercentageValue)
//            bodyinfoText.skelatalMusleMass = Int(skeletalMusleValue)
//            self.createdBodyInfoText(bodyInfoText: bodyinfoText)
//        }
//        let saveData = input.buttonTap.withLatestFrom(bodyInformationData)
//
//
//        let dismiss = Driver.merge(saveData, input.cancelTrigger)
//            .do(onNext: navigator.toHome)
//        return Output(saveState: saveState, dismiss: dismiss)
//    }



//    func bind() {
//        let driverSelectedDate = Driver.just(selectedDate)
//        let input = EnterBodyInformationViewModel.Input(
//            cancelTrigger: cancelButton.rx.tap.asDriver(),
//            selectedDate: driverSelectedDate,
//            buttonTap: saveButton.rx.tap.asDriver(),
//            weightValue: weightTextField.rx.text.orEmpty.asDriver(),
//            skeletalMusleMassValue: skeletalMuscleMassTextField.rx.text.orEmpty.asDriver(),
//            fatPercentageValue: fatPercentageTextField.rx.text.orEmpty.asDriver())
//        let output = viewModel?.transform(input: input)
//
//
//        output?.dismiss.drive()
//            .disposed(by: disposeBag)
//        output?.saveState.drive(saveButton.rx.isEnabled)
//            .disposed(by: disposeBag)
//
//    }
