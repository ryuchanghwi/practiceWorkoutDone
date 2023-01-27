//
//  UserDefaults.swift
//  workoutDonePractice
//
//  Created by 류창휘 on 2022/12/17.
//

import Foundation
/// todo : // 이와 유사한 형태로 RealmManager 타입도 만들기
class UserDefaultsManager {
    enum Key: String {
        case hasOnboarded
        case isMonthlyCalendar
    }
    static let shared = UserDefaultsManager()
    

    var hasOnboarded: Bool {
        return load(.hasOnboarded) as? Bool ?? false
    }
    var isMonthlyCalendar: Bool {
        return load(.isMonthlyCalendar) as? Bool ?? false
    }
    private init() {}
    
    ///UserDefaults 관리용
    func save( value: Any, forkey key: Key) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    func load(_ key: Key) -> Any? {
        switch key {
        case .hasOnboarded:
            return load(key)
        case .isMonthlyCalendar:
            return load(key)
        }
    }
    
    private func loadBool(_ key: Key) -> Bool? {
        return UserDefaults.standard.object(forKey: key.rawValue) as? Bool
    }
    func remove(_ key: Key) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
}
