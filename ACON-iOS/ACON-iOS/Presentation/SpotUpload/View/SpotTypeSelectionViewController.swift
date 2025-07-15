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


    // MARK: - init

    init() {
        super.init(requirement: .required,
                   title: StringLiterals.SpotUpload.isThisRestaurantOrCafe,
                   caption: StringLiterals.SpotUpload.brunchIsCafe)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - Lifecycle

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

