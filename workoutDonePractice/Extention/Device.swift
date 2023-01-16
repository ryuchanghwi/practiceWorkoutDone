//
//  Device.swift
//  workoutDonePractice
//
//  Created by 류창휘 on 2022/12/17.
//

import DeviceKit

public enum DeviceGrounp {
    case homeButtonDevice
    case simulatorHomeButtonDevice
    public var rawValue : [Device] {
        switch self {
        case .homeButtonDevice:
            return [.iPhone8, .iPhone8Plus, .iPhoneSE2, .iPhoneSE3]
        case .simulatorHomeButtonDevice:
            return [.simulator(.iPhoneSE3), .simulator(.iPhoneSE2), .simulator(.iPhone8), .simulator(.iPhone8Plus)]
        }
    }
}

class DeviceManager {
    static let shared : DeviceManager = DeviceManager()
    func isHomeButtonDevice() -> Bool {
        return Device.current.isOneOf(DeviceGrounp.homeButtonDevice.rawValue)
    }
    func isSimulatorIsHomeButtonDevice() -> Bool {
        return Device.current.isOneOf(DeviceGrounp.simulatorHomeButtonDevice.rawValue)
    }
}
