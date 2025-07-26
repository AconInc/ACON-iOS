//
//  SpotTypeSelectionViewController.swift
//  ACON-iOS
//
//  Created by 김유림 on 7/16/25.
//

import UIKit

class SpotTypeSelectionViewController: BaseUploadInquiryViewController {

    // MARK: - UI Properties

    private let restaurantButton = SpotUploadOptionButton(title: StringLiterals.SpotUpload.restaurant)
    
    private let cafeButton = SpotUploadOptionButton(title: StringLiterals.SpotUpload.cafe)


    // MARK: - Properties

    override var canGoPrevious: Bool { true }
    override var canGoNext: Bool { viewModel.spotType != nil }


    // MARK: - init

    init(_ viewModel: SpotUploadViewModel) {
        super.init(viewModel: viewModel,
                   requirement: .required,
                   title: StringLiterals.SpotUpload.isThisRestaurantOrCafe,
                   caption: StringLiterals.SpotUpload.brunchIsCafe)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        addTarget()
        makeOptionButtonStack([restaurantButton, cafeButton])
    }

}


// MARK: - AddTarget

private extension SpotTypeSelectionViewController {

    func addTarget() {
        restaurantButton.addTarget(self, action: #selector(tappedRestaurantButton), for: .touchUpInside)
        cafeButton.addTarget(self, action: #selector(tappedCafeButton), for: .touchUpInside)
    }

}

// MARK: - @objc functions

private extension SpotTypeSelectionViewController {

    @objc
    func tappedRestaurantButton() {
        viewModel.spotType = .restaurant
        restaurantButton.isSelected = true
        cafeButton.isSelected = false

        updatePagingButtonStates()
    }

    @objc
    func tappedCafeButton() {
        viewModel.spotType = .cafe
        restaurantButton.isSelected = false
        cafeButton.isSelected = true

        updatePagingButtonStates()
    }

}
