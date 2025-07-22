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

}
