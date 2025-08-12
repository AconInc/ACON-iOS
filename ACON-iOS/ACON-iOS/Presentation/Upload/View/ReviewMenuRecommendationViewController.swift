//
//  ReviewMenuRecommendationViewController.swift
//  ACON-iOS
//
//  Created by 김유림 on 8/5/25.
//

import UIKit

class ReviewMenuRecommendationViewController: BaseNavViewController {

    // MARK: - UI Properties

    private let headLabel = UILabel()

    private let textField = ACTextField(cornerRadius: 8, fontStyle: .b1R, borderGlassType: .buttonGlassDefault)


    // MARK: - Properties

    private let viewModel: SpotReviewViewModel


    // MARK: - init

    init(_ viewModel: SpotReviewViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        bindObservable()
    }


    // MARK: - UI Setting

    override func setHierarchy() {
        super.setHierarchy()

        self.contentView.addSubviews(headLabel, textField)
    }

    override func setLayout() {
        super.setLayout()

        headLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(64 * ScreenUtils.heightRatio)
            $0.horizontalEdges.equalToSuperview().inset(18 * ScreenUtils.widthRatio)
        }

        let sizeType = SpotUploadSizeType.TextField.self
        textField.snp.makeConstraints {
            $0.top.equalTo(headLabel.snp.bottom).offset(32 * ScreenUtils.heightRatio)
            $0.horizontalEdges.equalToSuperview().inset(sizeType.horizontalInset)
            $0.height.equalTo(sizeType.height)
        }
    }

    override func setStyle() {
        super.setStyle()

        self.setPopGesture()

        // NOTE: 네비게이션 바
        self.setCenterTitleLabelStyle(title: StringLiterals.Upload.upload)
        self.setBackButton()
        self.setNextButton()
        self.setButtonAction(button: rightButton, target: self, action:  #selector(nextButtonTapped))

        self.hideKeyboard()

        headLabel.setLabel(text: StringLiterals.SpotUpload.recommendMenu, style: .h3SB, color: .acWhite)
        textField.setPlaceholder(as: StringLiterals.SpotUpload.enterMenu)
        updateInputUIState()
    }

}


// MARK: - bindings

private extension ReviewMenuRecommendationViewController {

    func bindObservable() {
        textField.observableText.bind { [weak self] text in
            guard let text else { return }

            // NOTE: 글자수 제한
            guard text.count <= SpotUploadType.recommendedMenuMaxLength else {
                self?.textField.text?.removeLast()
                return
            }

            self?.viewModel.recommendedMenu = text
            self?.updateInputUIState()
        }
    }

}


// MARK: - @objc functions

private extension ReviewMenuRecommendationViewController {

    @objc
    func nextButtonTapped() {
        let vc = DropAcornViewController(viewModel)
        self.navigationController?.pushViewController(vc, animated: false)
    }

}


// MARK: - Helper

private extension ReviewMenuRecommendationViewController {

    func updateInputUIState() {
        let menuEntered = !viewModel.recommendedMenu.isEmpty

        textField.hideClearButton(isHidden: !menuEntered)
        self.rightButton.isEnabled = menuEntered
    }

}
