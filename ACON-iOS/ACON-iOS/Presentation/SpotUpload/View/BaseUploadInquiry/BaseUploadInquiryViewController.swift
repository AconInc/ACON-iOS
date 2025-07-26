//
//  SpotUploadChildBaseViewController.swift
//  ACON-iOS
//
//  Created by 김유림 on 7/16/25.
//

import UIKit

class BaseUploadInquiryViewController: BaseViewController {

    // MARK: - Properties
    
    let viewModel: SpotUploadViewModel
    let spotUploadInquiryView: BaseUploadInquiryView

    // NOTE: 하위 뷰컨에서 override하여 설정
    var contentViews: [UIView] { [] }
    var canGoPrevious: Bool { true }
    var canGoNext: Bool { false }


    // MARK: - init

    init(viewModel: SpotUploadViewModel, requirement: RequirementType, title: String, caption: String? = nil) {
        self.viewModel = viewModel
        self.spotUploadInquiryView = BaseUploadInquiryView(requirement: requirement, title: title, caption: caption)

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - Lifecycle

    override func loadView() {
        view = spotUploadInquiryView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        updatePagingButtonStates()
    }


    // MARK: - Hierarchy

    override func setHierarchy() {
        super.setHierarchy()

        contentViews.forEach { spotUploadInquiryView.contentView.addSubview($0) }
    }


    // MARK: - Helper

    func updatePagingButtonStates() {
        viewModel.isPreviousButtonEnabled.value = canGoPrevious
        viewModel.isNextButtonEnabled.value = canGoNext
    }

    func makeOptionButtonStack(_ buttons: [UIButton]) {
        let sizeType = SpotUploadSizeType.LongOptionButton.self
        let stackView = UIStackView().then {
            $0.axis = .vertical
            $0.spacing = 12
        }

        spotUploadInquiryView.contentView.addSubview(stackView)

        stackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(sizeType.horizontalInset)
        }

        for button in buttons {
            stackView.addArrangedSubview(button)

            button.snp.makeConstraints {
                $0.height.equalTo(sizeType.height)
            }
        }
    }

}
