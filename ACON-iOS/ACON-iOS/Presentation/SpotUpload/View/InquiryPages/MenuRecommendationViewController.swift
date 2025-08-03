//
//  MenuRecommendationViewController.swift
//  ACON-iOS
//
//  Created by 김유림 on 7/25/25.
//

import UIKit

class MenuRecommendationViewController: BaseUploadInquiryViewController {

    // MARK: - UI Properties

    private let textField = ACTextField(cornerRadius: 8, fontStyle: .b1R, borderGlassType: .buttonGlassDefault)


    // MARK: - Properties

    override var contentViews: [UIView] {
        [textField]
    }

    override var canGoPrevious: Bool { true }

    override var canGoNext: Bool {
        guard let spotName = viewModel.recommendedMenu else { return false }
        return !spotName.isEmpty
    }


    // MARK: - init

    init(_ viewModel: SpotUploadViewModel) {
        super.init(viewModel: viewModel,
                   requirement: .required,
                   title: StringLiterals.SpotUpload.recommendMenu)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        bindObservable()
    }


    // MARK: - UI Setting

    override func setLayout() {
        super.setLayout()

        let sizeType = SpotUploadSizeType.TextField.self
        textField.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(sizeType.horizontalInset)
            $0.height.equalTo(sizeType.height)
        }
    }

    override func setStyle() {
        super.setStyle()

        self.hideKeyboard()

        textField.do {
            $0.setPlaceholder(as: StringLiterals.SpotUpload.enterMenu)
            if let recommendedMenu = viewModel.recommendedMenu {
                $0.text = recommendedMenu
            } else {
                $0.hideClearButton(isHidden: true)
            }
        }
    }

}


// MARK: - bindings

private extension MenuRecommendationViewController {

    func bindObservable() {
        textField.observableText.bind { [weak self] text in
            guard let text else { return }
            self?.textField.hideClearButton(isHidden: text.isEmpty)
            self?.viewModel.recommendedMenu = text
            self?.updatePagingButtonStates()
        }
    }

}
