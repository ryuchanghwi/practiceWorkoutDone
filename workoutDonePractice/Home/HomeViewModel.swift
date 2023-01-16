//
//  HomeViewModel.swift
//  workoutDonePractice
//
//  Created by 류창휘 on 2022/12/30.
//

import UIKit
import RealmSwift
import RxSwift
import RxCocoa

class HomeViewModel {
    var currentPage : Date? //현재 달
    var selectedDate: Date = Date()
    var monthDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 M월"
        return dateFormatter
    }()
    var dateFormatter : DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy.MM.dd"
        return df
    }()
    
    let realm = try! Realm()
    var bodyInfoText : Results<BodyInfoText>?
    
    var weightValue = BehaviorRelay(value: 0)
    var fatPercentageValue = BehaviorRelay(value: 0)
    var skelatalMusleMassValue = BehaviorRelay(value: 0)
    
    func loadBodyInfoTexts() {
        bodyInfoText = realm.objects(BodyInfoText.self)
    }
    
    func updateBodyInfoText() {
        weightValue.accept(bodyInfoText?[0].weight ?? 0)
        fatPercentageValue.accept(bodyInfoText?[0].fatPercentage ?? 0)
        skelatalMusleMassValue.accept(bodyInfoText?[0].skelatalMusleMass ?? 0)
    }
    
    func createdBodyInfoText(bodyInfoText : BodyInfoText) {
        do {
            try realm.write {
                realm.add(bodyInfoText)
            }
        } catch {
            print("Error saving categoryt \(error)")
        }
    }
}

