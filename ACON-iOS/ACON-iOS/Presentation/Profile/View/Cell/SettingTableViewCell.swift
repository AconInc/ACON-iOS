//
//  SettingTableViewCell.swift
//  ACON-iOS
//
//  Created by 이수민 on 2/13/25.
//

import UIKit

final class SettingTableViewCell: UITableViewCell {

    private let settingImageView: UIImageView = UIImageView()

    private let titleLabel: UILabel = UILabel()

    private let versionLabel: UILabel = UILabel()

    private let updateLabel: UILabel = UILabel()

    private let arrowImageView: UIImageView = UIImageView()

    private let viewModel: SettingViewModel = SettingViewModel()


    // MARK: - Initializer

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setHierarchy()
        setLayout()
        setStyle()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        self.selectionStyle = .none
    }


    // MARK: - UI Setting Methods

    func setHierarchy() {
        self.contentView.addSubviews(settingImageView, titleLabel, arrowImageView, updateLabel, versionLabel)
    }

    func setLayout() {
        settingImageView.snp.makeConstraints {
            $0.leading.verticalEdges.equalToSuperview()
            $0.size.equalTo(32)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(40)
        }
        
        versionLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        
        updateLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(arrowImageView.snp.leading).offset(-4)
        }
        
        arrowImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.size.equalTo(20)
        }
    }

    func setStyle() {
        self.backgroundColor = .gray900
        
        settingImageView.do {
            $0.contentMode = .scaleAspectFit
        }
        
        versionLabel.do {
            $0.isHidden = true
            $0.setLabel(text: "최신버전",
                        style: .s2,
                        color: .gray400,
                        alignment: .right)
        }
        
        updateLabel.do {
            $0.isHidden = true
            $0.setLabel(text: "업데이트하러 가기",
                        style: .s2,
                        color: .gray400,
                        alignment: .right)
        }
        
        arrowImageView.do {
            $0.contentMode = .scaleAspectFit
            $0.image = .icArrowRightG
        }
    }

}


// MARK: - bindData

extension SettingTableViewCell {

    func configure(with data: SettingCellModel) {
        settingImageView.image = data.image
        titleLabel.setLabel(text: data.title, style: .s1)
    }

    func bindVersionData() {
        Task {
            let isLatestVersion = await AppVersionManager.shared.checkExactVersion()
            
            DispatchQueue.main.async {
                self.arrowImageView.isHidden = isLatestVersion
                self.versionLabel.isHidden = !isLatestVersion
                self.updateLabel.isHidden = isLatestVersion
            }
        }
    }

}
