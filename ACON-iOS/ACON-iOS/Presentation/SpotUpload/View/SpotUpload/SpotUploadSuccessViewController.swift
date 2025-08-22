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

    private let lottieView: LottieAnimationView = LottieAnimationView()

    private let headLabel = UILabel()

    private let captionLabel = UILabel()

    private let donebutton = ACButton(style: GlassButton(glassmorphismType: .buttonGlassDefault, buttonType: .full_12_t4SB), title: StringLiterals.SpotUpload.done)


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

        contentView.addSubviews(headLabel, captionLabel, lottieView, donebutton)
    }

    override func setLayout() {
        super.setLayout()

        lottieView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(84 * ScreenUtils.heightRatio)
            $0.size.equalTo(160 * ScreenUtils.widthRatio)
        }

        headLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(lottieView.snp.bottom).offset(40 * ScreenUtils.heightRatio)
        }

        captionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(headLabel.snp.bottom).offset(10 * ScreenUtils.heightRatio)
        }

        donebutton.snp.makeConstraints {
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
            $0.animation = LottieAnimation.named(StringLiterals.Lottie.success)
            $0.contentMode = .scaleAspectFit
        }
    }

    private func addTarget() {
        donebutton.addTarget(self,
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
