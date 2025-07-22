//
//  SpotTypeSelectionViewController.swift
//  ACON-iOS
//
//  Created by 김유림 on 7/16/25.
//

import UIKit

class SpotTypeSelectionViewController: BaseUploadInquiryViewController {

    // MARK: - UI Properties

    private let restaurantButton = ACButton(style: GlassConfigButton(glassmorphismType: .buttonGlassDefault, buttonType: .both_10_t4R),
                                            title: StringLiterals.SpotUpload.restaurant)
    
    private let cafeButton = ACButton(style: GlassConfigButton(glassmorphismType: .buttonGlassDefault, buttonType: .both_10_t4R),
                                      title: StringLiterals.SpotUpload.cafe)


    // MARK: - Properties

    override var contentViews: [UIView] {
        [restaurantButton, cafeButton]
    }

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
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        [restaurantButton, cafeButton].forEach {
            $0.refreshButtonBlurEffect(.buttonGlassDefault)
        }
    }


    // MARK: - UI Setting

    override func setLayout() {
        restaurantButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(24 * ScreenUtils.widthRatio)
            $0.height.equalTo(48)
        }
        
        cafeButton.snp.makeConstraints {
            $0.top.equalTo(restaurantButton.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(24 * ScreenUtils.widthRatio)
            $0.height.equalTo(48)
        }
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
        updatePagingButtonStates()
    }

    @objc
    func tappedCafeButton() {
        viewModel.spotType = .cafe
        updatePagingButtonStates()
    }

}
