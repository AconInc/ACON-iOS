//
//  ValueRatingViewController.swift
//  ACON-iOS
//
//  Created by 김유림 on 7/25/25.
//

import UIKit

class ValueRatingViewController: BaseUploadInquiryViewController {

    // MARK: - UI Properties

    private let bestValueButton = SpotUploadOptionButton(title: StringLiterals.SpotUpload.bestValue)
    
    private let averageValueButton = SpotUploadOptionButton(title: StringLiterals.SpotUpload.averageValue)

    private let lowValueButton = SpotUploadOptionButton(title: StringLiterals.SpotUpload.lowValue)


    // MARK: - Properties

    override var canGoPrevious: Bool { true }
    override var canGoNext: Bool { viewModel.valueRating != nil }


    // MARK: - init

    init(_ viewModel: SpotUploadViewModel) {
        super.init(viewModel: viewModel,
                   requirement: .required,
                   title: StringLiterals.SpotUpload.isThisValueForMoney)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        addTarget()
        makeOptionButtonStack([bestValueButton, averageValueButton, lowValueButton])
    }

}


// MARK: - AddTarget

private extension ValueRatingViewController {

    func addTarget() {
        bestValueButton.addTarget(self, action: #selector(tappedbestValueButton), for: .touchUpInside)
        averageValueButton.addTarget(self, action: #selector(tappedAverageValueButton), for: .touchUpInside)
        lowValueButton.addTarget(self, action: #selector(tappedLowValueButton), for: .touchUpInside)
    }

}

// MARK: - @objc functions

private extension ValueRatingViewController {

    @objc
    func tappedbestValueButton() {
        viewModel.valueRating = .best
        updateOptionButtonStates()
        updatePagingButtonStates()
    }

    @objc
    func tappedAverageValueButton() {
        viewModel.valueRating = .average
        updateOptionButtonStates()
        updatePagingButtonStates()
    }

    @objc
    func tappedLowValueButton() {
        viewModel.valueRating = .low
        updateOptionButtonStates()
        updatePagingButtonStates()
    }
}


// MARK: - Helper

private extension ValueRatingViewController {

    func updateOptionButtonStates() {
        bestValueButton.isSelected = viewModel.valueRating == .best
        averageValueButton.isSelected = viewModel.valueRating == .average
        lowValueButton.isSelected = viewModel.valueRating == .low
    }

}
