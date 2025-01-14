//
//  RestaurantOptionStackView.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/14/25.
//

import UIKit

class SpotFilterTagButtonStackView: UIStackView {
    
    // MARK: - UI Properties
    
    private let firstLineStackView = UIStackView()
    private let secondLineStackView = UIStackView()
    
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setHierarchy()
        setStyle()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setHierarchy() {
        self.addArrangedSubviews(firstLineStackView,
                                 secondLineStackView)
    }
    
    private func setStyle() {
        self.alignment = .leading
        self.axis = .vertical
        self.spacing = 5
        
        firstLineStackView.axis = .horizontal
        firstLineStackView.spacing = 5
        
        secondLineStackView.axis = .horizontal
        secondLineStackView.spacing = 5
    }
    
}


// MARK: - StackView Control Methods

extension SpotFilterTagButtonStackView {
    
    func addTagButton(to line: FilterTagButtonStackLineType, button: UIButton) {
        switch line {
        case .first:
            firstLineStackView.addArrangedSubview(button)
        case .second:
            secondLineStackView.addArrangedSubview(button)
        }
    }
    
    func clearStackView() {
        clearStackView(from: firstLineStackView)
        clearStackView(from: secondLineStackView)
    }
    
    func addEmptyView() {
        // TODO: [Fix] priority low로 자동으로 작게 설정되지 않는 듯. [프랜차이즈 제외]가 2줄로 됨
        let emptyView = UIView()
        emptyView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        firstLineStackView.addArrangedSubview(emptyView)
        secondLineStackView.addArrangedSubview(emptyView)
    }
    
    private func clearStackView(from stackView: UIStackView) {
        stackView.arrangedSubviews.forEach { view in
            stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
    
}
