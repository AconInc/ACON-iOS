//
//  SpotDetailView.swift
//  ACON-iOS
//
//  Created by 김유림 on 5/13/25.
//

import UIKit

final class SpotDetailView: BaseView {

    // MARK: - UI Components

    private let layout = UICollectionViewFlowLayout()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

    private let noImageBgImageView = UIImageView()
    private let noImageContentView = SpotNoImageContentView(.iconAndDescription)

    private let titleLabel = UILabel()
    private let acornCountButton = UIButton()
    private let tagStackView = UIStackView()

    let menuButton = SpotDetailSideButton(.menu)
    let bookmarkButton = SpotDetailSideButton(.bookmark)
    let shareButton = SpotDetailSideButton(.share)

    let findCourseButton = UIButton()

    private let imagePageControl = UIPageControl()

    private let horizontalEdges: CGFloat = 20 * ScreenUtils.widthRatio


    // MARK: - Initializing

    override func setHierarchy() {
        super.setHierarchy()

        self.addSubviews(collectionView,
                         noImageBgImageView,
                         noImageContentView,
                         titleLabel,
                         acornCountButton,
                         tagStackView,
                         findCourseButton,
                         imagePageControl,
                         menuButton,
                         bookmarkButton,
                         shareButton)
    }

    override func setLayout() {
        super.setLayout()

        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        noImageBgImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        noImageContentView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(258 * ScreenUtils.heightRatio)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(ScreenUtils.heightRatio*56)
            $0.leading.equalToSuperview().offset(horizontalEdges)
            $0.trailing.equalTo(acornCountButton.snp.leading).offset(-8)
        }

        tagStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(horizontalEdges)
        }

        acornCountButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel).offset(1)
            $0.trailing.equalToSuperview().inset(horizontalEdges)
        }

        findCourseButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-13)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
            $0.height.equalTo(48)
        }

        imagePageControl.snp.makeConstraints {
            $0.bottom.equalTo(findCourseButton.snp.top).offset(-12)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(6)
            $0.width.equalTo(120)
        }

        shareButton.snp.makeConstraints {
            $0.bottom.equalTo(findCourseButton.snp.top).offset(max(-34, -34 * ScreenUtils.heightRatio))
            $0.trailing.equalToSuperview().inset(horizontalEdges)
        }

        bookmarkButton.snp.makeConstraints {
            $0.bottom.equalTo(shareButton.snp.top).offset(ScreenUtils.height < 700 ? -24 : -36)
            $0.trailing.equalToSuperview().inset(horizontalEdges)
        }

        menuButton.snp.makeConstraints {
            $0.bottom.equalTo(bookmarkButton.snp.top).offset(ScreenUtils.height < 700 ? -24 : -36)
            $0.trailing.equalToSuperview().inset(horizontalEdges)
        }
    }

    override func setStyle() {
        super.setStyle()

        layout.do {
            $0.scrollDirection = .horizontal
            $0.itemSize = .init(width: ScreenUtils.width, height: ScreenUtils.height)
            $0.minimumLineSpacing = 0
        }

        collectionView.do {
            $0.backgroundColor = .gray900
            $0.isPagingEnabled = true
            $0.showsHorizontalScrollIndicator = false
        }

        noImageBgImageView.do {
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFill
            $0.image = .imgSpotNoImageBackground
            $0.isHidden = true
        }

        noImageContentView.isHidden = true

        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        tagStackView.do {
            $0.spacing = 4
        }

        acornCountButton.do {
            var config = UIButton.Configuration.plain()
            let acorn: UIImage = .icAcornLine.resize(to: .init(width: 24, height: 24))
            config.image = acorn
            config.imagePadding = 2
            config.titleAlignment = .leading
            config.contentInsets = .zero
            $0.configuration = config
            $0.setContentCompressionResistancePriority(.required, for: .horizontal)
            $0.isHidden = true
        }

        findCourseButton.setBackgroundImage(.imgFindcourse328, for: .normal)
    }

}


// MARK: - Internal Methods

extension SpotDetailView {

    func bindData(_ spotDetail: SpotDetailInfoModel) {
        titleLabel.do {
            $0.setLabel(text: spotDetail.name, style: .t4SB, numberOfLines: 1)
            $0.lineBreakMode = .byTruncatingTail
        }

        setAcornCountButton(with: spotDetail.acornCount)

        if spotDetail.imageURLs?.count == 0 {
            [noImageBgImageView, noImageContentView].forEach { $0.isHidden = false }
            noImageContentView.setDescription(.noImageDynamic(id: Int(spotDetail.spotID)))
        }

        bookmarkButton.isSelected = spotDetail.isSaved
        
        setImagePageControl(spotDetail.imageURLs?.count)
    }

    func setTagStackView(tags: [SpotTagType]) {
        tagStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        tags.forEach { tag in
            tagStackView.addArrangedSubview(SpotTagButton(tag))
        }
    }

    func setOpeningTimeView(isOpen: Bool, time: String, description: String, hasTags: Bool) {
        let openingTimeView = OpeningTimeView(isOpen: isOpen, time: time, description: description)

        self.addSubview(openingTimeView)

        if hasTags {
            openingTimeView.snp.makeConstraints {
                $0.top.equalTo(tagStackView.snp.bottom).offset(7)
                $0.leading.equalToSuperview().offset(horizontalEdges)
            }
        } else {
            openingTimeView.snp.makeConstraints {
                $0.top.equalTo(titleLabel.snp.bottom).offset(7)
                $0.leading.equalToSuperview().offset(horizontalEdges)
            }
        }
    }

    func setFindCourseButton(_ transportMode: TransportModeType?, _ eta: Int?) {
        guard let transportMode,
              let eta else {
            findCourseButton.setAttributedTitle(text: "길찾기", style: .t4SB)
            return
        }

        let findCourse: String = StringLiterals.SpotList.minuteFindCourse

        switch transportMode {
        case .walking:
            let walk: String = StringLiterals.SpotList.walk
            let courseTitle: String = walk + String(eta) + findCourse
            findCourseButton.do {
                $0.setAttributedTitle(text: courseTitle, style: .b1SB)
            }
        case .biking:
            let bike: String = StringLiterals.SpotList.bike
            let courseTitle: String = bike + String(eta) + findCourse
            findCourseButton.do {
                $0.setAttributedTitle(text: courseTitle, style: .b1SB)
            }
        default:
            findCourseButton.do {
                $0.setAttributedTitle(text: "길찾기", style: .b1SB)
            }
        }
    }

    func makeSignatureMenuSection(_ menus: [SignatureMenuModel]) {
        guard menus.count > 0 else { return }

        var menus = menus
        if menus.count > 3 {
            menus = Array(menus[0...2])
        }

        let sectionTitle = UILabel()
        let menuStack = makeMenuStackView(menus)

        self.addSubviews(sectionTitle, menuStack)

        menuStack.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(horizontalEdges)
            $0.bottom.equalTo(findCourseButton.snp.top).offset(-34)
        }
        
        sectionTitle.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(horizontalEdges)
            $0.bottom.equalTo(menuStack.snp.top).offset(-8)
        }

        sectionTitle.setLabel(text: StringLiterals.SpotDetail.signatureMenu, style: .t4SB)
    }

    func updatePageControl() {
        let page = Int(round(collectionView.contentOffset.x / collectionView.bounds.width))
        imagePageControl.currentPage = page
    }

}


// MARK: - Helper

private extension SpotDetailView {

    func makeMenuStackView(_ menus: [SignatureMenuModel]) -> UIStackView {
        let stackView = UIStackView()

        for menu in menus {
            let view = UIView()
            let nameLabel = UILabel()
            let priceLabel = UILabel()
            
            stackView.addArrangedSubview(view)
            view.addSubviews(nameLabel, priceLabel)
            
            nameLabel.snp.makeConstraints {
                $0.verticalEdges.leading.equalToSuperview()
                $0.width.equalTo(160)
            }
            priceLabel.snp.makeConstraints {
                $0.verticalEdges.equalToSuperview()
                $0.leading.equalTo(nameLabel.snp.trailing).offset(8)
                $0.width.equalTo(58)
            }
            
            nameLabel.setLabel(text: menu.name, style: .b1R, numberOfLines: 1)
            priceLabel.setLabel(text: menu.price.formattedWithSeparator, style: .b1SB, numberOfLines: 1)
            [nameLabel, priceLabel].forEach { $0.lineBreakMode = .byTruncatingTail }
        }

        stackView.do {
            $0.axis = .vertical
            $0.spacing = 4
        }

        return stackView
    }

    func setImagePageControl(_ numberOfPages: Int?) {
        guard let numberOfPages = numberOfPages, numberOfPages > 1 else {
            imagePageControl.removeFromSuperview()
            return
        }

        imagePageControl.do {
            $0.numberOfPages = numberOfPages
            $0.currentPage = 0
            $0.currentPageIndicatorTintColor = .acWhite
            $0.pageIndicatorTintColor = .gray300
            $0.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        }
    }

    func setAcornCountButton(with acornCount: Int) {
        if acornCount > 0 {
            let acornString: String = acornCount > 9999 ? "+9999" : String(acornCount)
            acornCountButton.setAttributedTitle(text: String(acornString), style: .b1R)
            acornCountButton.isHidden = false
        }
    }

}
