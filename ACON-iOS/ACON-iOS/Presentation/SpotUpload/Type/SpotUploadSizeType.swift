//
//  SpotUploadButtonSizeType.swift
//  ACON-iOS
//
//  Created by 김유림 on 7/26/25.
//

import Foundation

enum SpotUploadSizeType {

    static let height: CGFloat = 48

    enum LongOptionButton {

        static let height: CGFloat = 48

        static let horizontalInset: CGFloat = 24 * ScreenUtils.widthRatio

        static let lineSpacing: CGFloat = 12

    }

    enum ShortOptionButton {

        static let width: CGFloat = (ScreenUtils.width - ShortOptionButton.horizontalInset * 2 - 8) / 2

        static let height: CGFloat = 48

        static let horizontalInset: CGFloat = 20 * ScreenUtils.widthRatio

        static let lineSpacing: CGFloat = 10

        static let itemInterSpacing: CGFloat = 8

    }

    enum TextField {

        static let height: CGFloat = 44

        static let horizontalInset: CGFloat = 16 * ScreenUtils.widthRatio

    }

}
