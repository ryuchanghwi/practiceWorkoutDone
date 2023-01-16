//
//  OnboardingVIewModel.swift
//  workoutDonePractice
//
//  Created by 류창휘 on 2022/12/14.
//

import UIKit

struct OnbaordingSlide {
    let image : UIImage
    let description : String
}

struct OnboardingViewModel {
    var slides : [OnbaordingSlide] = [
        OnbaordingSlide(image: UIImage(named: "on3")!, description: "1번"),
        OnbaordingSlide(image: UIImage(named: "on2")!, description: "2번"),
        OnbaordingSlide(image: UIImage(named: "3")!, description: "3번")
    ]
    
}
