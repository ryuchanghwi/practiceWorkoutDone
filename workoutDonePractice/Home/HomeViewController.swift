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
    var selectedDateValue: String = ""

    


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
        // Review: selected 상태의 이미지 지정 가능
        // 네이밍 on/off는 switch에 주로 사용, arrowUp. arrowDown 등이 나을듯
//        $0.setImage(UIImage(named: "calendarScrollButtonOn"), for: .selected)
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
        
        

        
//        let bodyinfoText = BodyInfoText()
//        bodyinfoText.createdDate = viewModel.dateFormatter.string(from: Date())
//        bodyinfoText.weight = 55
//        bodyinfoText.fatPercentage = 30
//        bodyinfoText.skelatalMusleMass = 40
//
//        createdBodyInfoText(bodyInfoText: bodyinfoText)
        bind()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectedDateValue = viewModel.dateFormatter.string(from: Date())
        navigationController?.navigationBar.topItem?.title = "뒤로가기"
        navigationController?.navigationBar.tintColor = UIColor.red
        navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: - RXPractice
    ///질문
    private func bind() {
        viewModel.readBodyData
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { value in
                if let weight = value?.first?.weight {
                    self.recordBaseView.weightInputLabel.text = String(weight)
                } else { self.recordBaseView.weightInputLabel.text = "" }
                if let skeletalMusle = value?.first?.skelatalMusleMass {
                    self.recordBaseView.skeletalMuscleMassInputLabel.text = String(skeletalMusle)
                } else { self.recordBaseView.skeletalMuscleMassInputLabel.text = "" }
                if let fatPercentage = value?.first?.fatPercentage {
                    self.recordBaseView.fatPercentageInputLabel.text = String(fatPercentage)
                } else { self.recordBaseView.fatPercentageInputLabel.text = "" }
            })
            .disposed(by: disposeBag)

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
        let enterBodyInformationViewController = EnterBodyInformationViewController(selectedDate: selectedDateValue)
        enterBodyInformationViewController.modalTransitionStyle = .crossDissolve
        enterBodyInformationViewController.modalPresentationStyle = .overFullScreen
        present(enterBodyInformationViewController, animated: true)
    }
    @objc func ImageButtonTapped() {
        let imageSelectionViewController = ImageSelectionViewController()
        imageSelectionViewController.rootView = self
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


    // LLDB BreakPoint로 확인 가능
    // 예상 비즈니스 로직
    // selectedData -> realm 관련 데이터 꺼냄 -> 기록하기에 반영 (있으면-보여주고 없으면-입력가이드)
    
    
    // viewModel 활용
    // VC에서 들고있는 selectedData (Subject 타입) -> ViewModel아 이 날짜 선택했어 (VM이 subscribe로 관찰중)
    // -> ViewModel이 realm에 접근해서 데이터 찾음 -> VC의 기록하기에 반영
    
    ///질문-
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
//        let driverSelectedDate = Driver.just(viewModel.dateFormatter.string(from: date))
//        let input = HomeViewModel.Input(
//            selectedDate: driverSelectedDate)
        selectedDateValue = viewModel.dateFormatter.string(from: date)
        HomeViewModel().dateSubject.onNext(selectedDateValue)
        print(selectedDateValue, "dd")
        print(viewModel.bodyInfoText, "SSSS")
        print(viewModel.readBodyData, "dddd")


    }
    
    
//    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
//        print(selectedDateValue)
//        if selectedDateValue.contains(viewModel.dateFormatter.string(from: date)) {
//            print(selectedDateValue)
//            return UIImage(named: "calendarFrame")
//        }
//
//        if ["2022.12.12"].contains(viewModel.dateFormatter.string(from: date)) {
//            return UIImage(named: "calendarFrame")
//        }
////        calendarView.reloadData()
//        return nil
//        
//
//
//    }

        
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
        HomeViewController().toPreview().previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
    }
}


