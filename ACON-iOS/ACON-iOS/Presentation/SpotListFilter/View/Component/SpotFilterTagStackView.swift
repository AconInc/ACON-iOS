//
//  SpotFilterTagStackView.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/16/25.
//

import UIKit

class SpotFilterTagStackView: UIStackView {
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setStyle()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStyle() {
        self.axis = .horizontal
        self.spacing = 8
    }
    
}


// MARK: - StackView Control Methods

extension SpotFilterTagStackView {
    
    // MARK: - Internal Methods
    
    func addTagButtons(titles: [String]) {
        for title in titles {
            let button = FilterTagButton()
            button.setAttributedTitle(text: title, style: .b1R)
            self.addArrangedSubview(button)
        }
        
        addEmptyView()
    }
    
    func switchTagButtons(titles: [String]) {
        clearStackView()
        
        for title in titles {
            let button = FilterTagButton()
            button.setAttributedTitle(text: title, style: .b1R)
            self.addArrangedSubview(button)
        }
        
        addEmptyView()
    }
    
    func resetTagSelection() {
        self.arrangedSubviews.forEach { view in
            let button = view as? FilterTagButton ?? UIButton()
            button.isSelected = false
        }
    }
    
    
    // MARK: - Private Methods
    
    private func clearStackView() {
        self.arrangedSubviews.forEach { view in
            self.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
    
    private func addEmptyView() {
        self.addArrangedSubview(PriorityLowEmptyView())
    }
    
}
