//
//  SpotListErrorView.swift
//  ACON-iOS
//
//  Created by 김유림 on 2/20/25.
//

import UIKit

enum SpotListErrorStyleType {

    case imageTitle, imageTitleButton

}

class SpotListErrorView: BaseView {

    // MARK: - UI Properties

    private let styleType: SpotListErrorStyleType

    private let glassView = GlassmorphismView(.backgroundGlass)

    private let container = UIView()

    private let errorImageView = UIImageView()

    private let descriptionLabel = UILabel()

    let confirmButton = UIButton()

    init(_ styleType: SpotListErrorStyleType) {
        self.styleType = styleType

        super.init(frame: .zero)
    }

    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - UI Setting Methods

    override func setHierarchy() {
        super.setHierarchy()

        self.addSubviews(glassView, container)

        container.addSubviews(
            errorImageView,
            descriptionLabel,
            confirmButton
        )
    }

    override func setLayout() {
        super.setLayout()

        glassView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        container.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        errorImageView.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
            $0.size.equalTo(36)
        }

        switch styleType {
        case .imageTitle:
            descriptionLabel.snp.makeConstraints {
                $0.top.equalTo(errorImageView.snp.bottom).offset(10)
                $0.centerX.equalTo(errorImageView)
                $0.bottom.equalToSuperview()
            }
        case .imageTitleButton:
            descriptionLabel.snp.makeConstraints {
                $0.top.equalTo(errorImageView.snp.bottom).offset(10)
                $0.centerX.equalTo(errorImageView)
            }

            confirmButton.snp.makeConstraints{
                $0.top.equalTo(descriptionLabel.snp.bottom).offset(12)
                $0.bottom.equalToSuperview()
                $0.centerX.equalTo(errorImageView)
            }
        }
    }

    override func setStyle() {
        self.backgroundColor = .clear

        glassView.isHidden = true
    }

}


// MARK: - Internal Methods

extension SpotListErrorView {

    func setStyle(errorImage: UIImage = .icError1,
                  errorMessage: String? = nil,
                  buttonTitle: String? = nil,
                  backgroundColor: UIColor = .gray900,
                  glassMorphismtype: GlassmorphismType? = nil) {
        errorImageView.do {
            $0.image = errorImage
            $0.contentMode = .scaleAspectFit
        }

        if let errorMessage = errorMessage {
            descriptionLabel.do {
                $0.isHidden = false
                $0.setLabel(text: errorMessage,
                            style: .b1R,
                            color: .gray200,
                            alignment: .center)
            }
        } else {
            descriptionLabel.isHidden = true
        }
        
        if let buttonTitle = buttonTitle {
            confirmButton.setAttributedTitle(
                text: buttonTitle,
                style: .b1SB,
                color: .labelAction)
        } else {
            confirmButton.isHidden = true
        }
        
        if let glassType = glassMorphismtype {
            glassView.isHidden = false
            glassView.setGlassMorphism(glassType)
        }
    }

}
