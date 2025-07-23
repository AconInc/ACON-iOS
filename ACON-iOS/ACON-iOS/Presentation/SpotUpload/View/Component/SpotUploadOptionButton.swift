//
//  SpotUploadOptionButton.swift
//  ACON-iOS
//
//  Created by 김유림 on 7/19/25.
//

import UIKit

final class SpotUploadOptionButton: UIButton {

    // MARK: - Properties

    private let title: String


    // MARK: - UI Properties

    private let checkImageView = UIImageView()
    private var glassBorder = GlassmorphismView(.buttonGlassSelected)
    private let glassBorderAttributes = GlassBorderAttributes(width: 1,
                                                              cornerRadius: 10,
                                                              glassmorphismType: .buttonGlassSelected)


    // MARK: - init

    init(title: String) {
        self.title = title

        super.init(frame: .zero)

        setHierarchy()
        setLayout()
        setStyle()
        setConfigurationUpdateHandler()
    }


    // MARK: - UI Setting Methods

    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setHierarchy() {
        self.addSubview(checkImageView)
    }

    private func setLayout() {
        checkImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(14)
            $0.centerY.equalToSuperview().inset(12)
            $0.size.equalTo(24)
        }
    }

    private func setStyle() {
        checkImageView.do {
            $0.image = .icCheckmark
            $0.contentMode = .scaleAspectFit
            $0.tintColor = isSelected ? .acWhite : .gray700
        }

        var config = UIButton.Configuration.filled()
        config.background.strokeWidth = 1
        config.background.cornerRadius = 10
        config.contentInsets = .init(top: 12, leading: 20, bottom: 12, trailing: 20)
        config.attributedTitle = AttributedString(title.attributedString(.t4R))
        config.titleAlignment = .leading

        self.do {
            $0.configuration = config
            $0.contentHorizontalAlignment = .leading
        }
    }

    private func setConfigurationUpdateHandler() {
        let defaultBgColor = UIColor(red: 0.255, green: 0.255, blue: 0.255, alpha: 1)
        let selectedBgColor = UIColor(red: 0.349, green: 0.349, blue: 0.349, alpha: 1)
        let selectedBorderColor = UIColor(red: 0.545, green: 0.545, blue: 0.545, alpha: 1)

        self.configurationUpdateHandler = { [weak self] button in
            switch button.state {
            case .selected:
                button.configuration?.baseBackgroundColor = selectedBgColor
                button.configuration?.background.strokeColor = selectedBorderColor
                self?.checkImageView.tintColor = .acWhite
            default:
                button.configuration?.baseBackgroundColor = defaultBgColor
                button.configuration?.background.strokeColor = .clear
                self?.checkImageView.tintColor = .gray700
            }
        }
    }

}
