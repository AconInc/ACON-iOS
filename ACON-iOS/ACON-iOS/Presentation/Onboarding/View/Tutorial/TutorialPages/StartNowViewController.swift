//
//  StartNowViewController.swift
//  ACON-iOS
//
//  Created by 김유림 on 8/21/25.
//

import UIKit

class StartNowViewController: BaseViewController {

    // MARK: - Properties

    private var isInitialAppear: Bool = true


    // MARK: - UI Properties

    private let previewImageView = UIImageView()

    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()

    private let startButton = UIButton()


    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        addTarget()
    }

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

        view.addSubviews(previewImageView, titleLabel, subTitleLabel, startButton)
    }

    override func setLayout() {
        super.setLayout()

        previewImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(43 * ScreenUtils.heightRatio)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(297 * ScreenUtils.heightRatio)
            $0.height.greaterThanOrEqualTo(474 * ScreenUtils.heightRatio)
        }

        titleLabel.snp.makeConstraints {
            $0.bottom.equalTo(previewImageView).offset(-33 * ScreenUtils.heightRatio)
            $0.centerX.equalToSuperview()
        }

        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24 * ScreenUtils.heightRatio)
            $0.centerX.equalToSuperview()
        }

        startButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(ScreenUtils.horizontalInset)
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.horizontalInset)
            $0.height.equalTo(54)
        }
    }

    override func setStyle() {
        super.setStyle()

        view.backgroundColor = .gray900

        [previewImageView, titleLabel, subTitleLabel].forEach { $0.isHidden = true }

        previewImageView.do {
            $0.image = .imgTutorialHomePreview
            $0.contentMode = .scaleAspectFit
        }

        titleLabel.setLabel(text: StringLiterals.Tutorial.noMoreWorry, style: .h3B)

        subTitleLabel.setLabel(text: StringLiterals.Tutorial.startNowSubTitle, style: .t4SB, alignment: .center)

        startButton.do {
            let glassDefaultColor = UIColor(red: 0.255, green: 0.255, blue: 0.255, alpha: 1)
            $0.setAttributedTitle(text: StringLiterals.Tutorial.start, style: .b1SB)
            $0.backgroundColor = glassDefaultColor
            $0.layer.cornerRadius = 12
            $0.layer.opacity = 0
        }
    }

    private func playAnimation() {
        let delay: TimeInterval = 0.2
        let duration: TimeInterval = 0.8

        previewImageView.animateSlideUp(duration: duration, delay: delay)

        titleLabel.animateSlideUp(duration: duration, delay: delay * 2)

        subTitleLabel.animateSlideUp(duration: duration, delay: delay * 3)

        startButton.animateFadeIn(duration: duration, delay: delay * 4)
    }

}


// MARK: - AddTarget

private extension StartNowViewController {

    func addTarget() {
        startButton.addTarget(self, action: #selector(tappedStartButton), for: .touchUpInside)
    }

    @objc
    func tappedStartButton() {
        UserDefaults.standard.set(true, forKey: StringLiterals.UserDefaults.hasSeenTutorial)
        NavigationUtils.navigateToTabBar()
    }

}
