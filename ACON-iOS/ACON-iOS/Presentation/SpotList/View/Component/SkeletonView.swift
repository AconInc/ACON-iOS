//
//  SkeletonView.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/24/25.
//

import UIKit

class SkeletonView: BaseView {
    
    // MARK: - Properties
    
    private let stackView = UIStackView()
    
    
    // MARK: - Initializer

    override func setHierarchy() {
        super.setHierarchy()
        
        self.addSubviews(stackView)
    }

    override func setLayout() {
        super.setLayout()
        
        stackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
    }
    
    override func setStyle() {
        super.setStyle()
        
        stackView.do {
            $0.axis = .vertical
            $0.spacing = 12
        }
    }
    
    func addContentView() {
        
    }
}
