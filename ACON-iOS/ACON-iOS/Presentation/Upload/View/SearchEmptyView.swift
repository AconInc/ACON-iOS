//
//  SearchEmptyView.swift
//  ACON-iOS
//
//  Created by Jaehyun Ahn on 1/24/25.
//

import UIKit

import Then
import SnapKit

class SearchEmptyView: BaseView {
    
    // MARK: - UI Components
    
    private let imageView: UIImageView = UIImageView()
    private let textLabel: UILabel = UILabel()

    override func setStyle() {
        super.setStyle()
        
        imageView.do {
            $0.image = .icError1
            $0.contentMode = .scaleAspectFit
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        textLabel.do {
            $0.setLabel(text: "앗! 일치하는 장소가 없어요.", style: .s1, color: .gray400, alignment: .center)
        }
        
    }
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.addSubviews(imageView,textLabel)
    }
    
    override func setLayout() {
        super.setLayout()
        
        imageView.snp.makeConstraints{
            $0.center.equalToSuperview()
            $0.size.equalTo(104)
        }
        
        textLabel.snp.makeConstraints{
            $0.top.equalTo(imageView.snp.bottom).offset(18)
            $0.centerX.equalToSuperview()
        }
    }
    
}
