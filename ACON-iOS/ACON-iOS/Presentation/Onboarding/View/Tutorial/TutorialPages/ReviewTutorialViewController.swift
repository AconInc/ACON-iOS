//
//  ReviewTutorialViewController.swift
//  ACON-iOS
//
//  Created by 김유림 on 8/21/25.
//

import UIKit

import Lottie

class ReviewTutorialViewController: BaseViewController {

    // MARK: - Properties

    private var isInitialAppear: Bool = true


    // MARK: - UI Properties

    private let titleStack = TutorialPageTitleStackView(title: StringLiterals.Tutorial.verifiedLocalReviewTitle, subTitle: StringLiterals.Tutorial.verifiedLocalReviewSubTitle)

    private let acornDropLottieView = LottieAnimationView(name: StringLiterals.Lottie.drop5Acorn)

    private let localTagImageView = UIImageView()


    // MARK: - Lifecycle

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isInitialAppear {
            playAnimation()
            isInitialAppear = false
        }
    }


    // MARK: - UI Settings

    override func setHierarchy() {
        super.setHierarchy()

        view.addSubviews(titleStack, acornDropLottieView, localTagImageView)
    }

    override func setLayout() {
        super.setLayout()

        titleStack.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(52 * ScreenUtils.heightRatio)
            $0.centerX.equalToSuperview()
        }

        acornDropLottieView.snp.makeConstraints {
            $0.top.equalTo(titleStack.snp.bottom).offset(40 * ScreenUtils.heightRatio)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(266 * ScreenUtils.heightRatio)
        }
        
        localTagImageView.snp.makeConstraints {
            $0.top.equalTo(acornDropLottieView.snp.bottom).offset(10 * ScreenUtils.heightRatio)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(150)
            $0.height.equalTo(110)
        }
    }

    override func setStyle() {
        super.setStyle()

        view.backgroundColor = .acBlack

        acornDropLottieView.do {
            $0.contentMode = .scaleAspectFit
            $0.animationSpeed = 1.25
        }

        localTagImageView.do {
            $0.image = .imgTagLocal
            $0.contentMode = .scaleAspectFit
        }

        [titleStack, localTagImageView].forEach { $0.isHidden = true }
    }

    private func playAnimation() {
        let duration: TimeInterval = 1.0
        let delay: TimeInterval = 0.2
        titleStack.animateSlideUp(duration: duration, delay: delay)

        DispatchQueue.main.asyncAfter(deadline: .now() + delay * 2 + duration) { [weak self] in
            guard let self = self else { return }

            acornDropLottieView.play { isFinished in
                if isFinished {
                    self.localTagImageView.isHidden = false
                    self.localTagImageView.startBlinking(duration: 4.0, minAlpha: 0)
                }
            }
        }
    }

}
