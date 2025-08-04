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

    private let viewModel: SpotReviewViewModel

    init(_ viewModel: SpotReviewViewModel) {
        self.viewModel = viewModel

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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setPopGesture()
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

        self.setBackButton()
        self.setCenterTitleLabelStyle(title: StringLiterals.Upload.upload)

        self.dropAcornView.spotNameLabel.setLabel(text: viewModel.spotName.abbreviatedString(20), style: .t3SB, alignment: .center)
    }

    func addTarget() {
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
    func leaveReviewButtonTapped() {
        viewModel.postReview(spotID: viewModel.spotID, acornCount: reviewAcornCount)
        AmplitudeManager.shared.trackEventWithProperties(AmplitudeLiterals.EventName.upload, properties: ["click_review_acon?": true, "spot_id": reviewAcornCount])
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

}


// MARK: - bind ViewModel

private extension DropAcornViewController {

    func bindViewModel() {
        self.viewModel.onSuccessPostReview.bind { [weak self] onSuccess in
            guard let onSuccess else { return }
            if onSuccess {
                let vc = ReviewFinishedViewController(spotName: self?.viewModel.spotName ?? "")
                vc.modalPresentationStyle = .fullScreen
                self?.present(vc, animated: false)
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            for i in 1...dropAcorn {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.2) {
                    HapticManager.shared.hapticImpact(style: .soft)
                }
            }
        }
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
