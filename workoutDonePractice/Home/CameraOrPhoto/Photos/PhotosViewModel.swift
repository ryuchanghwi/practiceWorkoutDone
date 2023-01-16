//
//  PhotosViewModel.swift
//  workoutDonePractice
//
//  Created by 류창휘 on 2022/12/27.
//

import RxSwift
import RxCocoa
import UIKit

class PhotosViewModel {
    let selectedPhotoSubject : BehaviorRelay<UIImage> = BehaviorRelay(value: UIImage())
}
