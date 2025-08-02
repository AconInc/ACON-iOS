//
//  SpotUploadSuccessViewController.swift
//  ACON-iOS
//
//  Created by 김유림 on 8/2/25.
//

import UIKit

import Lottie

class SpotUploadSuccessViewController: BaseNavViewController {

    // MARK: - UI Properties

    private let headLabel = UILabel()
    
    private let captionLabel = UILabel()

    private let lottieView: LottieAnimationView = LottieAnimationView()

    private let homebutton = ACButton(style: GlassButton(glassmorphismType: .buttonGlassDefault, buttonType: .full_12_t4SB),
                              title: StringLiterals.SpotUpload.goHome)


    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        addTarget()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.lottieView.play()
    }


    // MARK: - UI Setting

    override func setHierarchy() {
        super.setHierarchy()

        contentView.addSubviews(headLabel, captionLabel, lottieView, homebutton)
    }

    override func setLayout() {
        super.setLayout()

        headLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(50 * ScreenUtils.heightRatio)
        }
        
        captionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(headLabel.snp.bottom).offset(10 * ScreenUtils.heightRatio)
        }

        lottieView.snp.makeConstraints { // TODO: 수정
            $0.centerX.equalToSuperview()
            $0.top.equalTo(captionLabel.snp.bottom).offset(56*ScreenUtils.heightRatio)
            $0.width.equalTo(ScreenUtils.width * 0.8)
        }

        homebutton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.horizontalInset)
            $0.bottom.equalToSuperview().inset(ScreenUtils.safeAreaBottomHeight + ScreenUtils.horizontalInset)
            $0.height.equalTo(54)
        }
    }

    override func setStyle() {
        super.setStyle()
        
        self.setCenterTitleLabelStyle(title: StringLiterals.SpotUpload.spotUpload)

        headLabel.setLabel(text: StringLiterals.SpotUpload.newSpotSaved, style: .h3SB)
        captionLabel.setLabel(text: StringLiterals.SpotUpload.itWillBeReflectedInThreeDays, style: .t5R, color: .gray500)
        
        lottieView.do {
            $0.animation = LottieAnimation.named("finishedUpload") // TODO: 수정
            $0.contentMode = .scaleAspectFit
        }
    }

    private func addTarget() {
        homebutton.addTarget(self,
                             action: #selector(goHome),
                             for: .touchUpInside)
    }

}


// MARK: - @objc functions

private extension SpotUploadSuccessViewController {

    @objc private func goHome() {
        NavigationUtils.navigateToTabBar()
    }

}
