//
//  HomeButtonLessPhotosFrameViewController.swift
//  workoutDonePractice
//
//  Created by 류창휘 on 2022/12/26.
//

import UIKit
import RxSwift
import SnapKit

class HomeButtonLessPhotosFrameViewController : UIViewController {
    var viewModel : PhotosViewModel? = nil
    let disposeBag = DisposeBag()
    // MARK: - PROPERTIES
    private let barView = UIView()
    
    private let backButton = UIButton()
    
    private let barTitleLabel = UILabel()
    
    private let imageView = UIImageView()
    
    private let separateView = UIView()
    
    private let saveButton = UIButton()
    
    // MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
//        viewModel?.selectedPhoto.subscribe(onNext: { photo in
//            self.imageView.image = photo
//        })
//        .disposed(by: disposeBag)
        
        
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    // MARK: - ACTIONS
}
// MARK: - EXTENSIONs
extension HomeButtonLessPhotosFrameViewController {
    
}
