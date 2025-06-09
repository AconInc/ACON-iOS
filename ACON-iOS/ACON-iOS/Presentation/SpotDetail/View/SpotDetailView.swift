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

    private let dimImageView = UIImageView()
    private let noImageBgImageView = UIImageView()
    private let noImageContentView = SpotNoImageContentView(.iconAndDescription)

    private let titleLabel = UILabel()
    private let acornCountButton = UIButton()
    private let tagStackView = UIStackView()

    let menuButton = SpotDetailSideButton(.menu)
    let bookmarkButton = SpotDetailSideButton(.bookmark)
    let shareButton = SpotDetailSideButton(.share)

    let findCourseButton = ACButton(style: GlassButton(glassmorphismType: .buttonGlassDefault, buttonType: .full_10_b1SB))

    private let imagePageControl = UIPageControl()

    private let horizontalEdges: CGFloat = 20 * ScreenUtils.widthRatio


    // MARK: - Initializing

    override func setHierarchy() {
        super.setHierarchy()

        self.addSubviews(collectionView,
                         dimImageView,
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

        dimImageView.snp.makeConstraints {
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
            $0.width.equalTo(242 * ScreenUtils.widthRatio)
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
            $0.height.equalTo(54)
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
        }

        dimImageView.do {
            $0.clipsToBounds = true
            $0.contentMode = .scaleToFill
            $0.image = .imgGra2
        }

        noImageBgImageView.do {
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFill
            $0.image = .imgSpotNoImageBackground
            $0.isHidden = true
        }

        noImageContentView.isHidden = true

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
        }
    }

}


// MARK: - Internal Methods

extension SpotDetailView {

    func bindData(_ spotDetail: SpotDetailInfoModel) {
        titleLabel.do {
            $0.setLabel(text: spotDetail.name, style: .t4SB, numberOfLines: 1)
            $0.lineBreakMode = .byTruncatingTail
        }

        let acornCount = spotDetail.acornCount
        let acornString: String = acornCount > 9999 ? "+9999" : String(acornCount)
        acornCountButton.setAttributedTitle(text: String(acornString), style: .b1R)

        tagStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        spotDetail.tagList.forEach { tag in
            tagStackView.addArrangedSubview(SpotTagButton(tag))
        }

        // TODO: API 나오면 실제 데이터로 바꾸기
        let walk: String = StringLiterals.SpotList.walk
        let findCourse: String = StringLiterals.SpotList.minuteFindCourse
        let courseTitle: String = walk + "9" + findCourse
        findCourseButton.setAttributedTitle(text: courseTitle, style: .t4SB)

        if spotDetail.imageURLs.count == 0 {
            [noImageBgImageView, noImageContentView].forEach { $0.isHidden = false }
            noImageContentView.setDescription(.noImageDynamic(id: Int(spotDetail.spotID)))
        }

        // TODO: API 명세 나오면 실제 데이터로 바꾸기
        bookmarkButton.isSelected = false
        
        setImagePageControl(spotDetail.imageURLs.count)

        setOpeningTimeView(withTags: !spotDetail.tagList.isEmpty)
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
                $0.width.equalTo(100)
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

    func setImagePageControl(_ numberOfPages: Int) {
        imagePageControl.do {
            $0.numberOfPages = numberOfPages
            $0.currentPage = 0
            $0.currentPageIndicatorTintColor = .acWhite
            $0.pageIndicatorTintColor = .gray300
            $0.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        }
    }

    func setOpeningTimeView(withTags: Bool) {
        let openingTimeView = OpeningTimeView(type: .end, time: "22:00", withDot: true) //TODO: 명세 나오면 수정

        self.addSubview(openingTimeView)

        if withTags {
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

}
