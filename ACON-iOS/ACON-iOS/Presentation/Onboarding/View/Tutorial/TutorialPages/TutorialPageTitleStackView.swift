//
//  TutorialPageTitleStackView.swift
//  ACON-iOS
//
//  Created by 김유림 on 8/21/25.
//

import UIKit

class TutorialPageTitleStackView: UIStackView {
    
    // MARK: - Properties

    private var title: String
    private var subTitle: String


    // MARK: - UI Properties

    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()


    // MARK: - init

    init(title: String, subTitle: String) {
        self.title = title
        self.subTitle = subTitle

        super.init(frame: .zero)

        setHierarchy()
        setStyle()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - UI Setting Methods

    private func setHierarchy() {
        self.addArrangedSubviews(titleLabel, subTitleLabel)
    }

    private func setStyle() {
        self.do {
            $0.axis = .vertical
            $0.spacing = 24
        }

        titleLabel.setLabel(text: title, style: .t2SB) // TODO: 폰트시스템 ExtraBold 추가 후 수정
        subTitleLabel.setLabel(text: subTitle, style: .t4SB)
    }

}
