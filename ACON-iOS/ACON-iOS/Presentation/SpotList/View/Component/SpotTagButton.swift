//
//  SpotTagButton.swift
//  ACON-iOS
//
//  Created by 김유림 on 5/3/25.
//

import UIKit

import SnapKit

class SpotTagButton: UIButton {

    let tagType: SpotTagType

    init(_ tagType: SpotTagType) {
        self.tagType = tagType

        super.init(frame: .zero)

        setLayout()
        setStyle()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


// MARK: - UI Setting Methods

extension SpotTagButton {

    func setLayout() {
        self.snp.makeConstraints {
            $0.width.equalTo(58)
            $0.height.equalTo(24)
        }
    }

    func setStyle() {
        var config = UIButton.Configuration.filled()
        config.baseForegroundColor = .acWhite
        config.contentInsets = .init(top: 3, leading: 3, bottom: 3, trailing: 3)
        config.attributedTitle = AttributedString(tagType.rawValue.attributedString(.c1SB))

        switch tagType {
        case .new:
            config.baseBackgroundColor = .tagNew
        case .local:
            config.baseBackgroundColor = .tagLocal
        case .top:
            config.baseBackgroundColor = .gray900
        case .unknown:
            self.isHidden = true
        }

        self.configuration = config
    }

}
