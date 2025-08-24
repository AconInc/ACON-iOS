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

    private let acornDropLottieView = LottieAnimationView(name: StringLiterals.Lottie.drop5Acorn)

    private let titleLabel = UILabel()

    private let firstSubtitleLabel = UILabel()

    private let secondSubtitleStackView = UIStackView()
    private let localVerifiedSpotLabel = UILabel()
    private let localTagImageView = UIImageView()
    private let tagsAttachedLabel = UILabel()


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

        view.addSubviews(acornDropLottieView, titleLabel, firstSubtitleLabel, secondSubtitleStackView)

        secondSubtitleStackView.addArrangedSubviews(localVerifiedSpotLabel, localTagImageView, tagsAttachedLabel)
    }

    override func setLayout() {
        super.setLayout()

        acornDropLottieView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(64 * ScreenUtils.heightRatio)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(360 * ScreenUtils.widthRatio)
            $0.height.equalTo(266 * ScreenUtils.widthRatio)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(acornDropLottieView.snp.bottom).offset(64 * ScreenUtils.heightRatio)
            $0.centerX.equalToSuperview()
        }

        firstSubtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24 * ScreenUtils.heightRatio)
            $0.centerX.equalToSuperview()
        }

        secondSubtitleStackView.snp.makeConstraints {
            $0.centerY.equalTo(firstSubtitleLabel.snp.centerY).offset(32 * ScreenUtils.heightRatio)
            $0.centerX.equalToSuperview()
        }

        localTagImageView.snp.makeConstraints {
            $0.width.equalTo(120)
            $0.height.equalTo(84)
        }
    }

    override func setStyle() {
        super.setStyle()

        view.backgroundColor = .gray900

        acornDropLottieView.do {
            $0.contentMode = .scaleAspectFit
            $0.animationSpeed = 1.25
        }

        [titleLabel, firstSubtitleLabel, secondSubtitleStackView].forEach { $0.isHidden = true }

        secondSubtitleStackView.do {
            $0.axis = .horizontal
            $0.spacing = -24
            $0.alignment = .center
        }

        titleLabel.setLabel(text: StringLiterals.Tutorial.verifiedLocalReviewTitle, style: .h3B)

        firstSubtitleLabel.setLabel(text: StringLiterals.Tutorial.dropAcornForReview, style: .t4SB, alignment: .center)

        localVerifiedSpotLabel.setLabel(text: StringLiterals.Tutorial.localVerifiedSpots, style: .t4SB, alignment: .center)
        
        tagsAttachedLabel.setLabel(text: StringLiterals.Tutorial.tagsAttached, style: .t4SB, alignment: .center)
        
        localTagImageView.do {
            $0.image = .imgTagLocal
            $0.contentMode = .scaleAspectFit
        }
    }

    private func playAnimation() {
        let delay: TimeInterval = 0.2
        let duration: TimeInterval = 0.8

        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            guard let self = self else { return }

            acornDropLottieView.play { isFinished in
                if isFinished {
                    self.titleLabel.animateSlideUp(duration: duration)

                    [self.firstSubtitleLabel, self.secondSubtitleStackView].forEach {
                        $0.animateFadeIn(duration: duration, delay: delay)
                    }
                }
            }
        }
    }

}
