//
//  EnterBodyInformationViewModel.swift
//  workoutDonePractice
//
//  Created by 류창휘 on 2023/01/25.
//

import Foundation
import RealmSwift
import RxCocoa
import RxSwift

class EnterBodyInformationViewModel: ViewModelType {
    let realm = try! Realm()
    var bodyInfoText: Results<BodyInfoText>?
    init(bodyInfoText: Results<BodyInfoText>? = nil) {
        self.bodyInfoText = realm.objects(BodyInfoText.self)
        print("HomeViewModel - init")
    }

    struct Input {
        let selectedDate: Driver<String>
        let weightValue: Driver<String>
        let skeletalMusleMassValue: Driver<String>
        let fatPercentageValue: Driver<String>
        let saveTrigger: Driver<Void>
    }
    struct Output {
        let saveState: Driver<Bool>
        let save: Driver<Void>
        let read: Driver<Results<BodyInfoText>?>
    }
    
    func createdBodyInfoText(bodyInfoText: BodyInfoText) {
        do {
            try realm.write {
                realm.add(bodyInfoText)
            }
        } catch {
            print("Error saving categoryt \(error)")
        }
    }
    func readBodyInfoText(date: String) {
        bodyInfoText = bodyInfoText?.filter("createdDate CONTAINS %@", date)
        print(bodyInfoText?.count, "몇개의 값이 있는가")
        print(bodyInfoText, "보여줄 테이터")
    }
    func updateBodyInfoText(date: String, weightValue: Int?, skeletalMucleMassValue: Int?, fatPercentageValue: Int?) {
        let bodyInfo = realm.objects(BodyInfoText.self).where {
            $0.createdDate == date
        }.first!
        do {
            try realm.write {
                bodyInfo.weight = weightValue
                bodyInfo.skelatalMusleMass = skeletalMucleMassValue
                bodyInfo.fatPercentage = fatPercentageValue
            }
        } catch {
            print("Error saving categoryt \(error)")
        }
    }

    func transform(input: Input) -> Output {
    
        //버튼 활성화
        let weightValueValidState = input.weightValue.map { value in
            print(value, "dd")
            return value.count > 0 ? true : false
        }
        let skeletalMusleMassValueValidState = input.skeletalMusleMassValue.map { value in
            value.count > 0 ? true : false
        }
        let fatPercentageValueValidState = input.fatPercentageValue.map { value in
            value.count > 0 ? true : false
        }
        let saveState = Driver.combineLatest(weightValueValidState, skeletalMusleMassValueValidState, fatPercentageValueValidState) { weightState, skeletalMusleState, fatPercentageState in
            return weightState || skeletalMusleState || fatPercentageState ? true : false
        }
        //데이터 저장
        let saveData = Driver<Void>.combineLatest(input.weightValue, input.fatPercentageValue, input.fatPercentageValue, input.selectedDate) { weightValue, skeletalMusleValue, fatPercentageValue, date in
            let bodyinfoText = BodyInfoText()
            bodyinfoText.createdDate = date
            bodyinfoText.weight = Int(weightValue)
            bodyinfoText.fatPercentage = Int(fatPercentageValue)
            bodyinfoText.skelatalMusleMass = Int(skeletalMusleValue)
//            self.createdBodyInfoText(bodyInfoText: bodyinfoText)
            ///질문: combineLatest를 사용할 경우, 값이 변경될 때마다 값이 저장되는 문제.
        }
        let save = input.saveTrigger.withLatestFrom(saveData)
        

        
        //데이터 불러오기
        let readData = Driver<Void>.combineLatest(input.weightValue, input.fatPercentageValue, input.fatPercentageValue, input.selectedDate) { weightValue, skeletalMusleValue, fatPercentageValue, date in
            //??
        }
        let read = input.selectedDate.map { value in
            let bodyInfo = self.bodyInfoText?.filter("createdDate CONTAINS %@", value)
            return bodyInfo
        }
        
        return Output(saveState: saveState, save: save, read: read)
    }
}
