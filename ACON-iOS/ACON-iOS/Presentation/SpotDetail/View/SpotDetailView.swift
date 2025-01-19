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
    
    var stickyView: StickyHeaderView = StickyHeaderView()
    
    let scrollView: UIScrollView = UIScrollView()
    
    var scrollContentView: UIView = UIView()
    
    private let spotDetailImageView: UIImageView = UIImageView()
    
    var openStatusButton: FilterTagButton = FilterTagButton()
    
    var addressImageView: UIImageView = UIImageView()
    
    var addressLabel: UILabel = UILabel()
    
    let stickyHeaderView: StickyHeaderView = StickyHeaderView()
    
    var menuCollectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: menuCollectionViewFlowLayout
    )
    
    private let footerView: UIView = UIView()
    
    private let localAcornImageView: UIImageView = UIImageView()
    
    var localAcornCountLabel: UILabel = UILabel()
    
    private let plainAcornImageView: UIImageView = UIImageView()
    
    var plainAcornCountLabel: UILabel = UILabel()
    
    var findCourseButton: UIButton = UIButton()
    
    static var menuCollectionViewFlowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.minimumLineSpacing = 0
        $0.itemSize = CGSize(width: ScreenUtils.width*320/360, height: ScreenUtils.height*110/780)
    }
    
    // MARK: - Lifecycle
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.addSubviews(scrollView, stickyView, footerView)
        scrollView.addSubviews(scrollContentView)
        scrollContentView.addSubviews(spotDetailImageView,
                                      openStatusButton,
                                      addressImageView,
                                      addressLabel,
                                      stickyHeaderView,
                                      menuCollectionView)
        footerView.addSubviews(localAcornImageView,
                               localAcornCountLabel,
                               plainAcornImageView,
                               plainAcornCountLabel,
                               findCourseButton)
    }
    
    override func setLayout() {
        super.setLayout()
        
        stickyView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.width*20/360)
            $0.height.equalTo(36)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(84)
        }
        
        scrollContentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        footerView.snp.makeConstraints {
            $0.bottom.horizontalEdges.equalToSuperview()
            $0.height.equalTo(ScreenUtils.height*84/780)
        }
        
        spotDetailImageView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(ScreenUtils.height*196/780)
        }
        
        openStatusButton.snp.makeConstraints {
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
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.width*20/360)
            $0.height.equalTo(36)
        }
        
        menuCollectionView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.height*353/780)
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.width*20/360)
            $0.height.equalTo(0)
            $0.bottom.lessThanOrEqualToSuperview()
        }
        
        localAcornImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.height*18/780)
            $0.leading.equalToSuperview().inset(ScreenUtils.width*20/360)
            $0.width.height.equalTo(24)
        }
        
        localAcornCountLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.height*21/780)
            $0.leading.equalToSuperview().inset(ScreenUtils.width*46/360)
            $0.width.equalTo(30)
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
            $0.width.equalTo(30)
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
        
        stickyView.do {
            $0.isHidden = true
        }
        
        scrollView.do {
            $0.showsVerticalScrollIndicator = false
        }
        
        spotDetailImageView.do {
            $0.backgroundColor = .gray7
        }
        
        openStatusButton.do {
            $0.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 2,
                                                                    leading: 10,
                                                                    bottom: 2,
                                                                    trailing: 10)
            $0.setAttributedTitle(text: StringLiterals.SpotDetail.isOpen, style: .b4)
            $0.configuration?.background.strokeWidth = 0
        }
        
        addressImageView.do {
            $0.image = .icLocation
            $0.contentMode = .scaleAspectFill
        }
        
        menuCollectionView.do {
            $0.backgroundColor = .clear
            $0.isScrollEnabled = false
            $0.showsVerticalScrollIndicator = false
        }
        
        footerView.do {
            $0.backgroundColor = .gray9
        }
        
        localAcornImageView.do {
            $0.image = .icLocal
            $0.contentMode = .scaleAspectFit
        }
        
        plainAcornImageView.do {
            $0.image = .icVisitor
            $0.contentMode = .scaleAspectFit
        }
        
        findCourseButton.do {
            $0.backgroundColor = .org1
            $0.roundedButton(cornerRadius: 10, maskedCorners: [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner])
            $0.setAttributedTitle(text: StringLiterals.SpotDetail.findCourse, style: .h8)
        }
        
    }
    
}


extension SpotDetailView {
    
    func bindData(data: SpotDetailInfoModel) {
        let openStatus = data.openStatus
        self.openStatusButton.isSelected = openStatus
        self.openStatusButton.setAttributedTitle(
            text: openStatus ? StringLiterals.SpotDetail.isOpen : StringLiterals.SpotDetail.isNotOpen,
            style: .b4
        )
        
        self.addressLabel.setLabel(text: data.address,
                                             style: .b4,
                                             color: .gray4)
        
        self.localAcornCountLabel.setLabel(text: String(data.localAcornCount),
                                                     style: .b4,
                                                     alignment: .right)
        self.plainAcornCountLabel.setLabel(text: String(data.basicAcornCount),
                                                     style: .b4,
                                                     alignment: .right)
        
    }
    
}
