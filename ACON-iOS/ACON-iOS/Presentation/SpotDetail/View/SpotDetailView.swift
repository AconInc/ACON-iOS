//
//  SpotDetailView.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/16/25.
//

import UIKit

import Kingfisher
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
    
    let footerGlassMorphismView = GlassmorphismView()

    let footerView: UIView = UIView()
    
    private let localAcornImageView: UIImageView = UIImageView()
    
    var localAcornCountLabel: UILabel = UILabel()
    
    private let plainAcornImageView: UIImageView = UIImageView()
    
    var plainAcornCountLabel: UILabel = UILabel()
    
    var findCourseButton: UIButton = UIButton()
    
    var gotoTopButton: UIButton = UIButton()
    
    static var menuCollectionViewFlowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.minimumLineSpacing = 0
        $0.itemSize = CGSize(width: ScreenUtils.widthRatio*320, height: ScreenUtils.heightRatio*110)
    }
    
    let navViewHeight = ScreenUtils.navViewHeight
    
    // MARK: - Lifecycle
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.addSubviews(scrollView,
                         stickyView,
                         footerGlassMorphismView,
                         footerView,
                         gotoTopButton)
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
        
        gotoTopButton.snp.makeConstraints{
            $0.trailing.equalToSuperview().inset(ScreenUtils.widthRatio * 20)
            $0.bottom.equalTo(footerView.snp.top).offset(-ScreenUtils.heightRatio * 16)
            $0.size.equalTo(ScreenUtils.widthRatio * 44)
        }
        
        stickyView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.widthRatio * 20)
            $0.height.equalTo(36)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(-navViewHeight)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(84)
        }
        
        scrollContentView.snp.makeConstraints {
//            $0.top.equalTo(scrollView.contentLayoutGuide).offset(-navViewHeight)
//            $0.horizontalEdges.bottom.equalTo(scrollView.contentLayoutGuide)
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        footerGlassMorphismView.snp.makeConstraints {
            $0.bottom.horizontalEdges.equalToSuperview()
            $0.height.equalTo(ScreenUtils.heightRatio*84)
        }
        
        footerView.snp.makeConstraints {
            $0.bottom.horizontalEdges.equalToSuperview()
            $0.height.equalTo(ScreenUtils.heightRatio*84)
        }
        
        spotDetailImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(navViewHeight)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(ScreenUtils.heightRatio*296)
        }
        
        openStatusButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.heightRatio*312 + navViewHeight)
            $0.leading.equalToSuperview().inset(ScreenUtils.widthRatio*20)
            $0.width.equalTo(ScreenUtils.widthRatio*51)
            $0.height.equalTo(ScreenUtils.heightRatio*22)
        }
        
        addressImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.heightRatio*342 + navViewHeight)
            $0.leading.equalToSuperview().inset(ScreenUtils.widthRatio*20)
            $0.width.height.equalTo(16)
        }
        
        addressLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.heightRatio*342 + navViewHeight)
            $0.leading.equalToSuperview().inset(ScreenUtils.widthRatio*38)
            $0.trailing.equalToSuperview().inset(ScreenUtils.widthRatio*20)
            $0.height.equalTo(18)
        }
        
        stickyHeaderView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.heightRatio*400 + navViewHeight)
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.widthRatio*20)
            $0.height.equalTo(36)
        }
        
        menuCollectionView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.heightRatio*453 + navViewHeight)
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.widthRatio*20)
            $0.height.equalTo(0)
            $0.bottom.lessThanOrEqualToSuperview().inset(ScreenUtils.heightRatio*76)
        }
        
        localAcornImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.heightRatio*18)
            $0.leading.equalToSuperview().inset(ScreenUtils.widthRatio*20)
            $0.width.height.equalTo(24)
        }
        
        localAcornCountLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.heightRatio*21)
            $0.leading.equalToSuperview().inset(ScreenUtils.widthRatio*46)
            $0.width.equalTo(30)
            $0.height.equalTo(18)
        }
        
        plainAcornImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.heightRatio*18)
            $0.leading.equalToSuperview().inset(ScreenUtils.widthRatio*82)
            $0.width.height.equalTo(24)
        }
        
        plainAcornCountLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.heightRatio*21)
            $0.leading.equalToSuperview().inset(ScreenUtils.widthRatio*108)
            $0.width.equalTo(30)
            $0.height.equalTo(18)
        }
        
        findCourseButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.heightRatio*8)
            $0.trailing.equalToSuperview().inset(ScreenUtils.widthRatio*20)
            $0.width.equalTo(ScreenUtils.widthRatio*180)
            $0.height.equalTo(ScreenUtils.heightRatio*44)
        }
    }
    
    override func setStyle() {
        super.setStyle()
        
        self.backgroundColor = .clear
        gotoTopButton.do {
            $0.backgroundColor = .gray7
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.gray6.cgColor
            $0.layer.cornerRadius = ScreenUtils.widthRatio * 44 / 2
            $0.clipsToBounds = true
            $0.setImage(UIImage(named:"upVector"), for: .normal)
        }
        
        stickyView.do {
            $0.isHidden = true
        }
        
        scrollView.do {
            $0.showsVerticalScrollIndicator = false
            $0.bounces = false
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
            $0.isUserInteractionEnabled = false
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
            $0.backgroundColor = .clear
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
            $0.backgroundColor = .primaryDefault
            $0.roundedButton(cornerRadius: 10, maskedCorners: [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner])
            $0.setAttributedTitle(text: StringLiterals.SpotDetail.findCourse, style: .h8)
        }
        
    }
    
}


extension SpotDetailView {
    
    func bindData(data: SpotDetailInfoModel) {
        self.spotDetailImageView.do {
            $0.kf.setImage(with: URL(string: data.firstImageURL), options: [.transition(.none), .cacheOriginalImage])
        }
        let openStatus = data.openStatus
        self.openStatusButton.isSelected = openStatus
        self.openStatusButton.setAttributedTitle(
            text: openStatus ? StringLiterals.SpotDetail.isOpen : StringLiterals.SpotDetail.isNotOpen,
            style: .b4
        )
        self.addressLabel.setLabel(text: data.address,
                                             style: .b2,
                                             color: .gray4)
        self.localAcornCountLabel.setLabel(text: String(data.localAcornCount),
                                                     style: .s1,
                                                     alignment: .left)
        self.plainAcornCountLabel.setLabel(text: String(data.basicAcornCount),
                                           style: .s1,
                                           alignment: .left)
        
    }
    
}
