//
//  PHAsset.swift
//  workoutDonePractice
//
//  Created by 류창휘 on 2022/12/28.
//

import UIKit
import Photos
extension PHAsset {
  func getUIImage() -> UIImage {
    let manager = PHImageManager.default()
    let option = PHImageRequestOptions()
    var imageValue = UIImage()
    manager.requestImage(for: self,
                            targetSize: CGSize(width: self.pixelWidth, height: self.pixelHeight),
                            contentMode: .aspectFit,
                            options: option,
                            resultHandler: {(result, info) -> Void in
        imageValue = result!
    })
    return imageValue
  }
}
