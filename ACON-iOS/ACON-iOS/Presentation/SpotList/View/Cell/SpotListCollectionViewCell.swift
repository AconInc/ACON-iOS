//
//  SpotListCollectionViewCell.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/12/25.
//

import UIKit

import Kingfisher

class SpotListCollectionViewCell: BaseCollectionViewCell {

    // MARK: - UI Properties

    private var currentImageURL: String? // NOTE: 셀 재사용 이슈 방지 목적

    private let bgImage = UIImageView()
    private let dimImage = UIImageView()
    private let bgImageShadowView = UIView()

    private let noImageContentView = SpotNoImageContentView(.iconAndDescription)
    private let loginlockOverlayView = LoginLockOverlayView()

    private let titleLabel = UILabel()
    private let acornCountButton = UIButton()
    private let tagStackView = UIStackView()
    private let findCourseButton = ACButton(style: GlassButton(glassmorphismType: .buttonGlassDefault, buttonType: .full_10_b1SB))

    private let cornerRadius: CGFloat = 20


    // MARK: - Life Cycle

    override func setHierarchy() {
        super.setHierarchy()

        self.addSubviews(bgImageShadowView,
                         dimImage,
                         noImageContentView,
                         titleLabel,
                         acornCountButton,
                         tagStackView,
                         findCourseButton,
                         loginlockOverlayView)

        bgImageShadowView.addSubview(bgImage)
    }

    override func setLayout() {
        super.setLayout()

        let edge = ScreenUtils.widthRatio * 20

        bgImageShadowView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

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

        loginlockOverlayView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

    }

    override func setStyle() {
        backgroundColor = .clear

        bgImageShadowView.do {
            $0.clipsToBounds = false
        }

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

        loginlockOverlayView.do {
            $0.isHidden = true
            $0.clipsToBounds = true
            $0.layer.cornerRadius = cornerRadius
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        findCourseButton.refreshBlurEffect()

        currentImageURL = nil
        bgImage.kf.cancelDownloadTask()
        bgImage.image = nil

        bgImageShadowView.layer.shadowColor = UIColor.clear.cgColor
    }

}


// MARK: - Binding

extension SpotListCollectionViewCell: SpotListCellConfigurable {

    func bind(spot: SpotModel) {
        let imageURL = spot.imageURL ?? ""
        currentImageURL = imageURL

        setBgImageAndShadow(from: imageURL)

        titleLabel.setLabel(text: spot.name, style: .t4SB)

        setAcornCountButton(to: spot.acornCount)

        tagStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        spot.tagList.forEach { tag in
            tagStackView.addArrangedSubview(SpotTagButton(tag))
        }

        setFindCourseButton(to: spot.eta)
    }

    func overlayLoginLock(_ show: Bool) {
        loginlockOverlayView.isHidden = !show
    }

}


// MARK: - Helper

private extension SpotListCollectionViewCell {

    func setBgImageAndShadow(from imageURL: String) {
        bgImage.kf.setImage(
            with: URL(string: imageURL),
            placeholder: UIImage.imgSkeletonBg,
            options: [
                .transition(.none),
                .cacheOriginalImage,
                .scaleFactor(UIScreen.main.scale)
            ],
            completionHandler: { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let value):
                    self.noImageContentView.isHidden = true
                    self.dimImage.isHidden = false
                    self.extractAndApplyShadowColor(from: value.image, for: imageURL)

                case .failure:
                    self.bgImage.image = .imgSpotNoImageBackground
                    self.noImageContentView.isHidden = false
                    self.dimImage.isHidden = true
                    self.extractAndApplyShadowColor(from: .imgSpotNoImageBackground, for: ShadowColorCache.noImageKey)
                }
            }
        )
    }

    func setAcornCountButton(to acornCount: Int) {
        let acornString: String = acornCount > 9999 ? "+9999" : String(acornCount)
        acornCountButton.setAttributedTitle(text: String(acornString), style: .b1R)
    }

    func setFindCourseButton(to eta: Int) {
        let walk: String = StringLiterals.SpotList.walk
        let findCourse: String = StringLiterals.SpotList.minuteFindCourse
        let courseTitle: String = walk + String(eta) + findCourse
        findCourseButton.setAttributedTitle(text: courseTitle, style: .b1SB)
    }

    func extractAndApplyShadowColor(from image: UIImage, for key: String) {
        // NOTE: 캐시 확인 및 적용
        if let cachedColor = ShadowColorCache.shared.color(for: key) {
            applyShadowColor(cachedColor)
            return
        }

        // NOTE: 색상 추출 및 적용
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let dominantColor = image.mostFrequentBorderColor()

            if let color = dominantColor {
                ShadowColorCache.shared.setColor(color, for: key)
                
                DispatchQueue.main.async {
                    guard self?.shouldApplyShadow(for: key) == true else { return }
                    self?.applyShadowColor(color)
                }
            }
        }
    }

    func applyShadowColor(_ color: UIColor) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            bgImageShadowView.layer.shadowOpacity = 0.7
            bgImageShadowView.layer.shadowRadius = 60
            bgImageShadowView.layer.shadowOffset = CGSize(width: 0, height: 0)
            bgImageShadowView.layer.shadowColor = color.cgColor
        }
    }

    func shouldApplyShadow(for key: String) -> Bool {
        return currentImageURL == key || key == ShadowColorCache.noImageKey
    }

}
