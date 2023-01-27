//
//  OnboardingViewController.swift
//  workoutDonePractice
//
//  Created by 류창휘 on 2022/12/14.
//

import UIKit
import SwiftUI
import SnapKit
import Then
class OnboardingViewController : UIViewController {
    var onboardingViewModel = OnboardingViewModel()
    // MARK: - PROPERTIES
    let nextButton = UIButton().then {
        $0.setTitle("다음으로", for: .normal)
        $0.backgroundColor = .purple
        $0.layer.cornerRadius = 12
    }
    let pageControl = UIPageControl().then {
        $0.numberOfPages = 3
        $0.currentPage = 0
        $0.pageIndicatorTintColor = .black
        $0.currentPageIndicatorTintColor = .white
    }
    let onboardingLabel = UILabel()
    var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
            if currentPage == onboardingViewModel.slides.count - 1 {
                nextButton.setTitle("시작하기", for: .normal)
            } else {
                nextButton.setTitle("다음으로", for: .normal)
            }
        }
    }
    let onboardingCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        layout.sectionInset =  UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
             
             return cv
    }()
    
    // MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(nextButton)
        view.addSubview(onboardingCollectionView)
        view.addSubview(pageControl)
        onboardingCollectionView.backgroundColor = .systemBackground
        onboardingCollectionView.delegate = self
        onboardingCollectionView.dataSource = self
        onboardingCollectionView.isPagingEnabled = true
        onboardingCollectionView.showsHorizontalScrollIndicator = false
        onboardingCollectionView.register(OnboardingCollectionViewCell.self, forCellWithReuseIdentifier: "OnboardingCollectionViewCell")
        setupLayout()
        actions()
    }
    
    func setupLayout() {
        nextButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(65)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-30)
        }
        onboardingCollectionView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(0)
            make.trailing.equalToSuperview().offset(0)
//            make.bottom.equalTo(pageControl.snp.top).offset(-20)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(0)
            make.height.equalTo(view.frame.width * 554 / 390)
        }
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(onboardingCollectionView.snp.bottom).offset(20)
            make.bottom.equalTo(nextButton.snp.top).offset(-40)
        }
    }
    
    // MARK: - ACTIONS
    func actions() {
        nextButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    }
    @objc func startButtonTapped() {
        if currentPage == onboardingViewModel.slides.count - 1 {
            print("메인 뷰로 가기")
            let mainViewController = UINavigationController(rootViewController: TabBarController())
            changeRootViewController(mainViewController)
//            UserDefaults.standard.hasOnboarded = true
        }
        else {
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            onboardingCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
}
// MARK: - EXTENSIONs
extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return onboardingViewModel.slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCollectionViewCell", for: indexPath) as! OnboardingCollectionViewCell
//        cell.onboardingImageView.image = onboardingViewModel.slides[indexPath.row].image
//        cell.onboardingLabel.text = onboardingViewModel.slides[indexPath.row].description
        cell.settup(onboardingViewModel.slides[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
//        print(onboardingViewModel.currentPage)
        
    }
    
    
}

struct OnboardingViewController_PreViews: PreviewProvider {
    static var previews: some View {
        OnboardingViewController().toPreview().previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)")) //원하는 VC를 여기다 입력하면 된다.
    }
}
