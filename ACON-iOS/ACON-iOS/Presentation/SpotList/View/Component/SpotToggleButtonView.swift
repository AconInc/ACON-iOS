//
//  SpotToggleButtonView.swift
//  ACON-iOS
//
//  Created by 김유림 on 5/5/25.
//

import UIKit

class SpotToggleButtonView: GlassmorphismView {

    var selectedType: ObservablePattern<SpotType> = ObservablePattern(.restaurant)

    private let selectorView = UIView()
    private let restaurantButton = UIButton()
    private let cafeButton = UIButton()

    private let width: CGFloat = 150
    private let height: CGFloat = 36
    private let buttonWidth: CGFloat = 45
    private let selectorWidth: CGFloat = 77
    private let horizontalPadding: CGFloat = 16
    private let spacing: CGFloat = 28

    init() {
        super.init(.buttonGlassDefault)

        addTarget()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        addTarget()
    }


    // MARK: - UI Settings
    
    override func setHierarchy() {
        super.setHierarchy()

        self.addSubviews(selectorView, restaurantButton, cafeButton)
    }
    
    override func setLayout() {
        super.setLayout()

        self.snp.makeConstraints {
            $0.width.equalTo(width)
            $0.height.equalTo(height)
        }

        selectorView.snp.makeConstraints {
            $0.width.equalTo(selectorWidth)
            $0.height.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
        }

        restaurantButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(horizontalPadding)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(height)
            $0.width.equalTo(buttonWidth)
        }

        cafeButton.snp.makeConstraints {
            $0.leading.equalTo(restaurantButton.snp.trailing).offset(spacing)
            $0.trailing.equalToSuperview().inset(horizontalPadding)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(height)
            $0.width.equalTo(buttonWidth)
        }
    }

    override func setStyle() {
        super.setStyle()

        self.do {
            $0.layer.cornerRadius = height / 2
            $0.clipsToBounds = true
        }

        selectorView.do {
            $0.backgroundColor = .acWhite
            $0.layer.cornerRadius = height / 2
            $0.clipsToBounds = true
        }

        restaurantButton.do {
            $0.isSelected = selectedType.value == .restaurant
            $0.setImage(.icRestaurant, for: .normal)
            $0.setAttributedTitle(
                StringLiterals.SpotList.restaurant.attributedString(.c1SB, .gray900),
                for: .selected
            )
            $0.setAttributedTitle(
                StringLiterals.SpotList.restaurant.attributedString(.c1SB, .gray300),
                for: .normal
            )
        }

        cafeButton.do {
            $0.isSelected = selectedType.value == .cafe
            $0.setImage(.icCafe, for: .normal)
            $0.setAttributedTitle(
                StringLiterals.SpotList.cafe.attributedString(.c1SB, .gray900),
                for: .selected
            )
            $0.setAttributedTitle(
                StringLiterals.SpotList.cafe.attributedString(.c1SB, .gray300),
                for: .normal
            )
        }

        updateSelectorPosition()
    }

    private func addTarget() {
        restaurantButton.addTarget(self,
                                   action: #selector(buttonTapped),
                                   for: .touchUpInside)

        cafeButton.addTarget(self,
                             action: #selector(buttonTapped),
                             for: .touchUpInside)
    }

}


// MARK: - Objc function

private extension SpotToggleButtonView {

    @objc func buttonTapped(_ sender: UIButton) {
        let isRestaurantButtonSelected = sender == restaurantButton

        selectedType.value = isRestaurantButtonSelected ? .restaurant : .cafe

        restaurantButton.isSelected = isRestaurantButtonSelected
        cafeButton.isSelected = !isRestaurantButtonSelected

        updateSelectorPosition()
    }

}


// MARK: - Helper

private extension SpotToggleButtonView {

    func updateSelectorPosition() {
        let cafeX = width - selectorWidth
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.selectorView.frame = CGRect(
                x: self?.selectedType.value == .restaurant ? 0 : cafeX,
                y: 0,
                width: self?.selectorWidth ?? 77,
                height: self?.height ?? 36
            )
        }
    }

}
