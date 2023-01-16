//
//  OnboardingCollectionViewCell.swift
//  workoutDonePractice
//
//  Created by 류창휘 on 2022/12/14.
//

import UIKit
import SnapKit

class OnboardingCollectionViewCell : UICollectionViewCell {
    let onboardingImageView = UIImageView()
    
    let onboardingLabel = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.addSubview(onboardingImageView)
        contentView.addSubview(onboardingLabel)
        onboardingImageView.contentMode = .scaleAspectFit
        onboardingImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(0)
//            make.height.equalTo(contentView.frame.width * 390 / 486)
        }
        onboardingLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(onboardingImageView.snp.bottom).offset(46)
            make.bottom.equalToSuperview().offset(0)
        }
    }
    func settup(_ slide: OnbaordingSlide) {
        onboardingImageView.image = slide.image
        onboardingLabel.text = slide.description
    }
}
