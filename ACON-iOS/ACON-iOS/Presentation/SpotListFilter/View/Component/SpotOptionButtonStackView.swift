//
//  RestaurantOptionStackView.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/14/25.
//

import UIKit

class SpotOptionButtonStackView: UIStackView {
    
    // MARK: - UI Properties
    
    let firstLineStackView = UIStackView()
    let secondLineStackView = UIStackView()
    
    
    // MARK: - Properties
    
    private let firstLineButtonCount = 5
    private let secondLineButtonCount = 3
    
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setHierarchy()
        setStyle()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setHierarchy() {
        self.addArrangedSubviews(firstLineStackView,
                                 secondLineStackView)
        
        addFilterTagButtons(to: firstLineStackView, number: 5)
        
        addFilterTagButtons(to: secondLineStackView, number: 3)
    }
    
    func setStyle() {
        self.axis = .vertical
        self.spacing = 5
        
        firstLineStackView.axis = .horizontal
        firstLineStackView.spacing = 5
        
        secondLineStackView.axis = .horizontal
        secondLineStackView.spacing = 5
    }
    
}



extension SpotOptionButtonStackView {
    
    func addFilterTagButtons(to stackView: UIStackView, number: Int) {
        for _ in 0..<number {
            stackView.addArrangedSubview(FilterTagButton())
        }
    }
    
}
