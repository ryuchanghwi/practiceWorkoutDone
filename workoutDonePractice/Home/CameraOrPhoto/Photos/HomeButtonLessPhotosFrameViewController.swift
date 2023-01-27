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
    enum ImageTypeButtons : Int {
        case defaultImage = 1
        case firstManUpperBodyImage = 2
        case secondManUpperBodyImage = 3
        case manWholeBodyImage = 4
        case womanUpperBodyImage = 5
        case womanWholeBodyImage = 6
    }
    
    var viewModel : PhotosViewModel? = nil
    let disposeBag = DisposeBag()
    // MARK: - PROPERTIES
    private let imageTypeBackView = UIView().then {
        $0.backgroundColor = .blue
    }
    private let imageTypeTestView = UIView().then {
        $0.backgroundColor = .green
    }
    
    private let imageView = UIImageView().then {
        $0.backgroundColor = .red
    }
    private let saveButton = UIButton().then {
        $0.setTitle("저장하기", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        $0.backgroundColor = UIColor(hex: 0x7442FF, alpha: 1)
    }
    
    //이미지 타입 스크롤
    private let imageTypeScrollView = UIScrollView().then {
        $0.backgroundColor = .white
//        $0.showsHorizontalScrollIndicator = fals
    }
    private let imageTypeScrollContentView = UIView()
    private let ImageTypeStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = 10
    }
    // MARK: - 사진 타입 버튼
    private let defaultImageTypeButton = UIButton().then {
        $0.backgroundColor = .red
        $0.layer.cornerRadius = 10
    }
    private let firstManUpperBodyImageTypeButton = UIButton().then {
        $0.backgroundColor = .blue
        $0.layer.cornerRadius = 10
    }
    private let secondManUpperBodyImageTypeButton = UIButton().then {
        $0.backgroundColor = .blue
        $0.layer.cornerRadius = 10
    }
    private let manWholeBodyImageTypeButton = UIButton().then {
        $0.backgroundColor = .gray
        $0.layer.cornerRadius = 10
    }
    private let womanUpperBodyImageTypeButton = UIButton().then {
        $0.backgroundColor = .black
        $0.layer.cornerRadius = 10
    }
    private let womanWholeBodyTypeButton = UIButton().then {
        $0.backgroundColor = .systemPink
        $0.layer.cornerRadius = 10
    }
    
    private var TypeButtons = [UIButton]()
    // MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()

        imageTypeScrollView.showsHorizontalScrollIndicator = false
        
        defaultImageTypeButton.tag = ImageTypeButtons.defaultImage.rawValue
        firstManUpperBodyImageTypeButton.tag = ImageTypeButtons.firstManUpperBodyImage.rawValue
        secondManUpperBodyImageTypeButton.tag = ImageTypeButtons.secondManUpperBodyImage.rawValue
        manWholeBodyImageTypeButton.tag = ImageTypeButtons.manWholeBodyImage.rawValue
        womanUpperBodyImageTypeButton.tag = ImageTypeButtons.womanUpperBodyImage.rawValue
        womanWholeBodyTypeButton.tag = ImageTypeButtons.womanWholeBodyImage.rawValue
        
        view.addSubview(imageView)
        view.addSubview(saveButton)
        view.addSubview(imageTypeBackView)
        view.backgroundColor = .systemBackground
        
        view.addSubview(imageTypeScrollView)
        imageTypeScrollView.addSubview(imageTypeScrollContentView)
        imageTypeScrollContentView.addSubview(ImageTypeStackView)
        
        [defaultImageTypeButton, firstManUpperBodyImageTypeButton, secondManUpperBodyImageTypeButton, manWholeBodyImageTypeButton, womanUpperBodyImageTypeButton, womanUpperBodyImageTypeButton].forEach({
            TypeButtons.append($0)
        })
        
        [defaultImageTypeButton, firstManUpperBodyImageTypeButton, secondManUpperBodyImageTypeButton, manWholeBodyImageTypeButton, womanUpperBodyImageTypeButton, womanWholeBodyTypeButton].forEach({
            ImageTypeStackView.addArrangedSubview($0)
        })
        
        
        viewModel?.selectedPhotoSubject
            .asDriver(onErrorJustReturn: UIImage())
            .drive(imageView.rx.image)
            .disposed(by: disposeBag)
        
        
        
        layouts()
        actions()
    }
    
    func layouts() {
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(0)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(self.view.frame.width * 4 / 3)
        }
        saveButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-13)
            make.height.equalTo(58)
        }
        
        //버튼 스크롤
        imageTypeBackView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(saveButton.snp.top)
        }
        imageTypeScrollView.snp.makeConstraints { make in
            make.centerY.equalTo(imageTypeBackView)
            make.height.equalTo(75)
            make.leading.equalTo(imageTypeBackView.snp.leading)
            make.trailing.equalTo(imageTypeBackView.snp.trailing)
        }
        imageTypeScrollContentView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalTo(imageTypeScrollView)
        }
        ImageTypeStackView.snp.makeConstraints { make in
            make.top.bottom.equalTo(imageTypeScrollContentView)
            make.leading.equalTo(imageTypeScrollView).offset(10)
            make.trailing.equalTo(imageTypeScrollView).offset(-10)
        }
        defaultImageTypeButton.snp.makeConstraints { make in
            make.height.width.equalTo(75)
        }
        firstManUpperBodyImageTypeButton.snp.makeConstraints { make in
            make.height.width.equalTo(75)
        }
        secondManUpperBodyImageTypeButton.snp.makeConstraints { make in
            make.height.width.equalTo(75)
        }
        manWholeBodyImageTypeButton.snp.makeConstraints { make in
            make.height.width.equalTo(75)
        }
        womanUpperBodyImageTypeButton.snp.makeConstraints { make in
            make.height.width.equalTo(75)
        }
        womanWholeBodyTypeButton.snp.makeConstraints { make in
            make.height.width.equalTo(75)
        }
    }
    // MARK: - ACTIONS
    func actions() {
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        [defaultImageTypeButton, firstManUpperBodyImageTypeButton, secondManUpperBodyImageTypeButton, manWholeBodyImageTypeButton, womanUpperBodyImageTypeButton, womanWholeBodyTypeButton].forEach({
            $0.addTarget(self, action: #selector(selectImageTypeButtonTapped(sender: )), for: .touchUpInside)
        })
        
    }
    
    @objc func saveButtonTapped() {
//        self.view.window?.rootViewController?.presentedViewController!.dismiss(animated: true, completion: nil)
        UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: false, completion: nil)
    }
    @objc func selectImageTypeButtonTapped(sender : UIButton) {
        for button in TypeButtons {
            if button == sender {
                button.layer.borderColor = UIColor.green.cgColor
                button.layer.borderWidth = 1
            }
            else {
                button.layer.borderColor = .none
                button.layer.borderWidth = 0
            }
        }
        switch sender.tag {
        case ImageTypeButtons.defaultImage.rawValue:
            print("디펄트")
        case ImageTypeButtons.firstManUpperBodyImage.rawValue:
            print("1번")
        case ImageTypeButtons.secondManUpperBodyImage.rawValue:
            print("2번")
        case ImageTypeButtons.manWholeBodyImage.rawValue:
            print("3번")
        case ImageTypeButtons.womanUpperBodyImage.rawValue:
            print("4번")
        case ImageTypeButtons.womanWholeBodyImage.rawValue:
            print("5번")
            
        default:
            print("??")
        }
    }

    
}
// MARK: - EXTENSIONs
extension HomeButtonLessPhotosFrameViewController {
    
}
