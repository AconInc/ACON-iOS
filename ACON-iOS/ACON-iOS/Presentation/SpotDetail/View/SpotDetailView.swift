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

    private let titleLabel = UILabel()
    private let acornCountButton = UIButton()
    private let tagStackView = UIStackView()

    let menuButton = SpotDetailSideButton(.menu)
    let shareButton = SpotDetailSideButton(.share)
    let moreButton = SpotDetailSideButton(.more)

    let findCourseButton = ACButton(style: GlassButton(glassmorphismType: .buttonGlassDefault, buttonType: .full_10_b1SB))

    private let horizontalEdges: CGFloat = 16

    // MARK: - Initializing

    override func setHierarchy() {
        super.setHierarchy()
        
        self.addSubviews(collectionView,
                         dimImageView,
                         titleLabel,
                         acornCountButton,
                         tagStackView,
                         findCourseButton,
                         menuButton,
                         shareButton,
                         moreButton)
    }

    override func setLayout() {
        super.setLayout()

        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        dimImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(ScreenUtils.heightRatio*56)
            $0.leading.equalToSuperview().offset(horizontalEdges)
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
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(horizontalEdges)
            $0.height.equalTo(54)
        }
        
        moreButton.snp.makeConstraints {
            $0.bottom.equalTo(findCourseButton.snp.top).offset(-34)
            $0.trailing.equalToSuperview().inset(horizontalEdges)
        }
        
        shareButton.snp.makeConstraints {
            $0.bottom.equalTo(moreButton.snp.top).offset(-36)
            $0.trailing.equalToSuperview().inset(horizontalEdges)
        }
        
        menuButton.snp.makeConstraints {
            $0.bottom.equalTo(shareButton.snp.top).offset(-36)
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
            $0.image = .imgGra2
        }

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


// MARK: - Binding

extension SpotDetailView {
    
    func bindData(_ spotDetail: SpotDetailInfoModel) {
        titleLabel.setLabel(text: spotDetail.name, style: .t4SB)
        
        // TODO: API 나오면 실제 데이터로 바꾸기
        if let acornCount = (1...10000).randomElement() {
            let acornString: String = acornCount > 9999 ? "+9999" : String(acornCount)
            acornCountButton.setAttributedTitle(text: String(acornString), style: .b1R)
        }
        
        // TODO: API 나오면 실제 데이터로 바꾸기 (tempTags -> Tags)
        let tempTags: [SpotTagType] = [.new, .local, .top(number: 1)]
        tagStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        tempTags.forEach { tag in
            tagStackView.addArrangedSubview(SpotTagButton(tag))
        }
        
        // TODO: API 나오면 실제 데이터로 바꾸기
        let walk: String = StringLiterals.SpotList.walk
        let findCourse: String = StringLiterals.SpotList.minuteFindCourse
        let courseTitle: String = walk + "9" + findCourse
        findCourseButton.setAttributedTitle(text: courseTitle, style: .t4SB)
    }

    func makeMainMenuSection(_ menus: [SpotMenuModel]) {
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
            $0.bottom.equalTo(menuStack.snp.top).offset(-12)
        }
    }
    
    func makeMenuStackView(_ menus: [SpotMenuModel]) -> UIStackView {
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
                $0.width.equalTo(55)
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

}
