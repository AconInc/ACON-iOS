//
//  NoMatchingSpotListCollectionViewCell.swift
//  ACON-iOS
//
//  Created by 김유림 on 5/29/25.
//

import UIKit

class NoMatchingSpotListCollectionViewCell: BaseCollectionViewCell {

    // MARK: - UI Properties

    private let bgImage = UIImageView()
    private let dimImage = UIImageView()

    private let noImageContentView = SpotNoImageContentView()
    private let loginErrorView = LoginLockOverlayView()

    private let titleLabel = UILabel()
    private let acornCountButton = UIButton()
    private let tagStackView = UIStackView()
    private let findCourseButton = ACButton(style: GlassButton(glassmorphismType: .buttonGlassDefault, buttonType: .full_10_b1SB))

    private let cornerRadius: CGFloat = 20


    // MARK: - Life Cycle

    override func setHierarchy() {
        super.setHierarchy()

        self.addSubviews(bgImage,
                         dimImage,
                         noImageContentView,
                         titleLabel,
                         acornCountButton,
                         tagStackView,
                         findCourseButton,
                         loginErrorView)
    }

    override func setLayout() {
        super.setLayout()

        let edge = ScreenUtils.widthRatio * 16

        bgImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        dimImage.snp.makeConstraints {
            $0.edges.equalTo(bgImage)
        }

        noImageContentView.snp.makeConstraints {
            $0.center.equalToSuperview()
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
            $0.width.equalTo(140)
            $0.height.equalTo(36)
        }

        loginErrorView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    override func setStyle() {
        backgroundColor = .clear

        bgImage.do {
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = cornerRadius
        }

        dimImage.do {
            $0.clipsToBounds = true
            $0.image = .imgGra1
            $0.layer.cornerRadius = cornerRadius
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
            $0.updateGlassButtonState(state: .default)
        }

        loginErrorView.do {
            $0.isHidden = true
            $0.clipsToBounds = true
            $0.layer.cornerRadius = cornerRadius
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        findCourseButton.refreshBlurEffect()
    }

}


// MARK: - Binding

extension NoMatchingSpotListCollectionViewCell: SpotListCellConfigurable {

    func bind(spot: SpotModel) {
        bgImage.kf.setImage(
            with: URL(string: spot.imageURL ?? ""),
            placeholder: UIImage.imgSkeletonBg,
            options: [.transition(.none), .cacheOriginalImage],
            completionHandler: { result in
                switch result {
                case .success:
                    self.noImageContentView.isHidden = true
                    self.dimImage.isHidden = false
                case .failure:
                    self.bgImage.image = .imgSpotNoImageBackground
                    self.noImageContentView.isHidden = false
                    self.dimImage.isHidden = true
                }
            }
        )

        titleLabel.setLabel(text: spot.name, style: .t4SB)

        let acornCount: Int = spot.acornCount
        let acornString: String = acornCount > 9999 ? "+9999" : String(acornCount)
        acornCountButton.setAttributedTitle(text: String(acornString), style: .b1R)

        tagStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        spot.tagList.forEach { tag in
            tagStackView.addArrangedSubview(SpotTagButton(tag))
        }

        let walk: String = StringLiterals.SpotList.walk
        let findCourse: String = StringLiterals.SpotList.minuteFindCourse
        let courseTitle: String = walk + String(spot.eta) + findCourse
        findCourseButton.setAttributedTitle(text: courseTitle, style: .b1SB)
    }

    func showLoginCell(_ show: Bool) {
        loginErrorView.isHidden = !show
    }

}
