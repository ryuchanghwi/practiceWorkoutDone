//
//  Data.swift
//  workoutDonePractice
//
//  Created by 류창휘 on 2022/12/30.
//

import Foundation
import RealmSwift


//class Category : Object {
//    @objc dynamic var name : String = ""
//    let items = List<Item>()
//}
//
//class Item : Object {
//    @objc dynamic var title : String = ""
//    @objc dynamic var done : Bool = false
//    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
//}
//
//
////홈화면에 표시될 데이터
//class MainData : Object {
////    @objc dynamic var dateValue : String {
////        let dateFormatter = DateFormatter()
////        dateFormatter.dateFormat = "yyyy.MM.dd"
////        let date = Date()
////        return dateFormatter.string(from: date)
////    }
//    @objc dynamic var date : String = ""
//    @objc dynamic var bodyImage : BodyImage?
//    @objc dynamic var wegiht : Weight?
//    @objc dynamic var fatPercentage : FatPercentage?
//    @objc dynamic var skeletalMuscleMass : SkeletalMuscleMass?
//}
//
//
//class BodyImage : Object {
//    @objc dynamic var image : String = ""
//    @objc dynamic var imageCategory : String = ""
//    var imageCategoryValue : ImageCategory {
//        get {
//            return ImageCategory(rawValue: imageCategory)!
//        }
//        set {
//            imageCategory = newValue.rawValue
//        }
//    }
//    var parentMainData = LinkingObjects(fromType: MainData.self, property: "bodyImage")
//
//}
//enum ImageCategory : String {
//    case none = ""
//    case man = "남자"
//    case woman = "여자"
//}
//
class BodyInfoText: Object {
    @Persisted dynamic var createdDate: String = ""
    @Persisted dynamic var weight: Int?
    @Persisted dynamic var fatPercentage: Int?
    @Persisted dynamic var skelatalMusleMass: Int?
 
}
////몸무게
//class Weight : Object {
//    @objc dynamic var dateCreated : Date?
//    @objc dynamic var weightValue : Int = 0
//    var parentMainData = LinkingObjects(fromType: MainData.self, property: "wegiht")
//}
////fatPercentage
////체지방량
//class FatPercentage : Object {
//    @objc dynamic var dateCreated : Date?
//    @objc dynamic var fatPercentageValue : Int = 0
//    var parentMainData = LinkingObjects(fromType: MainData.self, property: "fatPercentage")
//}
////골격근량
//class SkeletalMuscleMass : Object {
//    @objc dynamic var dateCreated : Date?
//    @objc dynamic var skeletalMuscleMassValue : Int = 0
//    var parentMainData = LinkingObjects(fromType: MainData.self, property: "skeletalMuscleMass")
//}
//
//
//class CalendarScope : Object {
//    @objc dynamic var weekCScope : Bool = true
//}
//
//class Data: Object {
//    @objc dynamic var name : String = ""
//    @objc dynamic var age : Int = 0
//}
