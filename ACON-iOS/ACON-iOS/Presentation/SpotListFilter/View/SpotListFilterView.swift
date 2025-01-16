//
//  SpotListFilterView.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/14/25.
//

import UIKit

class SpotListFilterView: BaseView {
    
    // MARK: - Properties
    
    
    
    // MARK: - UI Properties
    
    private let stackView = UIStackView()
    
    private let emptyView = PriorityLowEmptyView()
    
    
    // [Spot section]: 방문 장소 (restaurant, cafe)
    
    private let spotSectionStackView = UIStackView()
    
    private let spotSectionTitleLabel = UILabel()

    lazy var segmentedControl = CustomSegmentedControl()
    
    private let spotTagStackView = UIStackView()
    
    let firstLineSpotTagStackView = SpotFilterTagStackView()
    
    let secondLineSpotTagStackView = SpotFilterTagStackView()
    
    
    // [Companion section]: 함께 하는 사람 (restaurant)
    
    private let companionSectionStackView = UIStackView()
    
    private let companionSectionTitleLabel = UILabel()
    
    let companionTagStackView = SpotFilterTagStackView()
    
    
    // [Visit purpose]: 방문 목적 (cafe)
    
    private let visitPurposeSectionStackView = UIStackView()
    
    private let visitPurposeSectionTitleLabel = UILabel()
    
    let visitPurposeTagStackView = SpotFilterTagStackView()
    
    
    
    
    // TODO: 방문 목적, 도보 가능 거리, 가격대
    
    
    // MARK: - Lifecycle
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.addSubviews(stackView)
        
        stackView.addArrangedSubviews(spotSectionStackView,
                                      companionSectionStackView,
                                      visitPurposeSectionStackView,
                                      emptyView)
        
        // [Spot section]
        
        spotSectionStackView.addArrangedSubviews(spotSectionTitleLabel,
                                                 segmentedControl,
                                                 spotTagStackView)
        
        spotTagStackView.addArrangedSubviews(firstLineSpotTagStackView,
                                             secondLineSpotTagStackView)
        
        
        // [Companion section]
        
        companionSectionStackView.addArrangedSubviews(companionSectionTitleLabel,
                                                      companionTagStackView)
        
        
        // [Visit purpose section]
        
        visitPurposeSectionStackView.addArrangedSubviews(visitPurposeSectionTitleLabel,
                                                         visitPurposeTagStackView)
    }
    
    override func setLayout() {
        super.setLayout()
        
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(ScreenUtils.heightRatio * 41)
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.widthRatio * 20)
        }
        
        segmentedControl.snp.makeConstraints {
            $0.height.equalTo(ScreenUtils.heightRatio * 37)
        }
    }
    
    override func setStyle() {
        super.setStyle()
        
        stackView.do {
            $0.axis = .vertical
            $0.spacing = 32
        }
        
        
        // [Spot section]
        
        setSpotSectionUI()
        
        setCompanionSectionUI()
        
        setVisitPurposeSectionUI()
        
        // TODO: 추후 추가 예정
    }
    
}


// MARK: - UI Settings

private extension SpotListFilterView {
    
    // MARK: - (Spot section)
    
    func setSpotSectionUI() {
        spotSectionStackView.do {
            $0.axis = .vertical
            $0.spacing = 12
        }
        
        spotSectionTitleLabel.do {
            $0.setLabel(text: StringLiterals.SpotListFilter.spotSection,
                        style: .s2)
        }
        
        spotTagStackView.do {
            $0.alignment = .leading
            $0.axis = .vertical
            $0.spacing = 5
        }
    }
    
    
    // MARK: - (Companion section)
    
    func setCompanionSectionUI() {
        companionSectionStackView.do {
            $0.axis = .vertical
            $0.spacing = 12
        }
        
        companionSectionTitleLabel.setLabel(
            text: StringLiterals.SpotListFilter.companionSection,
            style: .s2)
        
        let tags: [String] = SpotListFilterModel.Companion.firstLine.map { return $0.text }
        companionTagStackView.addTagButtons(titles: tags)
    }
    
    
    // MARK: - (Visit purpose section)
    
    func setVisitPurposeSectionUI() {
        visitPurposeSectionStackView.do {
            $0.axis = .vertical
            $0.spacing = 12
        }
        
        visitPurposeSectionTitleLabel.setLabel(
            text: StringLiterals.SpotListFilter.visitPurposeSection,
            style: .s2)
        
        let tags: [String] = SpotListFilterModel.VisitPurpose.firstLine.map { return $0.text }
        visitPurposeTagStackView.addTagButtons(titles: tags)
    }
    
}


// MARK: - Internal Methods (Update UI)

extension SpotListFilterView {
    
    func switchSpotTagStack(_ spotType: SpotType) {
        
        // TODO: Model 대신 Type으로 바꾸기
        
        switch spotType {
        case .restaurant:
            let firstLine: [String] = SpotListFilterModel.RestaurantFeature.firstLine.map { return $0.text }
            let secondLine: [String] = SpotListFilterModel.RestaurantFeature.secondLine.map { return $0.text }
            
            firstLineSpotTagStackView.switchTagButtons(titles: firstLine)
            secondLineSpotTagStackView.switchTagButtons(titles: secondLine)
            
        case .cafe:
            let firstLine: [String] = SpotListFilterModel.CafeFeature.firstLine.map { return $0.text }
            let secondLine: [String] = SpotListFilterModel.CafeFeature.secondLine.map { return $0.text }
            
            firstLineSpotTagStackView.switchTagButtons(titles: firstLine)
            secondLineSpotTagStackView.switchTagButtons(titles: secondLine)
        }
    }
    
    func hideCompanionSection(isHidden: Bool) {
        companionSectionStackView.isHidden = isHidden
    }
    
    func hideVisitPurposeSection(isHidden: Bool) {
        visitPurposeSectionStackView.isHidden = isHidden
    }
    
}
