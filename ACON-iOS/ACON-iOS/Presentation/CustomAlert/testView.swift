//import UIKit
//import SnapKit
//import Then
//import SwiftUI
//
//final class TestViewAlert: UIViewController {
//    private let button1 = UIButton()
//    private let button2 = UIButton()
//    private let button3 = UIButton()
//    private let button4 = UIButton()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .black
//        setupButtons()
//    }
//
//    // Custom Alert 표시
//    private func showCustomAlert(for type: AlertType) {
//        let alert = CustomAlertView(type: type)
//        alert.onClose = {
//            print("\(type) - 닫기 버튼 눌림")
//        }
//        alert.onSettings = {
//            print("\(type) - 설정으로 이동")
//        }
//        alert.modalPresentationStyle = .overFullScreen // 배경 투명 설정
//        alert.modalTransitionStyle = .crossDissolve   // 부드러운 전환 효과
//        present(alert, animated: true, completion: nil)
//    }
//
//    private func setupButtons() {
//        let buttons = [button1, button2, button3, button4]
//        let titles = [
//            "Access Denied (1 Button)",  // locationAccessDeniedOneButton
//            "Access Denied (2 Buttons)", // locationAccessDenied
//            "Location Fail (Image)",    // locationAccessFailImage
//            "Stop Preference Analysis"  // stoppedPreferenceAnalysis
//        ]
//        let colors: [UIColor] = [.red, .blue, .green, .orange]
//
//        for (index, button) in buttons.enumerated() {
//            button.setTitle(titles[index], for: .normal)
//            button.setTitleColor(.white, for: .normal)
//            button.backgroundColor = colors[index]
//            button.layer.cornerRadius = 8
//            button.tag = index // 버튼 태그로 케이스 구분
//            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
//            view.addSubview(button)
//        }
//
//        // 버튼 레이아웃
//        button1.snp.makeConstraints {
//            $0.top.equalToSuperview().offset(100)
//            $0.centerX.equalToSuperview()
//            $0.width.equalTo(250)
//            $0.height.equalTo(50)
//        }
//
//        button2.snp.makeConstraints {
//            $0.top.equalTo(button1.snp.bottom).offset(20)
//            $0.centerX.equalToSuperview()
//            $0.width.equalTo(250)
//            $0.height.equalTo(50)
//        }
//
//        button3.snp.makeConstraints {
//            $0.top.equalTo(button2.snp.bottom).offset(20)
//            $0.centerX.equalToSuperview()
//            $0.width.equalTo(250)
//            $0.height.equalTo(50)
//        }
//
//        button4.snp.makeConstraints {
//            $0.top.equalTo(button3.snp.bottom).offset(20)
//            $0.centerX.equalToSuperview()
//            $0.width.equalTo(250)
//            $0.height.equalTo(50)
//        }
//    }
//
//    @objc private func buttonTapped(_ sender: UIButton) {
//        // AlertType 케이스에 따라 알림 표시
//        switch sender.tag {
//        case 0:
//            showCustomAlert(for: .uploadExit) // 1 버튼 케이스
//        case 1:
//            showCustomAlert(for: .locationAccessDenied)          // 2 버튼 케이스
//        case 2:
//            showCustomAlert(for: .locationAccessFailImage)       // 이미지 포함
//        case 3:
//            showCustomAlert(for: .stoppedPreferenceAnalysis)     // 취향 분석
//        default:
//            break
//        }
//    }
//}
//
//import SwiftUI
//
//struct TestAlertViewPreview: UIViewControllerRepresentable {
//    func makeUIViewController(context: Context) -> TestViewAlert {
//        return TestViewAlert()
//    }
//    
//    func updateUIViewController(_ uiViewController: TestViewAlert, context: Context) {
//        // 필요 시 업데이트 로직 추가
//    }
//}
//
//struct TestViewAlertPreview_Previews: PreviewProvider {
//    static var previews: some View {
//        TestAlertViewPreview()
//            .edgesIgnoringSafeArea(.all)
//            .previewDevice("iPhone 14 Pro")
//            .preferredColorScheme(.dark)
//    }
//}
