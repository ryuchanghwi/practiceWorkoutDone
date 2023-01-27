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

protocol RealmService {
    func searchBodyData(date: String) -> Results<BodyInfoText>?
}
class RealmConnect: RealmService {
    func searchBodyData(date: String) -> Results<BodyInfoText>? {
        let realm = try! Realm()
        var bodyInfoText : Results<BodyInfoText>?
        bodyInfoText = realm.objects(BodyInfoText.self)
        bodyInfoText = bodyInfoText?.filter("createdDate CONTAINS %@", date)
        return bodyInfoText
    }
}



class HomeViewModel {
    let realm = try! Realm()
    var bodyInfoText : Results<BodyInfoText>?
    
    init(bodyInfoText: Results<BodyInfoText>? = nil) {
        self.bodyInfoText = realm.objects(BodyInfoText.self)
        print("HomeViewModel - init")
    }
    
    lazy var dateSubject = BehaviorSubject(value: dateFormatter.string(from: Date()))
    ///질문
    lazy var readBodyData = dateSubject.map { value in
        let bodyInfo = self.bodyInfoText?.filter("createdDate CONTAINS %@", value)
        return bodyInfo
    }
    
//    lazy var readData =
//    struct Input {
//        let selectedDate: Driver<String>
//    }
//
//    struct Output {
//        let read: Driver<Results<BodyInfoText>?>
//    }
//    func transform(input: Input) -> Output {
//        let read = input.selectedDate.map { value in
//            let bodyInfo = self.bodyInfoText?.filter("createdDate CONTAINS %@", value)
//            return bodyInfo
//        }
//        return Output(read: read)
//    }
//    let input: Input

    

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
    

    
    
    func loadBodyInfoTexts() {
        bodyInfoText = realm.objects(BodyInfoText.self)
        
    }
    

}

