//
//  SpotDetailImageCollectionViewCell.swift
//  ACON-iOS
//
//  Created by 김유림 on 5/13/25.
//

import UIKit

import Kingfisher

class SpotDetailImageCollectionViewCell: BaseCollectionViewCell {

    // MARK: - Properties

    private let glassBgView = GlassmorphismView(.noImageErrorGlass)

    private let imageView = UIImageView()

    private let gradientImageView = UIImageView()

    private let noImageContentView = SpotNoImageContentView(.iconAndDescription)


    // MARK: - Initializing

    override func setHierarchy() {
        super.setHierarchy()

        self.addSubviews(glassBgView, imageView, gradientImageView, noImageContentView)
    }

    override func setLayout() {
        super.setLayout()

        [glassBgView, imageView, gradientImageView].forEach {
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }

        noImageContentView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(268 * ScreenUtils.heightRatio)
            $0.centerX.equalToSuperview()
        }
    }

    override func setStyle() {
        backgroundColor = .acWhite

        glassBgView.isHidden = true

        imageView.do {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
        }

        gradientImageView.contentMode = .scaleAspectFill

        noImageContentView.do {
            $0.setDescription(.loadFailed)
            $0.isHidden = true
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        imageView.do {
            $0.kf.cancelDownloadTask()
            $0.image = nil
        }

        gradientImageView.do {
            $0.image = nil
            $0.removeGradient()
        }

        [glassBgView, noImageContentView].forEach { $0.isHidden = true }

        DispatchQueue.main.async { [weak self] in
            self?.gradientImageView.removeGradient()
            self?.glassBgView.refreshBlurEffect()
        }
    }

}


// MARK: - Internal Methods

extension SpotDetailImageCollectionViewCell {

    func setImage(imageURL: String) {
        imageView.kf.setImage(
            with: URL(string: imageURL),
            placeholder: UIImage.imgSkeletonBg,
            options: [.transition(.none), .cacheOriginalImage],
            completionHandler: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success:
                    glassBgView.isHidden = true
                    gradientImageView.image = .imgGra2

                case .failure:
                    gradientImageView.do {
                        $0.image = nil
                        $0.setTripleGradient(topColor: .acBlack,
                                             middleColor: .acBlack.withAlphaComponent(0.5),
                                             bottomColor: .acBlack)
                    }
                    [glassBgView, noImageContentView].forEach { $0.isHidden = false }
                }
            }
        )
    }

}
