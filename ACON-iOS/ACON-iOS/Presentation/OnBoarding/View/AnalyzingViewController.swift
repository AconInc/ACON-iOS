//
//  analyzingView.swift
//  ACON-iOS
//
//  Created by Jaehyun Ahn on 1/15/25.
//

import UIKit

import Lottie
import SnapKit

final class AnalyzingViewController: BaseViewController {
    
    private let animationView = LottieAnimationView(name: "OnboardingLottie")
    private let analyzingLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateLabelTextAfterDelay()
    }
    
    override func setStyle() {
        super.setStyle()
        
        animationView.do {
            $0.contentMode = .scaleAspectFit
            $0.loopMode = .loop
            $0.animationSpeed = 1.0
            $0.backgroundBehavior = .pauseAndRestore
            $0.play()
        }
        
        analyzingLabel.do {
            $0.setLabel(
                text: StringLiterals.Analyzing.analyzing,
                style: ACFontStyleType.h6,
                color: .acWhite,
                alignment: .center,
                numberOfLines: 0
            )
        }
    }
    
    override func setHierarchy() {
        super.setHierarchy()
        
        view.addSubviews(animationView, analyzingLabel)
    }
    
    override func setLayout() {
        super.setLayout()
        
        animationView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(500)
        }
        
        analyzingLabel.snp.makeConstraints {
            $0.bottom.equalTo(animationView.snp.top)
            $0.centerX.equalToSuperview()
        }
    }
    
}

extension AnalyzingViewController {
    
    private func updateLabelTextAfterDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            guard let self = self else { return }
            
            self.analyzingLabel.text = StringLiterals.Analyzing.analyzingAfter
            
            // NOTE: 장소추천뷰로 - 우선 모달
            let mainViewController = ACTabBarController()
            mainViewController.modalPresentationStyle = .fullScreen
            self.present(mainViewController, animated: true)
        }
    }
    
}

// MARK: i will delete this
import SwiftUI

struct AnalyzingViewControllerPreview: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> AnalyzingViewController {
        return AnalyzingViewController()
    }
    
    func updateUIViewController(_ uiViewController: AnalyzingViewController, context: Context) {}
}

struct AnalyzingViewControllerPreview_Previews: PreviewProvider {
    static var previews: some View {
        AnalyzingViewControllerPreview()
            .edgesIgnoringSafeArea(.all)
            .previewLayout(.sizeThatFits)
            .frame(
                width: UIScreen.main.bounds.width,
                height: UIScreen.main.bounds.height
            )
    }
}
