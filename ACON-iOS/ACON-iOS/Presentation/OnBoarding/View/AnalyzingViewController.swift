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
    
    private let lodingLottie = LottieAnimationView(name: "lodingLottie")
    private let checkLottie = LottieAnimationView(name: "checkLottie")
    private let analyzingLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray9
        startLodingLottie()
    }
    
    override func setStyle() {
        super.setStyle()
        
        lodingLottie.do {
            $0.contentMode = .scaleAspectFit
            $0.loopMode = .playOnce
            $0.animationSpeed = 1.0
            $0.backgroundBehavior = .pauseAndRestore
        }
        
        checkLottie.do {
            $0.contentMode = .scaleAspectFit
            $0.loopMode = .playOnce
            $0.animationSpeed = 1.0
            $0.backgroundBehavior = .pauseAndRestore
            $0.isHidden = true
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
        
        view.addSubviews(lodingLottie,
                         analyzingLabel,
                         checkLottie)
    }
    
    override func setLayout() {
        super.setLayout()
        
        lodingLottie.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(500)
        }
        
        checkLottie.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(500)
        }
        
        analyzingLabel.snp.makeConstraints {
            $0.bottom.equalTo(lodingLottie.snp.top)
            $0.centerX.equalToSuperview()
        }
    }
}

extension AnalyzingViewController {
    
    private func startLodingLottie() {
        lodingLottie.play { [weak self] finished in
            guard let self = self, finished else { return }
            self.showCheckLottie()
        }
    }
    
    private func showCheckLottie() {
        lodingLottie.isHidden = true
        checkLottie.isHidden = false
        
        analyzingLabel.text = StringLiterals.Analyzing.analyzingAfter
        
        checkLottie.play { [weak self] finished in
            guard let self = self, finished else { return }
            self.navigateToNextScreen()
        }
    }
    
    private func navigateToNextScreen() {
        // NOTE: 장소추천뷰로 이동 - 모달 방식
        let mainViewController = ACTabBarController()
        mainViewController.modalPresentationStyle = .fullScreen
        present(mainViewController, animated: true)
    }
}
