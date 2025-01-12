//
//  SpotListCollectionViewCell.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/12/25.
//

import UIKit

class SpotListCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - UI Properties
    
    private let bgImage = UIImageView()
    
    private let matchPercentageLabel = UILabel()
    private let matchPercentageView = UIView()
    
    private let stackView = UIStackView()
    private let categoryLabel = UILabel()
    private let spotNameLabel = UILabel()
    private let timeInfoStackView = UIStackView()
    private let personImageView = UIImageView()
    private let timeLabel = UILabel()
    
    
    // MARK: - Life Cycle
    
    override func setHierarchy() {}
    
    override func setLayout() {}
    
    override func setStyle() {
        self.backgroundColor = .red
    }
    
}
