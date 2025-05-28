//
//  SpotDetailSideButton.swift
//  ACON-iOS
//
//  Created by 김유림 on 5/14/25.
//

import UIKit

class SpotDetailSideButton: UIView {

    // MARK: - Property & Initializer

    let type: SideButtonType
    var isSelected: Bool = false {
        didSet {
            imageView.image = isSelected ? type.selectedImage : type.defaultImage
        }
    }

    private let imageView = UIImageView()
    private let label = UILabel()

    init(_ buttonType: SideButtonType) {
        self.type = buttonType

        super.init(frame: .zero)

        setHierarchy()
        setLayout()
        setStyle()
        setGesture()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


// MARK: - UI Setting Methods

private extension SpotDetailSideButton {

    func setHierarchy() {
        self.addSubviews(imageView, label)
    }

    func setLayout() {
        self.snp.makeConstraints {
            $0.width.equalTo(36)
        }

        imageView.snp.makeConstraints {
            $0.size.equalTo(36 * ScreenUtils.heightRatio)
            $0.top.centerX.equalToSuperview()
        }

        label.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(min(4, 4 * ScreenUtils.heightRatio))
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }

    func setStyle() {
        imageView.do {
            $0.image = isSelected ? type.selectedImage : type.defaultImage
            $0.contentMode = .scaleAspectFit

            $0.layer.do {
                $0.shadowColor = UIColor.acBlack.cgColor
                $0.shadowOpacity = 0.16
                $0.shadowOffset = CGSize(width: 0, height: 4)
                $0.shadowRadius = 4
                $0.masksToBounds = false
            }
        }

        label.do {
            let attrText = type.text.attributedString(.c1SB)
            let mutable = NSMutableAttributedString(attributedString: attrText)

            // shadow 추가
            let shadow = NSShadow()
            shadow.shadowColor = UIColor.acBlack.withAlphaComponent(0.16)
            shadow.shadowOffset = CGSize(width: 0, height: 4)
            shadow.shadowBlurRadius = 4

            mutable.addAttribute(.shadow, value: shadow, range: NSRange(location: 0, length: mutable.length))

            $0.attributedText = mutable
            $0.textAlignment = .center
        }
    }

}


// MARK: - Gesture Setting Methods

private extension SpotDetailSideButton {

    func setGesture() {
        let menuTapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedSelf))
        self.addGestureRecognizer(menuTapGesture)
    }

    @objc
    func tappedSelf() {
        isSelected.toggle()
        print("isSelected: \(isSelected)")
    }

}


// MARK: - SideButtonType

extension SpotDetailSideButton {

    enum SideButtonType {
        case menu, bookmark, share

        var text: String {
            switch self {
            case .menu: return "메뉴판"
            case .bookmark: return "북마크"
            case .share: return "공유"
            }
        }

        var defaultImage: UIImage {
            switch self {
            case .menu: return .icMenu
            case .bookmark: return .icBookmarkLine
            case .share: return .icShare
            }
        }

        var selectedImage: UIImage {
            switch self {
            case .menu: return .icMenu
            case .bookmark: return .icBookmarkFill
            case .share: return .icShare
            }
        }
    }

}
