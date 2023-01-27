//
//  ViewModelType.swift
//  workoutDonePractice
//
//  Created by 류창휘 on 2023/01/18.
//

import Foundation
protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
