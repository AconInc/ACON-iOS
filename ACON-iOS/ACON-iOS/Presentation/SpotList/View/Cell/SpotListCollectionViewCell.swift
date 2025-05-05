//
//  SpotListCollectionViewCell.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/12/25.
//

import UIKit

import Kingfisher

class SpotListCollectionViewCell: BaseCollectionViewCell {
    
    // TODO: bgImage dim 처리
    
    // MARK: - UI Properties
    
    private let bgImage = UIImageView()
    private let dimImage = UIImageView()

    private let titleLabel = UILabel()
    private let acornCountButton = UIButton()
    private let tagStackView = UIStackView()
    private let findCourseButton = UIButton()
    
    
    // MARK: - Life Cycle
    
    override func setHierarchy() {
        super.setHierarchy()

        self.addSubviews(bgImage,
                         dimImage,
                         titleLabel,
                         acornCountButton,
                         tagStackView,
                         findCourseButton)
    }
    
    override func setLayout() {
        super.setLayout()
        
        let edge = ScreenUtils.widthRatio * 20
        
        bgImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        dimImage.snp.makeConstraints {
            $0.edges.equalTo(bgImage)
        }
 
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(edge)
            $0.width.equalTo(210 * ScreenUtils.widthRatio)
        }

        acornCountButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(edge)
        }
        
        tagStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalTo(titleLabel)
        }

        findCourseButton.snp.makeConstraints {
            $0.bottom.trailing.equalToSuperview().inset(edge)
        }
    }

    override func setStyle() {
        backgroundColor = .clear

        bgImage.do {
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = 20
        }

        dimImage.do {
            $0.clipsToBounds = true
            $0.image = .imgGra1
            $0.layer.cornerRadius = 20
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

        tagStackView.do {
            $0.spacing = 4
        }

        findCourseButton.do {
            $0.setGlassmorphismBackground(10)
            var config = UIButton.Configuration.plain()
            config.contentInsets = .init(top: 8, leading: 23, bottom: 8, trailing: 23)
            $0.configuration = config
        }
    }

}


// MARK: - Binding

extension SpotListCollectionViewCell {

    func bind(spot: SpotModel, matchingRateBgColor: MatchingRateBgColorType) {
        bgImage.kf.setImage(
            with: URL(string: spot.imageURL),
            options: [.transition(.none), .cacheOriginalImage])

        titleLabel.setLabel(text: spot.name, style: .t4SB)

        // TODO: API 나오면 실제 데이터로 바꾸기 (matchingRate -> acornCount)
        if let acornCount = spot.matchingRate {
            let acornString: String = acornCount > 9999 ? "+9999" : String(acornCount)
            acornCountButton.setAttributedTitle(text: String(acornString), style: .b1R)
        }

        // TODO: API 나오면 실제 데이터로 바꾸기 (tempTags -> Tags)
        let tempTags: [SpotTagType] = [.new, .local, .top(number: 1)]
        tagStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        tempTags.forEach { tag in
            tagStackView.addArrangedSubview(SpotTagButton(tag))
        }

        let walk: String = StringLiterals.SpotList.walk
        let findCourse: String = StringLiterals.SpotList.minuteFindCourse
        let courseTitle: String = walk + String(spot.walkingTime) + findCourse
        findCourseButton.setAttributedTitle(text: courseTitle, style: .b1SB)
    }

}
