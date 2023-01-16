//
//  ImageSelectionViewController.swift
//  workoutDonePractice
//
//  Created by 류창휘 on 2022/12/09.
//

import UIKit
import SwiftUI
import SnapKit
import Then
import DeviceKit
class ImageSelectionViewController : UIViewController {
    // MARK: - PROPERTIES
    private let cancelButton = UIButton().then {
        $0.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
    }
    private let galleryButton = UIButton().then {
        $0.setTitle("갤러리에서 가져오기", for: .normal)
        $0.backgroundColor = UIColor(hex: 0x000000)
    }
    private let cameraButton = UIButton().then {
        $0.setTitle("사진 촬영하기", for: .normal)
        $0.backgroundColor = UIColor(hex: 0x000000)
    }
    
    
    // MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(hex: 0x000000, alpha: 0.15)
        //        self.view.layer.opacity = 0.15
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let visualEffetView = UIVisualEffectView(effect: blurEffect)
        visualEffetView.frame = view.frame
        view.addSubview(visualEffetView)
        view.addSubview(cancelButton)
        view.addSubview(galleryButton)
        view.addSubview(cameraButton)
        layout()
        actions()
    }
    
    func layout() {
        cancelButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-43)
            make.height.width.equalTo(42)
        }
        galleryButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalTo(cancelButton.snp.top).offset(-18)
            make.height.equalTo(70)
        }
        cameraButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalTo(galleryButton.snp.top).offset(-10)
            make.height.equalTo(70)
        }
    }
    
    // MARK: - ACTIONS
    private func actions() {
        cameraButton.addTarget(self, action: #selector(cameraButtonTapped), for: .touchUpInside)
        galleryButton.addTarget(self, action: #selector(galleryButtonTapped), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }
    @objc func cameraButtonTapped() {
        let device = Device.current
        print(device)
        if DeviceManager.shared.isHomeButtonDevice() || DeviceManager.shared.isSimulatorIsHomeButtonDevice() {
            print("홈버튼이 있는 기종")
            let homeButtonCameraViewController = HomeButtonCameraViewController()
            homeButtonCameraViewController.modalTransitionStyle = .coverVertical
            homeButtonCameraViewController.modalPresentationStyle = .fullScreen
            present(homeButtonCameraViewController, animated: true)
        }
        else {
            print("홈 버튼이 없는 기종")
            let homeButtonVC = HomeButtonLessCameraViewController()
            homeButtonVC.modalTransitionStyle = .coverVertical
            homeButtonVC.modalPresentationStyle = .fullScreen
            present(homeButtonVC, animated: true)
        }
    }
    //        let cameraViewController = CameraViewController()
    //        cameraViewController.modalTransitionStyle = .crossDissolve
    //        cameraViewController.modalPresentationStyle = .fullScreen
    //        present(cameraViewController, animated: true)
    @objc func galleryButtonTapped() {
        print("클릭")
        let photoViewController = PhotoViewController()
        photoViewController.modalTransitionStyle = .coverVertical
        photoViewController.modalPresentationStyle = .fullScreen
        present(photoViewController, animated: true)
    }
    @objc func cancelButtonTapped() {
        dismiss(animated: true)
    }
}
// MARK: - EXTENSIONs
extension ImageSelectionViewController {
    
}

struct ImageSelectionViewController_PreViews: PreviewProvider {
    static var previews: some View {
        ImageSelectionViewController().toPreview().previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)")) //원하는 VC를 여기다 입력하면 된다.
    }
}
