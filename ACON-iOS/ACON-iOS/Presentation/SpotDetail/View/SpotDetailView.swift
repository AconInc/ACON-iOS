//
//  SpotDetailView.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/16/25.
//

import UIKit

import SnapKit
import Then

final class SpotDetailView: BaseView {

    // MARK: - UI Properties
    
    private let scrollView: UIScrollView = UIScrollView()
    
    private let scrollContentView: UIView = UIView()
    
    private let spotDetailImageView: UIImageView = UIImageView()
    
    private let isOpenButton: FilterTagButton = FilterTagButton()
    
    private let isNotOpenButton: FilterTagButton = FilterTagButton()
    
    private let addressImageView: UIImageView = UIImageView()
    
    private let addressLabel: UILabel = UILabel()
    
    private let stickyHeaderView: UIView = UIView()
    
    private let menuLabel: UILabel = UILabel()
    
    private let menuUnderLineView: UIView = UIView()
    
    var menuCollectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
    private let footerView: UIView = UIView()
    
    private let localAcornImageView: UIImageView = UIImageView()
    
    private let localAcornCountLabel: UILabel = UILabel()
    
    private let plainAcornImageView: UIImageView = UIImageView()
    
    private let plainAcornCountLabel: UILabel = UILabel()
    
    var findCourseButton: UIButton = UIButton()
    
    
    // MARK: - Lifecycle
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.addSubviews(scrollView, footerView)
        scrollView.addSubviews(scrollContentView, stickyHeaderView)
        stickyHeaderView.addSubviews(menuLabel, menuUnderLineView)
        scrollContentView.addSubviews(spotDetailImageView,
                                      isOpenButton,
                                      isNotOpenButton,
                                      addressImageView,
                                      addressLabel,
                                      menuCollectionView)
        footerView.addSubviews(localAcornImageView,
                               localAcornCountLabel,
                               plainAcornImageView,
                               plainAcornCountLabel,
                               findCourseButton)
    }
    
    override func setLayout() {
        super.setLayout()
        
        scrollView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(84)
            $0.width.equalToSuperview()
            $0.height.equalTo(1000)
        }
        
        scrollContentView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(ScreenUtils.height*84/780)
            $0.width.equalToSuperview()
            $0.height.equalTo(1000)
        }
        
        footerView.snp.makeConstraints {
            $0.bottom.horizontalEdges.equalToSuperview()
            $0.height.equalTo(ScreenUtils.height*84/780)
        }
        
        spotDetailImageView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(ScreenUtils.height*196/780)
        }
        
        isOpenButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.height*212/780)
            $0.leading.equalToSuperview().inset(ScreenUtils.width*20/360)
            $0.width.equalTo(ScreenUtils.width*51/360)
            $0.height.equalTo(ScreenUtils.height*22/780)
        }
        
        isNotOpenButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.height*212/780)
            $0.leading.equalToSuperview().inset(ScreenUtils.width*20/360)
            $0.width.equalTo(ScreenUtils.width*51/360)
            $0.height.equalTo(ScreenUtils.height*22/780)
        }
        
        addressImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.height*242/780)
            $0.leading.equalToSuperview().inset(ScreenUtils.width*20/360)
            $0.width.height.equalTo(16)
        }
        
        addressLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.height*242/780)
            $0.leading.equalToSuperview().inset(ScreenUtils.width*38/360)
            $0.height.equalTo(18)
        }
        
        stickyHeaderView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.height*300/780)
            $0.leading.equalToSuperview().inset(ScreenUtils.width*20/360)
            $0.width.equalTo(63)
            $0.height.equalTo(36)
        }
        
        menuLabel.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(2)
        }
        
        menuUnderLineView.snp.makeConstraints {
            $0.bottom.horizontalEdges.equalToSuperview()
            $0.height.equalTo(2)
        }
        
        menuCollectionView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.width*20/360)
        }
        
        localAcornImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.height*18/780)
            $0.leading.equalToSuperview().inset(ScreenUtils.width*20/360)
            $0.width.height.equalTo(24)
        }
        
        localAcornCountLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.height*21/780)
            $0.leading.equalToSuperview().inset(ScreenUtils.width*46/360)
            $0.width.equalTo(24)
            $0.height.equalTo(18)
        }
        
        plainAcornImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.height*18/780)
            $0.leading.equalToSuperview().inset(ScreenUtils.width*82/360)
            $0.width.height.equalTo(24)
        }
        
        plainAcornCountLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.height*21/780)
            $0.leading.equalToSuperview().inset(ScreenUtils.width*108/360)
            $0.width.equalTo(24)
            $0.height.equalTo(18)
        }
        
        findCourseButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.height*8/780)
            $0.trailing.equalToSuperview().inset(ScreenUtils.width*20/360)
            $0.width.equalTo(ScreenUtils.width*180/360)
            $0.height.equalTo(ScreenUtils.height*44/780)
        }
    }
    
    override func setStyle() {
        super.setStyle()
          
        spotDetailImageView.do {
            $0.backgroundColor = .gray7
        }
        
        isOpenButton.do {
            $0.isSelected = true
            $0.isEnabled = false
            $0.setAttributedTitle(text: StringLiterals.SpotDetail.isOpen, style: .b4)
        }
        
        isOpenButton.do {
            $0.isSelected = true
            $0.isEnabled = false
            $0.setAttributedTitle(text: StringLiterals.SpotDetail.isNotOpen, style: .b4)
        }
        
        addressLabel.do {
            $0.setLabel(text: StringLiterals.SpotDetail.menu,
                        style: .b4,
                        color: .gray4)
        }
        
        addressImageView.do {
            $0.image = .icLocation
            $0.contentMode = .scaleAspectFill
        }
        
        menuLabel.do {
            $0.setLabel(text: StringLiterals.SpotDetail.menu,
                        style: .s2,
                        alignment: .center)
        }
        
        menuUnderLineView.do {
            $0.backgroundColor = .acWhite
        }
        
        menuCollectionView.do {
            $0.backgroundColor = .clear
            $0.isScrollEnabled = false
            $0.showsVerticalScrollIndicator = false
        }
        
        localAcornImageView.do {
            $0.image = .icLocal
            $0.contentMode = .scaleAspectFit
        }
        
        localAcornCountLabel.do {
            $0.setLabel(text: "0000",
                        style: .b4,
                        alignment: .right)
        }
        
        plainAcornImageView.do {
            $0.image = .icVisitor
            $0.contentMode = .scaleAspectFit
        }
        
        plainAcornCountLabel.do {
            $0.setLabel(text: "0000",
                        style: .b4,
                        alignment: .right)
        }
        
        findCourseButton.do {
            $0.backgroundColor = .org1
            $0.roundedButton(cornerRadius: 10, maskedCorners: [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner])
            $0.setAttributedTitle(text: StringLiterals.SpotDetail.findCourse, style: .h8)
        }
        
    }
    
}
