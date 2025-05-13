//
//  SpotDetailSideButton.swift
//  ACON-iOS
//
//  Created by 김유림 on 5/14/25.
//

import UIKit

class SpotDetailSideButton: UIView {

    // MARK: - enum

    enum SideButtonType {
        case menu, share, more

        var text: String {
            switch self {
            case .menu: return "메뉴판"
            case .share: return "공유"
            case .more: return "더보기"
            }
        }

        var image: UIImage {
            switch self {
            case .menu: return .icMenu
            case .share: return .icShare
            case .more: return .icEllipsis
            }
        }
    }


    // MARK: - Property & Initializer

    let type: SideButtonType

    private let imageView = UIImageView()
    private let label = UILabel()
    let button = UIButton()

    init(_ buttonType: SideButtonType) {
        self.type = buttonType

        super.init(frame: .zero)

        setHierarchy()
        setLayout()
        setStyle()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


// MARK: - UI Setting Methods

extension SpotDetailSideButton {

    func setHierarchy() {
        self.addSubviews(imageView, label, button)
    }
    
    func setLayout() {
        self.snp.makeConstraints {
            $0.width.equalTo(36)
            $0.height.equalTo(58)
        }

        imageView.snp.makeConstraints {
            $0.size.equalTo(36)
            $0.top.centerX.equalToSuperview()
        }

        label.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
        }

        button.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func setStyle() {
        imageView.do {
            $0.image = type.image
            $0.contentMode = .scaleAspectFit
            $0.layer.shadowColor = UIColor.acBlack.cgColor
            $0.layer.shadowOpacity = 0.5
            $0.layer.shadowOffset = CGSize(width: 0, height: 4)
            $0.layer.shadowRadius = 4
            $0.layer.masksToBounds = false
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
