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
    
    private func setSytle() {
        
        animationView.do {
            $0.contentMode = .scaleAspectFit
            $0.loopMode = .loop
            $0.animationSpeed = 1.0
            $0.play()
        }
        
        analyzingLabel.do {
            $0.text = "회원님의 취향을 \n빠르게 분석하고 있어요"
            $0.textColor = .acWhite
            $0.font = ACFont.h6.font
            $0.numberOfLines = 0
            $0.textAlignment = .center
        }
    }
    
    internal override func setHierarchy(){
        
        view.addSubviews(animationView, analyzingLabel)
        
    }
    
    internal override func setLayout() {
        
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
    
    private func updateLabelTextAfterDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            guard let self = self else { return }
            
            // 텍스트 업데이트
            self.analyzingLabel.text = "분석이 완료되었어요\n추천 맛집을 보여드릴게요!"
            
            // 장소추천뷰로 이동
            let mainViewController = SpotListViewController()
            self.navigationController?.pushViewController(mainViewController, animated: true)
        }
    }
}

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
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
}
