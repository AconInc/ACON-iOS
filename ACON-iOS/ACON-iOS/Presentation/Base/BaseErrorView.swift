//
//  BaseNetworkErrorView.swift
//  ACON-iOS
//
//  Created by 김유림 on 2/20/25.
//

import UIKit

class BaseErrorView: BaseView {

    // MARK: - UI Properties

    private let container = UIView()

    private let errorImageView = UIImageView()

    private let descriptionLabel = UILabel()

    let confirmButton = UIButton()


    // MARK: - UI Setting Methods

    override func setHierarchy() {
        super.setHierarchy()

        self.addSubview(container)

        container.addSubviews(
            errorImageView,
            descriptionLabel,
            confirmButton
        )
    }

    override func setLayout() {
        super.setLayout()

        container.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        errorImageView.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
            $0.size.equalTo(36)
        }

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


// MARK: - Internal Methods

extension BaseErrorView {

    func setStyle(errorImage: UIImage = .icError1,
                  errorMessage: String?,
                  buttonTitle: String?) {
        errorImageView.do {
            $0.image = errorImage
            $0.contentMode = .scaleAspectFit
        }

        if let errorMessage = errorMessage {
            descriptionLabel.do {
                $0.isHidden = false
                $0.setLabel(text: errorMessage,
                            style: .b1(.regular),
                            color: .gray200)
            }
        } else {
            descriptionLabel.isHidden = true
        }
        
        if let buttonTitle = buttonTitle {
            confirmButton.setAttributedTitle(
                text: buttonTitle,
                style: .b1(.semibold),
                color: .labelAction)
        } else {
            confirmButton.isHidden = true
        }
        
    }

}
