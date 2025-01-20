//
//  SpotFilterTagStackView.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/16/25.
//

import UIKit

class SpotFilterTagStackView: UIStackView {
    
    // MARK: - UI Properties
    
    private var tagButtons: [UIButton] = []
    
    
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
        self.spacing = 5
    }
    
}


// MARK: - StackView Control Methods

extension SpotFilterTagStackView {
    
    // MARK: - Internal Methods
    
    func addTagButtons(titles: [String]) {
        for title in titles {
            let button = FilterTagButton()
            button.setAttributedTitle(text: title, style: .b3)
            tagButtons.append(button)
            self.addArrangedSubview(button)
        }
        
        addEmptyView()
    }
    
    func switchTagButtons(titles: [String]) {
        clearStackView()
        
        for title in titles {
            let button = FilterTagButton()
            button.setAttributedTitle(text: title, style: .b3)
            self.addArrangedSubview(button)
        }
        
        addEmptyView()
    }
    
    func resetTagSelection() {
        tagButtons.forEach {
            $0.isSelected = false
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
