//
//  SpotUploadChildBaseViewController.swift
//  ACON-iOS
//
//  Created by 김유림 on 7/16/25.
//

import UIKit

class BaseUploadInquiryViewController: BaseViewController {

    // MARK: - Properties

    let spotUploadInquiryView: BaseUploadInquiryView

    // 하위 뷰에서 override하여 설정
    var contentViews: [UIView] { [] }


    // MARK: - init

    init(requirement: RequirementType, title: String, caption: String? = nil) {
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


    // MARK: - Hierarchy

    override func setHierarchy() {
        super.setHierarchy()

        contentViews.forEach { spotUploadInquiryView.contentView.addSubview($0) }
    }

}
