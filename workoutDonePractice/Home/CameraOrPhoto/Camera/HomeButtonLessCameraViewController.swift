//
//  CameraViewController.swift
//  workoutDonePractice
//
//  Created by 류창휘 on 2022/12/13.
//

import UIKit
import AVFoundation
import Photos
import SnapKit
import Then

class HomeButtonLessCameraViewController : UIViewController, AVCapturePhotoCaptureDelegate {
    // MARK: - PROPERTIES
    
    let captureSession = AVCaptureSession()
    var videoDeviceInput: AVCaptureDeviceInput!
    let photoOutput = AVCapturePhotoOutput()
    
    let sessionQueue = DispatchQueue(label: "session queue")
    let videoDeviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera, .builtInWideAngleCamera, .builtInTrueDepthCamera], mediaType: .video, position: .unspecified)
    
    private let preview = PreviewView()
    private let frameImageView = UIImageView()
    private let backButton = UIButton().then {
        $0.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
    }
    private let captureButtonBackView = UIView().then {
        $0.backgroundColor = .gray
    }
    
    private let captureButton = UIButton().then {
        $0.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
    }
    private let barView = UIView().then {
        $0.backgroundColor = .blue
    }
    
    //이미지 타입 backview
    private let imageTypeScrollBackView = UIView().then {
        $0.backgroundColor = .blue
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
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    // MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        print("홈버튼 없는 기종")
         // MARK: - camera
        preview.session = captureSession
        sessionQueue.async {
            self.setupSession()
            self.startSession()
        }
        
        view.backgroundColor = .systemBackground
        view.addSubview(preview)
        barView.addSubview(backButton)
        view.addSubview(captureButtonBackView)
        preview.addSubview(frameImageView)

        captureButtonBackView.addSubview(captureButton)
        view.addSubview(barView)
        view.addSubview(imageTypeScrollBackView)
        imageTypeScrollBackView.addSubview(imageTypeScrollView)
        imageTypeScrollView.addSubview(imageTypeScrollContentView)
        imageTypeScrollContentView.addSubview(ImageTypeStackView)

        captureButton.backgroundColor = .black
        preview.backgroundColor = .white
        
        actions()
        configureUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    // MARK: - ACTIONS
    func actions() {
        backButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        
        [defaultImageTypeButton, firstManUpperBodyImageTypeButton, secondManUpperBodyImageTypeButton, manWholeBodyImageTypeButton, womanUpperBodyImageTypeButton, womanWholeBodyTypeButton].forEach({
            $0.addTarget(self, action: #selector(selectImageTypeButtonTapped(sender: )), for: .touchUpInside)
        })
    }
    
    @objc func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc func selectImageTypeButtonTapped(sender: UIButton) {
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
            frameImageView.image = nil
        case ImageTypeButtons.firstManUpperBodyImage.rawValue:
            frameImageView.image = UIImage(named: "firstManUpperBodyImage")
        case ImageTypeButtons.secondManUpperBodyImage.rawValue:
            frameImageView.image = UIImage(named: "secondManUpperBodyImage")
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
extension HomeButtonLessCameraViewController {
    enum ImageTypeButtons : Int {
        case defaultImage = 1
        case firstManUpperBodyImage = 2
        case secondManUpperBodyImage = 3
        case manWholeBodyImage = 4
        case womanUpperBodyImage = 5
        case womanWholeBodyImage = 6
    }
    
    func configureUI() {
        
        barView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(0)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(58)
        }
        
        backButton.snp.makeConstraints { make in
            make.centerY.equalTo(barView)
            make.leading.equalTo(barView.snp.leading).offset(20)
        }
        barView.backgroundColor = .blue
        
        
        preview.snp.makeConstraints { make in
            make.top.equalTo(barView.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(self.view.frame.width * 4 / 3)
        }
        frameImageView.snp.makeConstraints { make in
            make.top.equalTo(preview.snp.top)
            make.leading.equalTo(preview.snp.leading)
            make.trailing.equalTo(preview.snp.trailing)
            make.bottom.equalTo(preview.snp.bottom)
        }
        captureButtonBackView.snp.makeConstraints { make in
            make.top.equalTo(imageTypeScrollBackView.snp.bottom)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        
        captureButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
//            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-17)
            make.centerY.equalTo(captureButtonBackView)
            make.height.width.equalTo(60)
        }
        
        
        //이미지 타입 스크롤
        imageTypeScrollView.showsHorizontalScrollIndicator = false
        defaultImageTypeButton.tag = ImageTypeButtons.defaultImage.rawValue
        firstManUpperBodyImageTypeButton.tag = ImageTypeButtons.firstManUpperBodyImage.rawValue
        secondManUpperBodyImageTypeButton.tag = ImageTypeButtons.secondManUpperBodyImage.rawValue
        manWholeBodyImageTypeButton.tag = ImageTypeButtons.manWholeBodyImage.rawValue
        womanUpperBodyImageTypeButton.tag = ImageTypeButtons.womanUpperBodyImage.rawValue
        womanWholeBodyTypeButton.tag = ImageTypeButtons.womanWholeBodyImage.rawValue

        [defaultImageTypeButton, firstManUpperBodyImageTypeButton, secondManUpperBodyImageTypeButton, manWholeBodyImageTypeButton, womanUpperBodyImageTypeButton, womanUpperBodyImageTypeButton].forEach({
            TypeButtons.append($0)
        })

        [defaultImageTypeButton, firstManUpperBodyImageTypeButton, secondManUpperBodyImageTypeButton, manWholeBodyImageTypeButton, womanUpperBodyImageTypeButton, womanWholeBodyTypeButton].forEach({
            ImageTypeStackView.addArrangedSubview($0)
        })

        imageTypeScrollBackView.snp.makeConstraints { make in
            make.top.equalTo(preview.snp.bottom)
//            make.bottom.equalTo(captureButton.snp.top)
            make.height.equalTo(102)
            make.leading.trailing.equalToSuperview()
        }
        imageTypeScrollView.snp.makeConstraints { make in
            make.centerY.equalTo(imageTypeScrollBackView)
            make.height.equalTo(75)
            make.leading.equalTo(imageTypeScrollBackView.snp.leading)
            make.trailing.equalTo(imageTypeScrollBackView.snp.trailing)
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
}


extension HomeButtonLessCameraViewController {
    // MARK: - Setup session and preview
    func setupSession() {
        // TODO: captureSession 구성하기
        // - presetSetting 하기
        // - beginConfiguration
        // - Add Video Input
        // - Add Photo Output
        // - commitConfiguration
        
        captureSession.sessionPreset = .photo
        captureSession.beginConfiguration()
        
        // Add Video Input
        do {
            var defaultVideoDevice: AVCaptureDevice?
            if let dualCameraDevice = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back) {
                defaultVideoDevice = dualCameraDevice
            } else if let backCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
                defaultVideoDevice = backCameraDevice
            } else if let frontCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) {
                defaultVideoDevice = frontCameraDevice
            }
            
            guard let camera = defaultVideoDevice else {
                captureSession.commitConfiguration()
                return
            }
            
            let videoDeviceInput = try AVCaptureDeviceInput(device: camera)
            
            if captureSession.canAddInput(videoDeviceInput) {
                captureSession.addInput(videoDeviceInput)
                self.videoDeviceInput = videoDeviceInput
            } else {
                captureSession.commitConfiguration()
                return
            }
        } catch {
            captureSession.commitConfiguration()
            return
        }
        
        
        // Add photo output
        photoOutput.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
        if captureSession.canAddOutput(photoOutput) {
            captureSession.addOutput(photoOutput)
        } else {
            captureSession.commitConfiguration()
            return
        }
        
        captureSession.commitConfiguration()
    }
    
    func startSession() {
        // TODO: session Start
        if !captureSession.isRunning {
            sessionQueue.async {
                self.captureSession.startRunning()
            }
        }
    }
    
    func stopSession() {
        // TODO: session Stop
        if captureSession.isRunning {
            sessionQueue.async {
                self.captureSession.stopRunning()
            }
        }
    }
//    func takePicture() {
//        DispatchQueue.global(qos: .background).async {
//            self.photoOutput.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
//            self.stopSession()
//            DispatchQueue.main.async {
//                
//            }
//        }
//    }
}
//
//extension HomeButtonCameraViewController: AVCapturePhotoCaptureDelegate {
//    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
//        // TODO: capturePhoto delegate method 구현
//        guard error == nil else { return }
//        guard let imageData = photo.fileDataRepresentation() else { return }
//        guard let image = UIImage(data: imageData) else { return }
//        CustomPhotoAlbum.sharedInstance.save(image: image, completion: {
//
//                                DispatchQueue.main.async(execute: {
//                                    //"Any UI update should be in main thread."
//                                    self.savePhotoLibrary(image: image)
//                                })
//                            })
//
//    }
//}
