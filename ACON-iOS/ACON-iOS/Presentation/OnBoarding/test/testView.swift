import Foundation
import UIKit
import SnapKit
import Then
import SwiftUI

import UIKit
import SnapKit

final class testViewAlert: UIViewController {
    private let button1 = UIButton()
    private let button2 = UIButton()
    private let button3 = UIButton()
    private let button4 = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupButtons()
    }

    // Custom Alert 표시
    private func showCustomAlert() {
        let alert = CustomAlertView()
        alert.onClose = { [weak self] in
            print("닫기 버튼 눌림")
        }
        alert.onSettings = { [weak self] in
            print("설정으로 이동")
        }
        alert.modalPresentationStyle = .overFullScreen // 배경 투명 설정
        alert.modalTransitionStyle = .crossDissolve   // 부드러운 전환 효과
        present(alert, animated: true, completion: nil)
    }

    private func setupButtons() {
        let buttons = [button1, button2, button3, button4]
        let titles = ["Button 1", "Button 2", "Button 3", "Button 4"]
        let colors: [UIColor] = [.red, .blue, .green, .orange]

        for (index, button) in buttons.enumerated() {
            button.setTitle(titles[index], for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = colors[index]
            button.layer.cornerRadius = 8
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            view.addSubview(button)
        }

        // 버튼 레이아웃
        button1.snp.makeConstraints {
            $0.top.equalToSuperview().offset(100)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(200)
            $0.height.equalTo(50)
        }

        button2.snp.makeConstraints {
            $0.top.equalTo(button1.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(200)
            $0.height.equalTo(50)
        }

        button3.snp.makeConstraints {
            $0.top.equalTo(button2.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(200)
            $0.height.equalTo(50)
        }

        button4.snp.makeConstraints {
            $0.top.equalTo(button3.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(200)
            $0.height.equalTo(50)
        }
    }

    @objc private func buttonTapped(_ sender: UIButton) {
        // Alert 표시
        showCustomAlert()
    }
}

import SwiftUI

struct TestAlertViewPreview: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> testViewAlert {
        return testViewAlert()
    }
    
    func updateUIViewController(_ uiViewController: testViewAlert, context: Context) {
        // 필요 시 업데이트 로직 추가
    }
}

struct TestViewAlertPreview_Previews: PreviewProvider {
    static var previews: some View {
        TestAlertViewPreview() // 올바른 클래스 참조
            .edgesIgnoringSafeArea(.all)
            .previewDevice("iPhone 14 Pro")
            .preferredColorScheme(.dark)
    }
}
