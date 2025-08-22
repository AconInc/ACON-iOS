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

    private let titleStack = TutorialPageTitleStackView(title: StringLiterals.Tutorial.startNowTitle, subTitle: StringLiterals.Tutorial.startNowSubTitle)

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

        view.addSubviews(previewImageView, titleStack, startButton)
    }

    override func setLayout() {
        super.setLayout()

        previewImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(43 * ScreenUtils.heightRatio)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(297 * ScreenUtils.widthRatio)
            $0.height.equalTo(474 * ScreenUtils.widthRatio)
        }

        titleStack.snp.makeConstraints {
            $0.bottom.equalTo(previewImageView).offset(40 * ScreenUtils.heightRatio)
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

        previewImageView.do {
            $0.image = .imgTutorialHomePreview
            $0.contentMode = .scaleAspectFit
            $0.isHidden = true
        }

        titleStack.isHidden = true

        startButton.do {
            let glassDefaultColor = UIColor(red: 0.255, green: 0.255, blue: 0.255, alpha: 1)
            $0.setAttributedTitle(text: StringLiterals.Tutorial.start, style: .b1SB)
            $0.backgroundColor = glassDefaultColor
            $0.layer.cornerRadius = 12
            $0.layer.opacity = 0
        }
    }

    private func playAnimation() {
        let duration: TimeInterval = 1.0
        let delay: TimeInterval = 0.2

        previewImageView.animateSlideUp(duration: duration, delay: delay)

        titleStack.animateSlideUp(duration: duration, delay: duration + delay * 2)

        startButton.animateFadeIn(duration: duration, delay: duration * 2 + delay * 3)
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
