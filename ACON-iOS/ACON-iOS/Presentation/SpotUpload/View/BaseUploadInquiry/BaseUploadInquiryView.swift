//
//  SpotUploadChildBaseView.swift
//  ACON-iOS
//
//  Created by 김유림 on 7/16/25.
//

import UIKit

final class BaseUploadInquiryView: BaseView {

    // MARK: - UI Properties

    private let requirementLabel = UILabel()

    private let titleLabel = UILabel()

    let captionLabel = UILabel()

    let contentView = UIView()


    // MARK: - Properties

    let requirement: RequirementType

    let title: String

    let caption: String?


    // MARK: - init

    init(requirement: RequirementType, title: String, caption: String? = nil) {
        self.requirement = requirement
        self.title = title
        self.caption = caption

        super.init(frame: .zero)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - Lifecycle

    override func setHierarchy() {
        super.setHierarchy()

        self.addSubviews(requirementLabel,
                         titleLabel,
                         captionLabel,
                         contentView)
    }

    override func setLayout() {
        super.setLayout()

        requirementLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40)
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.horizontalInset)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(requirementLabel.snp.bottom).offset(4)
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.horizontalInset)
        }

        if caption == nil {
            contentView.snp.makeConstraints {
                $0.top.equalTo(titleLabel.snp.bottom).offset(32)
                $0.bottom.horizontalEdges.equalToSuperview()
            }
        } else {
            captionLabel.snp.makeConstraints {
                $0.top.equalTo(titleLabel.snp.bottom).offset(10)
                $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.horizontalInset)
            }

            contentView.snp.makeConstraints {
                $0.top.equalTo(captionLabel.snp.bottom).offset(32)
                $0.bottom.horizontalEdges.equalToSuperview()
            }
        }
    }

    override func setStyle() {
        super.setStyle()

        requirementLabel.setLabel(text: requirement.text, style: .b1R, color: requirement.color)

        titleLabel.setLabel(text: title, style: .h3SB, color: .acWhite)
        
        if let caption {
            captionLabel.setLabel(text: caption, style: .t5R, color: .gray500)
        }
    }

}
