//
//  DropAcornViewController.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/13/25.
//

import UIKit

import Lottie

class DropAcornViewController: BaseNavViewController {
    
    // MARK: - UI Properties
    
    private let dropAcornView = DropAcornView()
    
    var reviewAcornCount: Int = 0
    
    var possessAcornCount: Int = 0
    
    // MARK: - Properties
    
    private var spotReviewViewModel = SpotReviewViewModel()
    
    private var spotID: Int64 = 0
    
    private var spotName: String = ""
    
    init(spotID: Int64, spotName: String) {
        self.spotID = spotID
        self.spotName = spotName
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTarget()
        bindViewModel()
    }
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.contentView.addSubview(dropAcornView)
    }
    
    override func setLayout() {
        super.setLayout()

        dropAcornView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func setStyle() {
        super.setStyle()
        
        self.setButtonStyle(button: leftButton, image: .icArrowLeft)
        self.setButtonAction(button: leftButton, target: self, action: #selector(dropAcornBackButtonTapped))
        self.setCenterTitleLabelStyle(title: StringLiterals.Upload.upload)
        self.dropAcornView.spotNameLabel.setLabel(text: self.spotName, style: .t3SB, alignment: .center)
    }
    
    func addTarget() {
        self.leftButton.addTarget(self,
                                  action: #selector(xButtonTapped),
                                  for: .touchUpInside)
        dropAcornView.leaveReviewButton.addTarget(self,
                                                  action: #selector(leaveReviewButtonTapped),
                                                  for: .touchUpInside)
        for i in 0...4 {
            let btn = dropAcornView.acornStackView.arrangedSubviews[i] as? UIButton
            btn?.tag = i
            btn?.addTarget(self, action: #selector(reviewAcornButtonTapped(_:)), for: .touchUpInside)
        }
    }

}

    
// MARK: - @objc functions

private extension DropAcornViewController {
    
    @objc
    func dropAcornBackButtonTapped() {
        dismiss(animated: false)
    }
    
    @objc
    func leaveReviewButtonTapped() {
        spotReviewViewModel.postReview(spotID: spotID, acornCount: reviewAcornCount)
        AmplitudeManager.shared.trackEventWithProperties(AmplitudeLiterals.EventName.placeUpload, properties: ["click_review_acon?": true, "num_of_acon": reviewAcornCount, "spot_id": reviewAcornCount])
    }
    
    @objc
    func reviewAcornButtonTapped(_ sender: UIButton) {
        let selectedIndex = sender.tag
        for i in 0...4 {
            let btn = dropAcornView.acornStackView.arrangedSubviews[i] as? UIButton
            btn?.isSelected = i <= selectedIndex ? true : false
        }
        dropAcornView.acornReviewLabel.text = "\(selectedIndex+1)/5"
        reviewAcornCount = selectedIndex + 1
        checkAcorn(reviewAcornCount)
    }
    
    @objc
    func xButtonTapped() {
        let alertHandler = AlertHandler()
        alertHandler.showUploadExitAlert(from: self)
    }
    
}


// MARK: - bind ViewModel

private extension DropAcornViewController {
    
    func bindViewModel() {
        self.spotReviewViewModel.onSuccessPostReview.bind { [weak self] onSuccess in
            guard let onSuccess else { return }
            if onSuccess {
                let vc = ReviewFinishedViewController(spotName: self?.spotName ?? "")
                self?.present(vc, animated: false)
            } else {
                self?.showDefaultAlert(title: "리뷰 포스트 실패", message: "도토리 개수 로드에 실패했습니다.")
            }
        }
    }
    
}


// MARK: - drop acorn 로직

private extension DropAcornViewController {
    
    func checkAcorn(_ dropAcorn: Int) {
        dropAcornView.dropAcornLottieView.isHidden = false
        toggleLottie(dropAcorn: dropAcorn)
        dropAcornView.leaveReviewButton.updateGlassButtonState(state: .default)
        dropAcornView.lightImageView.isHidden = false
    }
    
}


// MARK: - Lottie

private extension DropAcornViewController {
    
    func toggleLottie(dropAcorn: Int) {
        dropAcornView.dropAcornLottieView.do {
            switch dropAcorn {
            case 1:
                $0.animation = LottieAnimation.named("drop1Acorn")
            case 2:
                $0.animation = LottieAnimation.named("drop2Acorn")
            case 3:
                $0.animation = LottieAnimation.named("drop3Acorn")
            case 4:
                $0.animation = LottieAnimation.named("drop4Acorn")
            case 5:
                $0.animation = LottieAnimation.named("drop5Acorn")
            default:
                $0.isHidden = true
            }
            $0.play()
        }
    }
    
}
