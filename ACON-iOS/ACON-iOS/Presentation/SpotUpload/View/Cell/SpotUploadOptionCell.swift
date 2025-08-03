//
//  SpotUploadOptionCell.swift
//  ACON-iOS
//
//  Created by 김유림 on 7/23/25.
//

import UIKit

class SpotUploadOptionCell: BaseCollectionViewCell {

    // MARK: - UI Properties

    private let optionButton = SpotUploadOptionButton(title: "")


    // MARK: - Properties

    /// 그냥 isSelected 사용 시 didSelectItems 때 무조건 true 돼서 싱크 안 맞음
    var isButtonSelected: Bool {
        didSet {
            self.optionButton.isSelected = isButtonSelected
        }
    }

    override var isSelected: Bool {
        didSet {
            self.optionButton.isSelected = isButtonSelected
        }
    }


    // MARK: - init

    override init(frame: CGRect) {
        self.isButtonSelected = false

        super.init(frame: frame)
    }

    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - UI Settings

    override func setHierarchy() {
        super.setHierarchy()

        self.addSubview(optionButton)
    }

    override func setLayout() {
        super.setLayout()

        optionButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    override func setStyle() {
        super.setStyle()

        self.backgroundColor = .clear
        self.isSelected = false
        optionButton.isUserInteractionEnabled = false
    }

}


// MARK: - Internal Methods

extension SpotUploadOptionCell {

    func bindData(_ title: String) {
        optionButton.updateTitle(title)
    }

}
