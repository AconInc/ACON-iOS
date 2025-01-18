//
//  SpotListView.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/12/25.
//

import UIKit

class SpotListView: BaseView {
    
    // MARK: - UI Properties
    
    let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
    private let footerLabel = UILabel()
    
    private let floatingButtonStack = UIStackView()
    
    private lazy var floatingFilterButton = makeFloatingButton(image: .icFilterW24)
    
    private lazy var floatingLocationButton = makeFloatingButton(image: .icMyLocationW24)
    
    
    // MARK: - UI Property Sizes
    
    private let floatingButtonSize: CGFloat = 36
    
    
    // MARK: - LifeCycles
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.addSubviews(
            footerLabel,
            collectionView,
            floatingButtonStack)
        
        floatingButtonStack.addArrangedSubviews(
            floatingFilterButton,
            floatingLocationButton)
    }
    
    override func setLayout() {
        super.setLayout()
        
        footerLabel.snp.makeConstraints {
            $0.bottom.equalTo(self.safeAreaLayoutGuide).offset(-40)
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(18)
            $0.horizontalEdges.bottom.equalTo(self.safeAreaLayoutGuide)
        }
        
        floatingButtonStack.snp.makeConstraints {
            $0.trailing.equalTo(self.safeAreaLayoutGuide).offset(-20)
            $0.bottom.equalTo(self.safeAreaLayoutGuide).offset(-16)
        }
    }
    
    override func setStyle() {
        super.setStyle()
        
        setFooterLabel()
        setCollectionView()
        setFloatingButtons()
    }
    
}


// MARK: - UI Settings

private extension SpotListView {
    
    func setFooterLabel() {
        let text = StringLiterals.SpotList.footerText
        footerLabel.setLabel(
            text: text,
            style: .b4,
            color: .gray5,
            alignment: .center
        )
    }
    
    func setCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        // NOTE: itemSize는 Controller에서 설정합니다. (collectionView의 height이 필요하기 때문)
        flowLayout.minimumLineSpacing = SpotListItemSizeType.minimumLineSpacing.value
        flowLayout.scrollDirection = .vertical
        
        collectionView.do {
            $0.backgroundColor = .clear
            $0.setCollectionViewLayout(flowLayout, animated: true)
        }
    }
    
    func setFloatingButtons() {
        floatingButtonStack.do {
            $0.axis = .vertical
            $0.spacing = 8
        }
    }
    
    func makeFloatingButton(image: UIImage?) -> UIButton {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.image = image
        config.baseBackgroundColor = .glaB30 // TODO: blur로 바꾸기
        config.background.cornerRadius = floatingButtonSize / 2
        button.configuration = config
        button.snp.makeConstraints {
            $0.size.equalTo(floatingButtonSize)
        }
        return button
    }
}


// MARK: - Binding

extension SpotListView {
    
    func hideFooterLabel(isHidden: Bool) {
        footerLabel.isHidden = isHidden
        print("hideFooterLabel called.")
    }
    
}
