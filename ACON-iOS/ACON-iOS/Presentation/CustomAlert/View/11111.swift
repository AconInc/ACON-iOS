import UIKit

final class TestViewController: UIViewController {
    
    private let showAlertButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        
        showAlertButton.do {
            $0.setTitle("Show Alert", for: .normal)
            $0.setTitleColor(.blue, for: .normal)
            $0.addTarget(self, action: #selector(showAlert), for: .touchUpInside)
        }
        
        view.addSubview(showAlertButton)
        showAlertButton.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(200)
            $0.height.equalTo(50)
        }
    }
    
    @objc private func showAlert() {
        let customAlertView = CustomAlertView()
        customAlertView.configure(with: .stoppedPreferenceAnalysis) // AlertType 설정
        customAlertView.view.layoutIfNeeded() // 레이아웃 강제 업데이트

        customAlertView.onClose = {
            print("Close action triggered")
        }
        customAlertView.onSettings = {
            print("Settings action triggered")
        }
        present(customAlertView, animated: true)
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
