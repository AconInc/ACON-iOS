//
//  NoMatchingSpotListCollectionViewCell.swift
//  ACON-iOS
//
//  Created by 김유림 on 5/29/25.
//

import UIKit

import SkeletonView

class NoMatchingSpotListCollectionViewCell: BaseCollectionViewCell {

    // MARK: - Properties

    var spot: SpotModel?

    var findCourseDelegate: SpotListCellDelegate?


    // MARK: - UI Properties

    private let glassBgView = GlassmorphismView(.noImageErrorGlass)
    private let bgImageView = UIImageView()
    private let gradientImageView = UIImageView()

    private let noImageContentView = SpotNoImageContentView(.descriptionOnly)
    private let loginLockOverlayView = LoginLockOverlayView()

    private let titleLabel = UILabel()
    private let acornCountButton = UIButton()
    private let tagStackView = UIStackView()
    private let findCourseButton = ACButton(style: GlassButton(glassmorphismType: .buttonGlassDefault, buttonType: .full_10_b1SB))

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

        contentView.addSubviews(glassBgView,
                                bgImageView,
                                gradientImageView,
                                noImageContentView,
                                titleLabel,
                                acornCountButton,
                                tagStackView,
                                findCourseButton,
                                loginLockOverlayView)
    }

    override func setLayout() {
        super.setLayout()

        let edge = ScreenUtils.horizontalInset

        glassBgView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        bgImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        gradientImageView.snp.makeConstraints {
            $0.edges.equalTo(bgImageView)
        }

        noImageContentView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(76)
        }

        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(edge)
            $0.trailing.equalTo(acornCountButton.snp.leading).offset(-8)
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

        findCourseButton.snp.makeConstraints {
            $0.bottom.trailing.equalToSuperview().inset(edge)
            $0.width.equalTo(140)
            $0.height.equalTo(36)
        }

        loginLockOverlayView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    override func setStyle() {
        self.do {
            $0.backgroundColor = .clear
            $0.isSkeletonable = true
        }

        bgImageView.do {
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = cornerRadius
            $0.image = .imgSkeletonBg
            $0.isSkeletonable = true
            $0.skeletonCornerRadius = Float(cornerRadius)
        }

        glassBgView.do {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = cornerRadius
            $0.isHidden = true
        }

        noImageContentView.isHidden = true

        gradientImageView.do {
            $0.clipsToBounds = true
            $0.image = .imgGra1
            $0.layer.cornerRadius = cornerRadius
            $0.isHidden = true
        }

        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

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

        tagStackView.do {
            $0.spacing = 4
        }

        findCourseButton.do {
            $0.updateGlassButtonState(state: .default)
        }

        loginLockOverlayView.do {
            $0.isHidden = true
            $0.clipsToBounds = true
            $0.layer.cornerRadius = cornerRadius
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        updateUI(with: .loading)

        tagStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        glassBgView.refreshBlurEffect()
        findCourseButton.refreshButtonBlurEffect(.buttonGlassDefault)
    }

    private func addTarget() {
        findCourseButton.addTarget(self, action: #selector(tappedFindCourseButton), for: .touchUpInside)
    }

}


// MARK: - @objc functions

private extension NoMatchingSpotListCollectionViewCell {

    @objc func tappedFindCourseButton() {
        guard let spot = spot else { return }
        findCourseDelegate?.tappedFindCourseButton(spot: spot)
    }

}


// MARK: - Binding

extension NoMatchingSpotListCollectionViewCell: SpotListCellConfigurable {

    func bind(spot: SpotModel) {
        self.spot = spot

        if let imageURL = spot.imageURL {
            setBgImage(from: imageURL)
        } else {
            updateUI(with: .noImageStatic)
        }

        titleLabel.setLabel(text: spot.name,
                            style: .t4SB,
                            numberOfLines: 1,
                            lineBreakMode: .byTruncatingTail)

        setAcornCountButton(with: spot.acornCount)

        setTagStackView(with: spot.tagList)

        setFindCourseButton(with: spot.eta)
    }

    func overlayLoginLock(_ show: Bool) {
        loginLockOverlayView.isHidden = !show
    }

    func setFindCourseDelegate(_ delegate: (any SpotListCellDelegate)?) {
        self.findCourseDelegate = delegate
    }

}


// MARK: - Helper

private extension NoMatchingSpotListCollectionViewCell {

    func setBgImage(from imageURL: String) {
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
                case .success: updateUI(with: .loaded)
                case .failure: updateUI(with: .loadFailed)
                }
            }
        )
    }

    func setAcornCountButton(with acornCount: Int) {
        if acornCount > 0 {
            let acornString: String = acornCount > 9999 ? "+9999" : String(acornCount)
            acornCountButton.do {
                $0.setAttributedTitle(text: String(acornString), style: .b1R)
                $0.isHidden = false
            }
        }
    }

    func setTagStackView(with tags: [SpotTagType]) {
        if !tags.isEmpty {
            tags.forEach { tag in
                tagStackView.addArrangedSubview(SpotTagButton(tag))
            }

            noImageContentView.snp.updateConstraints {
                $0.top.equalToSuperview().offset(88)
            }
        }
    }

    func setFindCourseButton(with eta: Int) {
        let bike: String = StringLiterals.SpotList.bike
        let findCourse: String = StringLiterals.SpotList.minuteFindCourse
        let courseTitle: String = bike + String(eta) + findCourse
        findCourseButton.do {
            $0.setAttributedTitle(text: courseTitle, style: .b1SB)
            $0.isHidden = false
        }
    }

    func updateUI(with status: SpotImageStatusType) {
        switch status {
        case .loading:
            [glassBgView, noImageContentView, gradientImageView, acornCountButton, findCourseButton].forEach { $0.isHidden = true }

            titleLabel.text = nil
            
            bgImageView.do {
                $0.kf.cancelDownloadTask()
                $0.image = .imgSkeletonBg
            }

            gradientImageView.do {
                $0.image = nil
                $0.removeGradient()
            }

        case .loaded:
            [glassBgView, noImageContentView].forEach { $0.isHidden = true }

            gradientImageView.do {
                $0.image = .imgGra1
                $0.isHidden = false
                $0.removeGradient()
            }

        case .loadFailed:
            [glassBgView, gradientImageView, noImageContentView].forEach { $0.isHidden = false }

            bgImageView.image = nil

            gradientImageView.do {
                $0.image = nil
                $0.setTripleGradient()
            }

            noImageContentView.do {
                $0.setDescription(status)
            }

        case .noImageStatic:
            [glassBgView, gradientImageView].forEach { $0.isHidden = true }
            noImageContentView.isHidden = false

            bgImageView.image = .imgSpotNoImageBackground

            gradientImageView.do {
                $0.image = nil
                $0.removeGradient()
            }

            noImageContentView.do {
                $0.setDescription(status)
            }

        default: return
        }
    }

}
