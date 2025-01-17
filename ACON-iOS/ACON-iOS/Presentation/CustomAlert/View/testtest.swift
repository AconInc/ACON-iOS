import UIKit

import UIKit
import SnapKit

final class TestViewController: UIViewController {
    
    private let alertHandler = AlertHandler()
    
    private let stoppedPreferenceButton = UIButton()
    private let locationAccessFailButton = UIButton()
    private let uploadExitButton = UIButton()
    private let reviewExitButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        
        // 버튼 설정
        setupButton(stoppedPreferenceButton, title: "취향 분석 중단", action: #selector(showStoppedPreferenceAlert))
        setupButton(locationAccessFailButton, title: "위치 권한 실패", action: #selector(showLocationAccessFailAlert))
        setupButton(uploadExitButton, title: "업로드 중단", action: #selector(showUploadExitAlert))
        setupButton(reviewExitButton, title: "리뷰 중단", action: #selector(showReviewExitAlert))
        
        // 버튼 추가 및 레이아웃 설정
        let stackView = UIStackView(arrangedSubviews: [
            stoppedPreferenceButton,
            locationAccessFailButton,
            uploadExitButton,
            reviewExitButton
        ])
        
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func setupButton(_ button: UIButton, title: String, action: Selector) {
        button.setTitle(title, for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.snp.makeConstraints {
            $0.width.equalTo(200)
            $0.height.equalTo(50)
        }
    }
    
    // 각 버튼이 호출할 메서드
    @objc private func showStoppedPreferenceAlert() {
        alertHandler.showStoppedPreferenceAnalysisAlert(from: self)
    }
    
    @objc private func showLocationAccessFailAlert() {
        alertHandler.showLocationAccessFailAlert(from: self)
    }
    
    @objc private func showUploadExitAlert() {
        alertHandler.showUploadExitAlert(from: self)
    }
    
    @objc private func showReviewExitAlert() {
        alertHandler.showReviewExitAlert(from: self)
    }
}

#if DEBUG
import SwiftUI

struct TestViewControllerPreview: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> TestViewController {
        return TestViewController() // 프리뷰를 위한 TestViewController 생성
    }
    
    func updateUIViewController(_ uiViewController: TestViewController, context: Context) {
        // 업데이트 로직이 필요하면 추가
    }
}

struct TestViewController_Previews: PreviewProvider {
    static var previews: some View {
        TestViewControllerPreview()
            .edgesIgnoringSafeArea(.all) // 전체 화면에 걸쳐 표시
    }
}
#endif
