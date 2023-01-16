//
//  HomeViewController.swift
//  workoutDonePractice
//
//  Created by 류창휘 on 2022/12/02.
//

import UIKit
import FSCalendar
import Then
import SnapKit
import SwiftUI
import RealmSwift
import RxCocoa
import RxSwift

class HomeViewController : UIViewController {
    let disposeBag = DisposeBag()
    var viewModel = HomeViewModel()
    var selectedDateValue : String = ""
    
    var weightValue : Int = 0
    var fatPercentageValue : Int = 0
    var skelatalMusleMassValue : Int = 0
    
    //realm
    let realm = try! Realm()
    var bodyInfoText : Results<BodyInfoText>?


    // MARK: - PROPERTIES
    private let contentScrollView = UIScrollView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .clear
    }
    private let contentView = UIView()
    //캘린더
    private let calendarBaseView = UIView()
    private let calendarView = FSCalendar()
    private let calendarScrollButton = UIButton().then {
        $0.setImage(UIImage(named: "calendarScrollButtonOff"), for: .normal)
    }
    private let monthControlStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = 17
    }
    private let monthControlBaseView = UIView().then {
        $0.backgroundColor = .clear
    }
    private let previousMonthButton = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.left"), for: .normal)
    }
    
    private let nextMonthButton = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.right"), for: .normal)
    }
    private let calendarDateLabel = UILabel().then {
        $0.text = "2022년 11월"
        $0.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        $0.textColor = UIColor(hex: 0xECE5FF, alpha: 1)
    }

    
    //기록하기
    private let recordBaseView = RecordView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
    }


    
    
    //운동하기
    private let workoutBaseView = WorkoutView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
    }

    
    //운동 결과
    private let workoutResultBaseView = WorkoutResultView().then {
        $0.backgroundColor = .white
    }

    let navigationBar = UINavigationBar()
    

    
    
    // MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        addSubView()
        layout()
        actions()
        navigationController?.isNavigationBarHidden = true
        contentScrollView.translatesAutoresizingMaskIntoConstraints = false
        contentScrollView.isUserInteractionEnabled = true
        contentScrollView.isScrollEnabled = true
        contentScrollView.isUserInteractionEnabled = true
        calendar()
        
        
        // MARK: - Realm
        loadBodyInfoTexts()

        
//        let bodyinfoText = BodyInfoText()
//        bodyinfoText.createdDate = viewModel.dateFormatter.string(from: Date())
//        bodyinfoText.weight = 55
//        bodyinfoText.fatPercentage = 30
//        bodyinfoText.skelatalMusleMass = 40
//
//        createdBodyInfoText(bodyInfoText: bodyinfoText)
        
    }
    
    // MARK: - rx
    func loadBodyInfoTexts() {
        bodyInfoText = realm.objects(BodyInfoText.self)
        // MARK: - 추가 질문
//        viewModel.loadBodyInfoTexts()
//
//        viewModel.weightValue
//            .bind(to: rx.weightValue)
//            .disposed(by: disposeBag)
//
//        viewModel.fatPercentageValue
//            .bind(to: rx.fatPercentageValue)
//            .disposed(by: disposeBag)
//        viewModel.skelatalMusleMassValue
//            .bind(to: rx.skelatalMusleMassValue)
//            .disposed(by: disposeBag)
//        recordBaseView.weightInputLabel.text = "\(weightValue) kg"
//        recordBaseView.skeletalMuscleMassInputLabel.text = "\(skelatalMusleMassValue) kg"
//        recordBaseView.fatPercentageInputLabel.text = "\(fatPercentageValue) %"
        
        
        print(bodyInfoText, "저장된 데이터들")
    }
    
    func createdBodyInfoText(bodyInfoText : BodyInfoText) {
        do {
            try realm.write {
                realm.add(bodyInfoText)
            }
        } catch {
            print("Error saving category \(error)")
        }
    }
    
    func updateBodyInfoText(bodyInfoText : BodyInfoText) {
        recordBaseView.weightInputLabel.text = "\(bodyInfoText.weight) KG"
        recordBaseView.skeletalMuscleMassInputLabel.text = "\(bodyInfoText.skelatalMusleMass) %"
        recordBaseView.fatPercentageInputLabel.text = "\(bodyInfoText.fatPercentage) kg"
    }
    

    // MARK: - ACTIONS
    func actions() {
        recordBaseView.workoutDoneCameraButton.addTarget(self, action: #selector(ImageButtonTapped), for: .touchUpInside)
        recordBaseView.bodyDataEntryButton.addTarget(self, action: #selector(bodyDataEntryButtonTapped), for: .touchUpInside)
        previousMonthButton.addTarget(self, action: #selector(previousMonthButtonTapped), for: .touchUpInside)
        nextMonthButton.addTarget(self, action: #selector(nextMonthButtonTapped), for: .touchUpInside)
        calendarScrollButton.addTarget(self, action: #selector(calendarScrollButtonTapped), for: .touchUpInside)
        
    }
    @objc func bodyDataEntryButtonTapped() {
        print("클릭")
        let enterBodyInformationViewController = EnterBodyInformationViewController()
        enterBodyInformationViewController.modalTransitionStyle = .crossDissolve
        enterBodyInformationViewController.modalPresentationStyle = .overFullScreen
        present(enterBodyInformationViewController, animated: true)
    }
    @objc func ImageButtonTapped() {
        print("클릭")
        let imageSelectionViewController = ImageSelectionViewController()
        imageSelectionViewController.modalTransitionStyle = .crossDissolve
        imageSelectionViewController.modalPresentationStyle = .overFullScreen
        present(imageSelectionViewController, animated: true)
    }
    @objc func previousMonthButtonTapped() {
        scrollCurrentPage(isPrev: true)
    }
    @objc func nextMonthButtonTapped() {
        scrollCurrentPage(isPrev: false)
    }
    @objc func calendarScrollButtonTapped() {

        if calendarView.scope == .month {
            calendarScrollButton.setImage(UIImage(named: "calendarScrollButtonOn"), for: .normal)
            calendarView.setScope(.week, animated: true)
        }
        else {
            calendarScrollButton.setImage(UIImage(named: "calendarScrollButtonOff"), for: .normal)
            calendarView.setScope(.month, animated: true)
        }
    }

}
// MARK: - EXTENSIONs
extension HomeViewController {
    func addSubView() {
        [contentScrollView].forEach { views in
            self.view.addSubview(views)
        }
        contentScrollView.addSubview(contentView)
        [calendarBaseView, recordBaseView, workoutBaseView, workoutResultBaseView].forEach { views in
            contentView.addSubview(views)
        }
        calendarBaseView.addSubview(calendarView)
        calendarBaseView.addSubview(calendarScrollButton)
        calendarBaseView.addSubview(monthControlBaseView)
        calendarBaseView.addSubview(monthControlStackView)
        [previousMonthButton, calendarDateLabel, nextMonthButton].forEach({
            monthControlStackView.addArrangedSubview($0)
        })
    }
    
    func layout() {
        contentScrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide) //스크롤뷰가 표현될 영역
        }
        
        contentView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.centerX.top.bottom.equalToSuperview()
        }
        
        //캘린더
        calendarBaseView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(calendarView.snp.bottom).offset(30)
        }
        calendarBaseView.backgroundColor = UIColor(hex: 0x7442FF)
        calendarBaseView.layer.cornerRadius = 15
        calendarBaseView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        monthControlBaseView.snp.makeConstraints { make in
            make.height.equalTo(35)
            make.top.equalTo(calendarBaseView.snp.top).offset(0)
            make.leading.trailing.equalToSuperview()
        }
        monthControlStackView.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(monthControlBaseView)
        }
        calendarView.snp.makeConstraints { make in
            make.top.equalTo(monthControlBaseView.snp.bottom).offset(0)
            make.leading.equalTo(calendarBaseView.snp.leading).offset(30)
            make.trailing.equalTo(calendarBaseView.snp.trailing).offset(-30)
            make.height.equalTo(220)
        }
        calendarScrollButton.snp.makeConstraints { make in
            make.bottom.equalTo(calendarBaseView.snp.bottom).offset(-11)
            make.centerX.equalTo(calendarBaseView)
        }
        
        //기록하기

        recordBaseView.snp.makeConstraints { make in
            make.top.equalTo(calendarBaseView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(513)
        }
        
        //운동하기
        workoutBaseView.snp.makeConstraints { make in
            make.top.equalTo(recordBaseView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(146)
        }

        
        
        //운동 결과
        workoutResultBaseView.snp.makeConstraints { make in
            make.top.equalTo(workoutBaseView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(182)
            make.bottom.equalToSuperview()
        }
        
        
        

        
    }
    
    enum HexColor {
        case backgroundColor
        case lightPurpleColor
        case mediumPurpleColor
        case purpleColor
        
        func getHexColor() -> UIColor {
            switch self {
            case .backgroundColor:
                return UIColor(hex: 0xFFFFF)
            case .mediumPurpleColor:
                return UIColor(hex: 0xE6E0FF)
            case .lightPurpleColor:
                return UIColor(hex: 0xF8F6FF)
            case .purpleColor:
                return UIColor(hex: 0x7442FF)
            }
        }
    }
}
extension HomeViewController : FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    func calendar() {
        calendarView.delegate = self
        calendarView.dataSource = self
        calendarView.headerHeight = 0 // 기본 년 월 없애기
        calendarView.placeholderType = .fillHeadTail
        calendarView.backgroundColor = .clear
        calendarView.appearance.weekdayFont = UIFont.systemFont(ofSize: 12, weight: .regular)
        calendarView.appearance.weekdayTextColor = UIColor(hex: 0xFFFFFF, alpha: 1)
        //해당 달이 아닌 일 숫자 색
        calendarView.appearance.titlePlaceholderColor = UIColor(hex: 0xF3F3F3, alpha: 0.3)
        calendarView.appearance.titleFont = UIFont.systemFont(ofSize: 14, weight: .regular)
        
//        calendarView.appearance.titleFont = {
//            if (calendarView.today != nil) {
//                return UIFont.systemFont(ofSize: 20, weight: .bold)
//            }
//            else {
//                return UIFont.systemFont(ofSize: 10, weight: .regular)
//            }
//        }()
//        private func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> UIFont? {
//            switch viewModel.dateFormatter.string(from: date) {
//            case viewModel.dateFormatter.string(from: Date()):
//                return UIFont.systemFont(ofSize: 20, weight: .bold)
//            default:
//                return nil
//            }
//        }
        
        calendarView.appearance.titleWeekendColor = UIColor(hex: 0xF3F3F3, alpha: 1)
        calendarView.appearance.titleDefaultColor = UIColor(hex: 0xF3F3F3, alpha: 1)
        calendarView.scope = .month
        calendarView.calendarWeekdayView.weekdayLabels[0].text = "일"
        calendarView.calendarWeekdayView.weekdayLabels[1].text = "월"
        calendarView.calendarWeekdayView.weekdayLabels[2].text = "화"
        calendarView.calendarWeekdayView.weekdayLabels[3].text = "수"
        calendarView.calendarWeekdayView.weekdayLabels[4].text = "목"
        calendarView.calendarWeekdayView.weekdayLabels[5].text = "금"
        calendarView.calendarWeekdayView.weekdayLabels[6].text = "토"
        calendarDateLabel.text = viewModel.monthDateFormatter.string(from: calendarView.currentPage)
        calendarView.appearance.eventDefaultColor = UIColor(hex: 0xFFFFFF, alpha: 1)
        calendarView.appearance.eventSelectionColor = UIColor(hex: 0xFFFFFF, alpha: 1)
        calendarView.appearance.todayColor = .clear
        calendarView.appearance.selectionColor = UIColor(hex: 0xC8B4FF, alpha: 1)
        calendarView.appearance.eventOffset = CGPoint(x: 0, y: -5)
        calendarView.appearance.imageOffset = CGPoint(x: 0, y: -5)
        calendarView.appearance.borderRadius = 0.5
        
    }
    //전달 다음달 액션 함수
    func scrollCurrentPage(isPrev: Bool) {
        let calendarCurrent = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.month = isPrev ? -1 : 1
        viewModel.currentPage = calendarCurrent.date(byAdding: dateComponents, to: viewModel.currentPage ?? Date())
        self.calendarView.setCurrentPage(viewModel.currentPage!, animated: true)
    }
    // label에 년, 월 표시 함수
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        calendarDateLabel.text = viewModel.monthDateFormatter.string(from: calendarView.currentPage)
    }
    // 캘린더 작아질 때, 레이아웃 다시 잡는 메서드
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendarView.snp.updateConstraints { make in
            make.height.equalTo(bounds.height)
        }
        self.view.layoutIfNeeded()
    }
    //event 표시 dot 사이즈
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        cell.eventIndicator.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
    }
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        switch viewModel.dateFormatter.string(from: date) {
        case viewModel.dateFormatter.string(from: Date()):
            return 1
        default:
            return 0
        }
    }



    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDateValue = viewModel.dateFormatter.string(from: date)
        print(selectedDateValue)
        loadBodyInfoTexts() // test
        bodyInfoText = bodyInfoText?.filter("createdDate CONTAINS %@", selectedDateValue)
        print(bodyInfoText, "????이거는")

        if bodyInfoText?.count != 0{
            updateBodyInfoText(bodyInfoText: bodyInfoText?[0] ?? BodyInfoText())
            
            // MARK: - 추가질문
//            viewModel.updateBodyInfoText()
        }
        
    }
    
    
    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
        print(selectedDateValue)
        if selectedDateValue.contains(viewModel.dateFormatter.string(from: date)) {
            print(selectedDateValue)
            return UIImage(named: "calendarFrame")
        }

        if ["2022.12.12"].contains(viewModel.dateFormatter.string(from: date)) {
            return UIImage(named: "calendarFrame")
        }
//        calendarView.reloadData()
        return nil
        


    }

        
}

extension UIViewController {
    private struct Preview: UIViewControllerRepresentable {
            let viewController: UIViewController

            func makeUIViewController(context: Context) -> UIViewController {
                return viewController
            }

            func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
            }
        }

        func toPreview() -> some View {
            Preview(viewController: self)
        }
}
struct MyViewController_PreViews: PreviewProvider {
    static var previews: some View {
        HomeViewController().toPreview().previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)")) //원하는 VC를 여기다 입력하면 된다.
    }
}


