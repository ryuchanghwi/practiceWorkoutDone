//
//  PhotoViewController.swift
//  workoutDonePractice
//
//  Created by 류창휘 on 2022/12/25.
//

import Foundation
import UIKit
import Photos
import PhotosUI
//https://github.com/Zedd0202/PHPicker/blob/master/PHPicker/ViewController.swift
import SwiftUI
import DeviceKit
import RxSwift
import RxCocoa
class PhotoViewController : UIViewController {
    var rootViewController: HomeViewController?
    
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
    //권한 Denied상태일 때, 보이는 뷰
    private let photoAuthorizationDeniedStateView = UIView().then {
        $0.backgroundColor = .purple
    }
    private let openSettingAlertLabel = UILabel().then {
        $0.text = "현재 권한이 거부된 상태입니다. \n 설정에서 권한을 허용해주세요."
    }
    private let openSettingButton = UIButton().then {
        $0.setTitle("설정하러 가기", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.setTitleColor(UIColor(hex: 0x744FF), for: .normal)
    }

    private let photosSelectButton = UIButton().then {
        $0.setTitle("선택 완료", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.setTitleColor(UIColor(hex: 0x7442FF), for: .normal)
        $0.backgroundColor = UIColor(hex: 0xE6E0FF)
        $0.layer.cornerRadius = 5
    }
    private let photoAuthorizationDeniedStateStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = 6
    }
    
    
    //test
    private let testUIImageView = UIImageView().then {
        $0.backgroundColor = UIColor.red
    }
    
    // MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green

        view.addSubview(photosCollectionView)
        view.addSubview(photoAuthorizationDeniedStateView)
        photoAuthorizationDeniedStateView.addSubview(photoAuthorizationDeniedStateStackView)
        [openSettingAlertLabel, openSettingButton].forEach({
            photoAuthorizationDeniedStateStackView.addArrangedSubview($0)
        })
        
        let barButton = UIBarButtonItem()
        barButton.customView = photosSelectButton
        navigationItem.rightBarButtonItem = barButton
        //collectionview
        photosCollectionView.backgroundColor = .red
        photosCollectionView.delegate = self
        photosCollectionView.dataSource = self
        photosCollectionView.showsVerticalScrollIndicator = true
        photosCollectionView.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: "PhotosCollectionViewCell")
        layouts()
        actions()
        populatePhotos()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    private func layouts() {
        photosCollectionView.isHidden = true
        photoAuthorizationDeniedStateView.isHidden = true


        photosCollectionView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(0)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        photosSelectButton.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.height.equalTo(30)
        }
        photoAuthorizationDeniedStateView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide).offset(0)
            make.leading.trailing.equalToSuperview()
        }
        photoAuthorizationDeniedStateStackView.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(view.safeAreaLayoutGuide)
        }

    }
    private func populatePhotos() {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
            switch status {
            case .notDetermined: //사용자가 아직 권한에 대한 설정을 하지 않았을 때
                print("notDetermined")
            case .restricted: //시스템에 의해 앨범에 접근 불가능하고, 권한 변경이 불가능한 상태
                print("restricted")
            case .denied: //접근이 거부된 경우
                print("denied")
                DispatchQueue.main.async {
                    self?.photosCollectionView.isHidden = true
                    self?.photoAuthorizationDeniedStateView.isHidden = false
                }
            case .authorized: //권한 허용된 상태
                let assests = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
                assests.enumerateObjects { (object, count, stop) in
                    self?.images.append(object)
                }
                self?.images.reverse()
                DispatchQueue.main.async {
                    self?.photosCollectionView.isHidden = false
                    self?.photoAuthorizationDeniedStateView.isHidden = true
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
        openSettingButton.addTarget(self, action: #selector(openSettingButtonTapped), for: .touchUpInside)
    }
    @objc func photoSelectButtonTapped() {
        //todo
        let device = Device.current
        print(device)
        if DeviceManager.shared.isHomeButtonDevice() || DeviceManager.shared.isSimulatorIsHomeButtonDevice() {
            print("홈버튼이 있는 기종")
            let homeButtonPhotosFrameViewController = HomeButtonPhotosFrameViewController()
            homeButtonPhotosFrameViewController.viewModel = viewModel
            navigationController?.pushViewController(homeButtonPhotosFrameViewController, animated: true)
        }
        else {
            print("홈 버튼이 없는 기종")
            let homeButtonLessPhotosFrameViewController = HomeButtonLessPhotosFrameViewController()
            homeButtonLessPhotosFrameViewController.viewModel = viewModel
            navigationController?.pushViewController(homeButtonLessPhotosFrameViewController, animated: true)
        }
    }
    @objc func openSettingButtonTapped() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
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
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        manager.requestImage(for: assst, targetSize: CGSize(width: frameSize, height: frameSize), contentMode: .aspectFit, options: options) { image, _ in
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
    }
}

struct PhotoViewController_PreViews: PreviewProvider {
    static var previews: some View {
        PhotoViewController().toPreview().previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)")) //원하는 VC를 여기다 입력하면 된다.
    }
}
