//
//  SpotNoImageContentView.swift
//  ACON-iOS
//
//  Created by 김유림 on 5/23/25.
//

import UIKit

class SpotNoImageContentView: BaseView {

    // MARK: - Properties

    private let contentStyle: ContentStyleType

    private let iconImageView = UIImageView()
    private let descriptionLabel = UILabel()


    // MARK: - init

    init(_ contentStyle: ContentStyleType) {
        self.contentStyle = contentStyle

        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - UI Setting Methods

    override func setHierarchy() {
        super.setHierarchy()

        self.addSubviews(iconImageView, descriptionLabel)
    }

    override func setLayout() {
        super.setLayout()

        switch contentStyle {
        case .descriptionOnly:
            descriptionLabel.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        case .iconAndDescription:
            iconImageView.snp.makeConstraints {
                $0.top.equalToSuperview()
                $0.centerX.equalToSuperview()
                $0.size.equalTo(36)
            }

            descriptionLabel.snp.makeConstraints {
                $0.top.equalTo(iconImageView.snp.bottom).offset(12)
                $0.horizontalEdges.equalToSuperview()
                $0.bottom.equalToSuperview()
            }
        }
    }

    override func setStyle() {
        self.backgroundColor = .clear

        if contentStyle == .iconAndDescription {
            iconImageView.do {
                $0.image = .icAcornGlass
                $0.contentMode = .scaleAspectFit
            }
        }
    }


    // MARK: - Internal Method
    
    func setDescription(_ spotImageStatusType: SpotImageStatusType) {
        descriptionLabel.setLabel(text: spotImageStatusType.description,
                                  style: .b1SB,
                                  color: .gray50,
                                  alignment: .center)
    }

}


// MARK: - Type

extension SpotNoImageContentView {

    enum ContentStyleType {
        case descriptionOnly
        case iconAndDescription
    }

}
