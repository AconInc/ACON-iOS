//
//  CafeFeatureSelectionViewController.swift
//  ACON-iOS
//
//  Created by 김유림 on 7/25/25.
//

import UIKit

class CafeFeatureSelectionViewController: BaseUploadInquiryViewController {

    // MARK: - UI Properties

    private let workFriendlyButton = SpotUploadOptionButton(title: StringLiterals.SpotUpload.workFriendly)

    private let notWorkFriendlyButton = SpotUploadOptionButton(title: StringLiterals.SpotUpload.notWorkFriendly)


    // MARK: - Properties

    override var canGoPrevious: Bool { true }
    override var canGoNext: Bool { viewModel.isWorkFriendly != nil }


    // MARK: - init

    init(_ viewModel: SpotUploadViewModel) {
        super.init(viewModel: viewModel,
                   requirement: .required,
                   title: StringLiterals.SpotUpload.isWorkFriendly)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        addTarget()
        makeOptionButtonStack([workFriendlyButton, notWorkFriendlyButton])
    }

}


// MARK: - AddTarget

private extension CafeFeatureSelectionViewController {

    func addTarget() {
        workFriendlyButton.addTarget(self, action: #selector(tappedWorkFriendlyButton), for: .touchUpInside)
        notWorkFriendlyButton.addTarget(self, action: #selector(tappedNotWorkFriendlyButton), for: .touchUpInside)
    }

}


// MARK: - @objc functions

private extension CafeFeatureSelectionViewController {

    @objc
    func tappedWorkFriendlyButton() {
        viewModel.isWorkFriendly = true
        updateOptionButtonStates()
        updatePagingButtonStates()
    }

    @objc
    func tappedNotWorkFriendlyButton() {
        viewModel.isWorkFriendly = false
        updateOptionButtonStates()
        updatePagingButtonStates()
    }

}


// MARK: - Helper

private extension CafeFeatureSelectionViewController {

    func updateOptionButtonStates() {
        workFriendlyButton.isSelected = viewModel.isWorkFriendly ?? false
        notWorkFriendlyButton.isSelected = !(viewModel.isWorkFriendly ?? true)
    }

}
