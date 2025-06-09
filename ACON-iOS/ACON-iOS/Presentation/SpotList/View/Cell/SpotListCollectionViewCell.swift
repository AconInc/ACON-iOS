//
//  SpotListCollectionViewCell.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/12/25.
//

import UIKit

import Kingfisher

class SpotListCollectionViewCell: BaseCollectionViewCell {

    // MARK: - Properties

    var spot: SpotModel?

    var findCourseDelegate: SpotListCellDelegate?


    // MARK: - UI Properties

    private var currentImageURL: String? // NOTE: 셀 재사용 이슈 방지 목적

    private let bgImageView = UIImageView()
    private let gradientImageView = UIImageView()
    private let bgImageShadowView = UIView()
    private let glassBgView = GlassmorphismView(.noImageErrorGlass)

    private let noImageContentView = SpotNoImageContentView(.iconAndDescription)
    private let loginlockOverlayView = LoginLockOverlayView()

    private let titleLabel = UILabel()
    private let acornCountButton = UIButton()
    private let tagStackView = UIStackView()
    let findCourseButton = ACButton(style: GlassButton(glassmorphismType: .buttonGlassDefault, buttonType: .full_10_b1SB))

    private let cornerRadius: CGFloat = 20


    // MARK: - init

    override init(frame: CGRect) {
        super.init(frame: frame)

        addTarget()
    }

    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setHierarchy() {
        super.setHierarchy()

        self.addSubviews(bgImageShadowView,
                         glassBgView,
                         gradientImageView,
                         noImageContentView,
                         titleLabel,
                         acornCountButton,
                         tagStackView,
                         findCourseButton,
                         loginlockOverlayView)

        bgImageShadowView.addSubview(bgImageView)
    }

    override func setLayout() {
        super.setLayout()

        let edge = ScreenUtils.widthRatio * 20

        [bgImageShadowView, glassBgView, bgImageView].forEach {
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }

        gradientImageView.snp.makeConstraints {
            $0.edges.equalTo(bgImageView)
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

        glassBgView.do {
            $0.clipsToBounds = true
            $0.isHidden = true
            $0.layer.cornerRadius = cornerRadius
        }

        bgImageView.do {
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = cornerRadius
        }

        gradientImageView.do {
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

        currentImageURL = nil

        bgImageView.do {
            $0.kf.cancelDownloadTask()
            $0.image = nil
        }

        gradientImageView.do {
            $0.image = nil
            $0.removeGradient()
        }

        tagStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        bgImageShadowView.layer.shadowColor = UIColor.clear.cgColor

        DispatchQueue.main.async { [weak self] in // NOTE: 블러 렌더링 타이밍 이슈때문에 사용
            self?.glassBgView.refreshBlurEffect()
            self?.findCourseButton.refreshBlurEffect()
        }
    }

    private func addTarget() {
        findCourseButton.addTarget(self, action: #selector(tappedFindCourseButton), for: .touchUpInside)
    }

}


// MARK: - @objc functions

private extension SpotListCollectionViewCell {

    @objc func tappedFindCourseButton() {
        guard let spot = spot else { return }
        findCourseDelegate?.tappedFindCourseButton(spot: spot)
    }

}


// MARK: - Binding

extension SpotListCollectionViewCell: SpotListCellConfigurable {

    func bind(spot: SpotModel) {
        self.spot = spot

        if let imageURL = spot.imageURL {
            currentImageURL = imageURL
            setBgImageAndShadow(from: imageURL, noImageDescriptionID: Int(spot.id))
        } else {
            updateUI(with: .noImageDynamic(id: Int(spot.id)))
            extractAndApplyShadowColor(from: .imgSpotNoImageBackground, for: ShadowColorCache.noImageKey)
        }

        titleLabel.do {
            $0.setLabel(text: spot.name, style: .t4SB, numberOfLines: 1)
            $0.lineBreakMode = .byTruncatingTail
        }

        setAcornCountButton(with: spot.acornCount)

        spot.tagList.forEach { tag in
            tagStackView.addArrangedSubview(SpotTagButton(tag))
        }

        setFindCourseButton(with: spot.eta)
    }

    func overlayLoginLock(_ show: Bool) {
        loginlockOverlayView.isHidden = !show
    }

    func setFindCourseDelegate(_ delegate: (any SpotListCellDelegate)?) {
        self.findCourseDelegate = delegate
    }

}


// MARK: - Helper

private extension SpotListCollectionViewCell {

    func setBgImageAndShadow(from imageURL: String, noImageDescriptionID: Int) {
        bgImageView.kf.setImage(
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
                    updateUI(with: .loaded)
                    extractAndApplyShadowColor(from: value.image, for: imageURL)

                case .failure:
                    updateUI(with: .loadFailed)
                }
            }
        )
    }

    func setAcornCountButton(with acornCount: Int) {
        let acornString: String = acornCount > 9999 ? "+9999" : String(acornCount)
        acornCountButton.setAttributedTitle(text: String(acornString), style: .b1R)
    }

    func setFindCourseButton(with eta: Int) {
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

    func updateUI(with status: SpotImageStatusType) {
        switch status {
        case .loaded:
            [glassBgView, noImageContentView].forEach { $0.isHidden = true }

            gradientImageView.do {
                $0.image = .imgGra1
                $0.isHidden = false
                $0.removeGradient()
            }

        case .loadFailed:
            glassBgView.isHidden = false

            gradientImageView.do {
                $0.image = nil
                $0.isHidden = false
                $0.setTripleGradient()
            }

            noImageContentView.do {
                $0.isHidden = false
                $0.setDescription(status)
            }

        case .noImageDynamic:
            bgImageView.image = .imgSpotNoImageBackground
            glassBgView.isHidden = true

            gradientImageView.do {
                $0.image = nil
                $0.isHidden = true
                $0.removeGradient()
            }
            
            noImageContentView.do {
                $0.isHidden = false
                $0.setDescription(status)
            }

        case .noImageStatic: // NOTE: not for this view
            return
        }
    }

}
