////
////  skdfnkasnfd.swift
////  ACON-iOS
////
////  Created by Jaehyun Ahn on 1/17/25.
////
//
//import UIKit
//import SwiftUI
//
//import SnapKit
//import Then
//
//final class CustomAlertView: BaseViewController {
//    
//    private let alertContainer = UIView()
//    private let messageLabel = UILabel()
//    private let titleLabel = UILabel()
//    private let buttonStackView = UIStackView()
//    private let imageView = UIImageView()
//    
//    var onClose: (() -> Void)?
//    var onSettings: (() -> Void)?
//    var alertType: AlertType? // AlertType 저장
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    init(type: AlertType) {
//        super.init(nibName: nil, bundle: nil)
//        self.alertType = type
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        configureAlert()
//    }
//    
//    override func setStyle() {
//        super.setStyle()
//        
//        view.do {
//            $0.backgroundColor = UIColor.black.withAlphaComponent(0.6)
//        }
//        
//        alertContainer.do {
//            $0.backgroundColor = .gray8
//            $0.layer.cornerRadius = 8
//            $0.clipsToBounds = true
//        }
//        
//        imageView.do {
//            $0.contentMode = .scaleAspectFit
//            $0.isHidden = true
//            $0.image = .dotoriX
//        }
//        
//        titleLabel.do {
//            $0.setLabel(
//                text: "취향분석을 그만둘까요?",
//                style: ACFont.h8,
//                color: .acWhite,
//                alignment: .center,
//                numberOfLines: 2
//            )
//        }
//        
//        messageLabel.do {
//            $0.setLabel(
//                text: "위치를 확인할 수 없습니다.\n설정에서 위치접근 권한을 허용해주세요.",
//                style: ACFont.b2,
//                color: .gray3,
//                alignment: .center,
//                numberOfLines: 2
//            )
//        }
//        
//        buttonStackView.do {
//            $0.axis = .horizontal
//            $0.distribution = .fillEqually
//            $0.spacing = 12
//        }
//    }
//    
//    override func setHierarchy() {
//        super.setHierarchy()
//        
//        view.addSubview(alertContainer) // Alert 컨테이너 추가
//        alertContainer.addSubviews(imageView,messageLabel,titleLabel,buttonStackView)
//    }
//    
//    override func setLayout() {
//        super.setLayout()
//        
//        alertContainer.snp.makeConstraints {
//            $0.center.equalToSuperview()
//            $0.width.equalTo(ScreenUtils.width * 279 / 360)
//            $0.height.greaterThanOrEqualTo(ScreenUtils.width * 279 / 360 * 0.5)
//            $0.height.lessThanOrEqualTo(ScreenUtils.width * 279 / 360 )
//        }
//        
//        imageView.snp.makeConstraints {
//            $0.top.equalTo(alertContainer.snp.top).inset(ScreenUtils.width * 24 / 360)
//            $0.centerX.equalTo(alertContainer)
//            $0.width.height.height.equalTo(ScreenUtils.width * 80 / 360)
//        }
//        // MARK: h
//        buttonStackView.snp.makeConstraints {
//            $0.bottom.equalTo(alertContainer.snp.bottom).offset(-ScreenUtils.width * 24 / 360)
//            $0.horizontalEdges.equalTo(alertContainer.snp.horizontalEdges).inset(ScreenUtils.width * 24 / 360)
//
//            $0.centerX.equalTo(alertContainer)
//            
//        }
//        
//        messageLabel.snp.makeConstraints {
//            $0.horizontalEdges.equalTo(alertContainer).inset(ScreenUtils.width * 24 / 360)
//            $0.centerX.equalTo(alertContainer)
//            $0.bottom.equalTo(buttonStackView.snp.top).offset(-ScreenUtils.width * 16 / 360)
//            
//        }
//        
//        titleLabel.snp.makeConstraints {
//            $0.centerX.equalTo(alertContainer)
//            $0.horizontalEdges.equalTo(alertContainer).inset(ScreenUtils.width * 24 / 360)
//            $0.bottom.equalTo(messageLabel).offset(-ScreenUtils.width * 4 / 360)
//            $0.top.equalTo(imageView.snp.bottom).offset(1)
//        }
//        
//    }
//    
//    // MARK: - Actions
//    @objc private func closeTapped() {
//        dismiss(animated: true) {
//            self.onClose?()
//        }
//    }
//    // 설정 페이지 가는 거
//    @objc private func settingsTapped() {
//        if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
//            UIApplication.shared.open(url, options: [:], completionHandler: nil)
//        }
//    }
//    
//    private func configureAlert() {
//        guard let type = alertType else { return }
//        
//        titleLabel.text = type.title
//        messageLabel.text = type.content
//        
//        if type.hasImage {
//            imageView.isHidden = false
//            imageView.image = .dotoriX
//        }
//        
//        // 버튼 추가
//        buttonStackView.arrangedSubviews.forEach {
//            $0.removeFromSuperview() } // 이전 버튼 제거 -> 이제 스택뷰 삭제
//        
//        for (index, buttonTitle) in type.buttons.enumerated() {
//            let button = UIButton(type: .system)
//            button.setAttributedTitle(
//                text: buttonTitle,
//                style: ACFont.s2,
//                color: index == 0 ? .gray3 : .acWhite, // 첫 번째 버튼: 회색, 나머지: 흰색
//                for: .normal
//            )
//            button.layer.cornerRadius = 8
//            button.backgroundColor = index == 0 ? .clear : .gray5
//            button.layer.borderWidth = index == 0 ? 1 : 0
//            button.layer.borderColor = index == 0 ? UIColor.gray5.cgColor : nil
//            
//            button.tag = index
//            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
//            //버튼을 StackView에 추가하는 함수
//            buttonStackView.addArrangedSubview(button)
//        }
//    }
//    // MARK: - Actions
//    @objc private func buttonTapped(_ sender: UIButton) {
//        guard let type = alertType else { return }
//        
//        switch (type, sender.tag) {
//        case (.locationAccessDenied, 1): // 설정으로 이동
//            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
//                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
//            }
//        case (.locationAccessDenied, 0): // 닫기 동작
//            dismiss(animated: true, completion: onClose)
//            
//        case (.locationAccessFailImage, _): // 확인 버튼: 단순 닫기
//            dismiss(animated: true, completion: onClose)
//            
//        case (.stoppedPreferenceAnalysis, 0): // 그만두기
//            dismiss(animated: true, completion: onClose)
//        case (.stoppedPreferenceAnalysis, 1): // 계속하기
//            dismiss(animated: true, completion: onSettings)
//            
//        case (.uploadExit, 0), (.reviewExit, 0): // 그만두기
//            dismiss(animated: true, completion: onClose)
//        case (.uploadExit, 1), (.reviewExit, 1): // 계속하기
//            dismiss(animated: true, completion: onSettings)
//            
//        default:
//            dismiss(animated: true, completion: nil) // 기본 동작
//        }
//    }
//}
//
//import SwiftUI
//
//struct CustomAlertViewPreview: UIViewControllerRepresentable {
//    // AlertType을 변경할 수 있도록 변수로 설정
//    let type: AlertType
//    
//    func makeUIViewController(context: Context) -> CustomAlertView {
//        let alert = CustomAlertView(type: type)
//        alert.onClose = {
//            print("\(type.title) - 닫기 버튼 눌림")
//        }
//        alert.onSettings = {
//            print("\(type.title) - 설정으로 이동")
//        }
//        return alert
//    }
//    
//    func updateUIViewController(_ uiViewController: CustomAlertView, context: Context) {
//        // 필요시 업데이트 로직
//    }
//}
//
//struct CustomAlertViewPreviewContainer: View {
//    @State private var selectedType: AlertType = .stoppedPreferenceAnalysis
//    
//    var body: some View {
//        VStack {
//            // 각 AlertType을 테스트할 수 있는 버튼
//            ForEach(AlertType.allCases, id: \.self) { type in
//                Button(action: {
//                    selectedType = type
//                }) {
//                    Text(type.title)
//                        .padding()
//                        .frame(maxWidth: .infinity)
//                        .background(Color.blue)
//                        .foregroundColor(.white)
//                        .cornerRadius(8)
//                }
//                .padding(.horizontal)
//            }
//        }
//        .background(
//            CustomAlertViewPreview(type: selectedType)
//                .edgesIgnoringSafeArea(.all)
//        )
//    }
//}
//
//struct CustomAlertViewPreview_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomAlertViewPreviewContainer()
//            .preferredColorScheme(.dark) // 다크모드 환경
//            .previewDevice("iPhone 14 Pro")
//    }
//}
