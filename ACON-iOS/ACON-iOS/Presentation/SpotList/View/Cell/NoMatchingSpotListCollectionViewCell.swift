//
//  NoMatchingSpotListCollectionViewCell.swift
//  ACON-iOS
//
//  Created by 김유림 on 5/29/25.
//

import UIKit

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

        self.addSubviews(glassBgView,
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

        loginLockOverlayView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    override func setStyle() {
        backgroundColor = .clear

        bgImageView.do {
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = cornerRadius
        }

        glassBgView.do {
            $0.isHidden = true
            $0.clipsToBounds = true
            $0.layer.cornerRadius = cornerRadius
        }

        gradientImageView.do {
            $0.clipsToBounds = true
            $0.image = .imgGra1
            $0.layer.cornerRadius = cornerRadius
        }

        titleLabel.do {
            $0.numberOfLines = 1
            $0.lineBreakMode = .byTruncatingTail
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

        loginLockOverlayView.do {
            $0.isHidden = true
            $0.clipsToBounds = true
            $0.layer.cornerRadius = cornerRadius
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        gradientImageView.do {
            $0.image = nil
            $0.removeGradient()
        }

        tagStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

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

        titleLabel.do {
            $0.setLabel(text: spot.name, style: .t4SB, numberOfLines: 1)
            $0.lineBreakMode = .byTruncatingTail
        }

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
        let acornString: String = acornCount > 9999 ? "+9999" : String(acornCount)
        acornCountButton.setAttributedTitle(text: String(acornString), style: .b1R)
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
        findCourseButton.setAttributedTitle(text: courseTitle, style: .b1SB)
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

        case .noImageStatic:
            glassBgView.isHidden = true

            bgImageView.image = .imgSpotNoImageBackground

            gradientImageView.do {
                $0.image = nil
                $0.isHidden = true
                $0.removeGradient()
            }

            noImageContentView.do {
                $0.isHidden = false
                $0.setDescription(status)
            }

        case .noImageDynamic: // NOTE: not for this view
            return
        }
    }

}
