//
//  PhotosCollectionViewCell.swift
//  workoutDonePractice
//
//  Created by 류창휘 on 2022/12/25.
//

import UIKit
import SnapKit
import Then
class PhotosCollectionViewCell : UICollectionViewCell {

    let photosImageView = UIImageView()
    let selectedButton = UIImageView().then {
        $0.image = UIImage(named: "notSelectedButtonImage")
    }
    let selectedEffectView = UIView()
    override var isSelected: Bool {
        didSet {
            if isSelected {
                photosImageView.layer.borderWidth = 1
                photosImageView.layer.borderColor = UIColor.green.cgColor
                selectedButton.image = UIImage(named: "selectedButtonImage")
                selectedEffectView.backgroundColor = UIColor(hex: 0x000000, alpha: 0.2)
            }
            else {
                selectedButton.image = UIImage(named: "notSelectedButtonImage")
            }
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.backgroundColor = .red
        contentView.addSubview(photosImageView)
        contentView.addSubview(selectedEffectView)
        contentView.addSubview(selectedButton)
        photosImageView.layer.masksToBounds = true
        photosImageView.layer.cornerRadius = 5
        photosImageView.contentMode = .scaleToFill
        
        photosImageView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        selectedEffectView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        selectedButton.snp.makeConstraints { make in
            make.top.equalTo(photosImageView.snp.top).offset(7)
            make.trailing.equalTo(photosImageView.snp.trailing).offset(-7)
        }
        
    }
}
