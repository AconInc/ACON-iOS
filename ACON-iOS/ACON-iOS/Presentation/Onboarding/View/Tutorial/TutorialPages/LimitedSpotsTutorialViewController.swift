//
//  LimitedSpotsTutorialViewController.swift
//  ACON-iOS
//
//  Created by 김유림 on 8/21/25.
//

import UIKit

class LimitedSpotsTutorialViewController: BaseViewController {

    // MARK: - Properties

    private var isInitialAppear: Bool = true


    // MARK: - UI Properties

    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()

    private let centerImageView = UIImageView()
    private let leftImageView = UIImageView()
    private let rightImageView = UIImageView()

    private let dimGraView = UIView()


    // MARK: - Lifecycle

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isInitialAppear {
            playAnimation()
            isInitialAppear = false
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        dimGraView.setGradient(topColor: .gray900, bottomColor: .gray900.withAlphaComponent(0), startPoint: CGPoint(x: 0.5, y: 0.61))
    }


    // MARK: - UI Settings

    override func setHierarchy() {
        super.setHierarchy()

        view.addSubviews(centerImageView, leftImageView, rightImageView, dimGraView, titleLabel, subTitleLabel)
    }

    override func setLayout() {
        super.setLayout()

        let imagesWidth: CGFloat = 140 * ScreenUtils.widthRatio
        let imagesHeight: CGFloat = 670 * ScreenUtils.widthRatio
        let imagesSpacing: CGFloat = 16 * ScreenUtils.widthRatio

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(52 * ScreenUtils.heightRatio)
            $0.centerX.equalToSuperview()
        }

        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24 * ScreenUtils.heightRatio)
            $0.centerX.equalToSuperview()
        }

        centerImageView.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(120 * ScreenUtils.heightRatio)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(imagesWidth)
            $0.height.equalTo(imagesHeight)
        }
        
        leftImageView.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(32 * ScreenUtils.heightRatio)
            $0.trailing.equalTo(centerImageView.snp.leading).offset(-imagesSpacing)
            $0.width.equalTo(imagesWidth)
            $0.height.equalTo(imagesHeight)
        }

        rightImageView.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(32 * ScreenUtils.heightRatio)
            $0.leading.equalTo(centerImageView.snp.trailing).offset(imagesSpacing)
            $0.width.equalTo(imagesWidth)
            $0.height.equalTo(imagesHeight)
        }

        dimGraView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(centerImageView)
            $0.height.equalTo(266 * ScreenUtils.heightRatio)
        }
    }

    override func setStyle() {
        super.setStyle()

        view.do {
            $0.backgroundColor = .gray900
            $0.clipsToBounds = true
        }

        titleLabel.do {
            $0.setLabel(text: StringLiterals.Tutorial.limitedSpotsTitle, style: .t2SB, alignment: .center) // TODO: 폰트시스템 ExtraBold 추가 후 수정
            $0.isHidden = true
        }
        
        subTitleLabel.do {
            $0.setLabel(text: StringLiterals.Tutorial.limitedSpotsSubTitle, style: .t4SB, alignment: .center)
            $0.isHidden = true
        }

        leftImageView.image = .imgTutorialSpots1
        centerImageView.image = .imgTutorialSpots2
        rightImageView.image = .imgTutorialSpots3

        [leftImageView, centerImageView, rightImageView].forEach {
            $0.do {
                $0.isHidden = true
                $0.contentMode = .scaleAspectFit
            }
        }
    }

    private func playAnimation() {
        let duration: TimeInterval = 1.0
        let delay: TimeInterval = 0.2

        titleLabel.animateSlideUp(duration: duration, delay: delay)

        subTitleLabel.animateSlideUp(duration: duration, delay: delay * 2 + duration)

        [leftImageView, centerImageView, rightImageView].forEach {
            $0.animateFadeIn(duration: duration, delay: delay * 3 + duration * 2)
        }

        UIView.animate(withDuration: 1.0, delay: delay * 3 + duration * 2) {
            self.centerImageView.snp.updateConstraints {
                $0.top.equalTo(self.subTitleLabel.snp.bottom).offset(-93)
            }

            [self.leftImageView, self.rightImageView].forEach {
                $0.snp.updateConstraints {
                    $0.top.equalTo(self.subTitleLabel.snp.bottom).offset(93)
                }
            }

            self.view.layoutIfNeeded()
        }
    }

}
