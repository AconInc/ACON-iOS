//
//  SpotSortSelectionViewController.swift
//  ACON-iOS
//
//  Created by 김유림 on 7/16/25.
//

import UIKit

class SpotUploadSearchViewController: BaseUploadInquiryViewController {

    // MARK: - UI Properties

    private let textField = ACTextField(icon: .icSearch,
                                        borderWidth: 0,
                                        cornerRadius: 10,
                                        doneButton: false,
                                        backgroundGlassType: .textfieldGlass)


    // MARK: - Properties

    override var contentViews: [UIView] {
        [textField]
    }


    // MARK: - init

    init() {
        super.init(requirement: .required, title: StringLiterals.SpotUpload.SearchThePlaceToRegister)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - UI Setting

    override func setLayout() {
        textField.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16 * ScreenUtils.widthRatio)
            $0.height.equalTo(38)
        }
    }

}
