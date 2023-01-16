//
//  PhotoViewController.swift
//  workoutDonePractice
//
//  Created by 류창휘 on 2022/12/25.
//

import Foundation
import UIKit
import Photos
import SwiftUI
import DeviceKit
import RxSwift
import RxCocoa
class PhotoViewController : UIViewController {
    let disposeBag = DisposeBag()
    var viewModel = PhotosViewModel()
    // MARK: - PROPERTIES
    private var images = [PHAsset]()
    var selectedUIImage : UIImage = UIImage()
    
    private let photosCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = true
        
        return collectionView
    }()
    private let exView = UIView().then {
        $0.backgroundColor = .purple
    }
    private let barView = UIView().then {
        $0.backgroundColor = .blue
    }
    private let backButton = UIButton().then {
        $0.setTitle("뒤로 가기", for: .normal)
    }
    private let photosSelectButton = UIButton().then {
        $0.setTitle("선택 완료", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.setTitleColor(UIColor(hex: 0x7442FF), for: .normal)
        $0.backgroundColor = UIColor(hex: 0xE6E0FF)
    }
    
    //test
    private let testUIImageView = UIImageView().then {
        $0.backgroundColor = UIColor.red
    }
    
    // MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        view.addSubview(barView)
        view.addSubview(photosCollectionView)
        view.addSubview(exView)
        view.addSubview(backButton)
        view.addSubview(photosSelectButton)
        //collectionview
        photosCollectionView.backgroundColor = .red
        photosCollectionView.delegate = self
        photosCollectionView.dataSource = self
        photosCollectionView.showsVerticalScrollIndicator = true
        photosCollectionView.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: "PhotosCollectionViewCell")
        layouts()
        populatePhotos()
        actions()
        
    }
    private func layouts() {

        barView.snp.makeConstraints { make in
            make.height.equalTo(53)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(0)
            make.leading.trailing.equalToSuperview().offset(0)
        }
        photosCollectionView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.top.equalTo(barView.snp.bottom).offset(0)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        backButton.snp.makeConstraints { make in
            make.centerY.equalTo(barView)
            make.leading.equalTo(barView.snp.leading).offset(14)
        }
        photosSelectButton.snp.makeConstraints { make in
            make.centerY.equalTo(barView)
            make.trailing.equalTo(barView.snp.trailing).offset(-14)
        }

    }
    private func populatePhotos() {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
            switch status {
            case .notDetermined:
                // The user hasn't determined this app's access.
                print("notDetermined")
            case .restricted:
                // The system restricted this app's access.
                print("restricted")
            case .denied:
                // The user explicitly denied this app's access.
                print("denied")
            case .authorized:
                // The user authorized this app to access Photos data.
                let assests = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
                assests.enumerateObjects { (object, count, stop) in
                    self?.images.append(object)
                }
                self?.images.reverse()
                DispatchQueue.main.async {
                    self?.photosCollectionView.reloadData()
                }
                print("authorized")
            case .limited:
                // The user authorized this app for limited Photos access.
                print("limited")
            @unknown default:
                fatalError()
            }
        }
    }
    
    // MARK: - ACTIONS
    func actions() {
        photosSelectButton.addTarget(self, action: #selector(photoSelectButtonTapped), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(backbuttonTapped), for: .touchUpInside)
    }
    @objc func backbuttonTapped() {
        dismiss(animated: true)
    }
    @objc func photoSelectButtonTapped() {
        //todo
        let device = Device.current
        print(device)
        if DeviceManager.shared.isHomeButtonDevice() || DeviceManager.shared.isSimulatorIsHomeButtonDevice() {
            print("홈버튼이 있는 기종")
            let homeButtonPhotosFrameViewController = HomeButtonPhotosFrameViewController()
            homeButtonPhotosFrameViewController.viewModel = viewModel
            homeButtonPhotosFrameViewController.modalTransitionStyle = .crossDissolve
            homeButtonPhotosFrameViewController.modalPresentationStyle = .fullScreen
            present(homeButtonPhotosFrameViewController, animated: true)
        }
        else {
            print("홈 버튼이 없는 기종")
            let homeButtonLessPhotosFrameViewController = HomeButtonLessPhotosFrameViewController()
            homeButtonLessPhotosFrameViewController.viewModel = viewModel
            homeButtonLessPhotosFrameViewController.modalTransitionStyle = .coverVertical
            homeButtonLessPhotosFrameViewController.modalPresentationStyle = .fullScreen
            present(homeButtonLessPhotosFrameViewController, animated: true)
        }
    }
}
// MARK: - EXTENSIONs
extension PhotoViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotosCollectionViewCell", for: indexPath) as? PhotosCollectionViewCell else { fatalError("not found")}
        let assst = self.images[indexPath.row]
        let manager = PHImageManager.default()
        let frameSize = (collectionView.frame.width - 8) / 3
        manager.requestImage(for: assst, targetSize: CGSize(width: frameSize, height: frameSize), contentMode: .aspectFit, options: nil) { image, _ in
            DispatchQueue.main.async {
                cell.photosImageView.image = image  
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(images.count)
        return self.images.count
    }
    
    //옆 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    //위 아래 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frameSize = (collectionView.frame.width - 16) / 3
        let size = CGSize(width: frameSize, height: frameSize)
        return size
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedAsset = images[indexPath.row]
        selectedUIImage = selectedAsset.getUIImage()
        print(selectedUIImage, "DD")
        viewModel.selectedPhotoSubject.accept(selectedUIImage)
//        rx.selectedUIImage
//            .bind(to: viewModel.selectedPhotoSubject)
//            .disposed(by: disposeBag)
//        viewModel.selectedPhoto.asDriver()
//            .drive(rx.selectedUIImage)
//            .disposed(by: disposeBag)
//        rx.selectedUIImage
//        viewModel.selectedPhotoSubject.onNext(selectedUIImage)
//        viewModel.textSubject.onNext("으아아")
    }
}

struct PhotoViewController_PreViews: PreviewProvider {
    static var previews: some View {
        PhotoViewController().toPreview().previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)")) //원하는 VC를 여기다 입력하면 된다.
    }
}
