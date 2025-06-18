//
//  MenuCollectionViewCell.swift
//  ACON-iOS
//
//  Created by 김유림 on 5/13/25.
//

import UIKit

import Kingfisher

final class MenuCollectionViewCell: BaseCollectionViewCell {

    // MARK: - Properties

    var onZooming: ((Bool) -> Void)?

    private let imageLoadErrorBgView = UIView()

    private let imageView = UIImageView()

    private let imageLoadErrorLabel = UILabel()

    private let imageWidth: CGFloat = 230 * ScreenUtils.widthRatio
    private let imageHeight: CGFloat = 325 * ScreenUtils.heightRatio


    // MARK: - Initializing

    override func setHierarchy() {
        super.setHierarchy()

        contentView.addSubviews(imageLoadErrorBgView, imageView, imageLoadErrorLabel)
    }

    override func setLayout() {
        super.setLayout()

        imageLoadErrorBgView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(imageWidth)
            $0.height.equalTo(imageHeight)
        }

        imageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(imageWidth)
            $0.height.equalTo(imageHeight)
        }
        
        imageLoadErrorLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    override func setStyle() {
        super.setStyle()

        self.backgroundColor = .clear

        contentView.do {
            let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(zooming))
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(pinchGesture)
        }

        imageView.do {
            $0.contentMode = .scaleAspectFit
            $0.clipsToBounds = true
        }

        imageLoadErrorBgView.do {
            $0.backgroundColor = .gray900
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 4
        }

        imageLoadErrorLabel.do {
            $0.isHidden = true
            $0.setLabel(text: StringLiterals.SpotList.imageLoadingFailed, style: .t5SB, color: .gray50)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        imageView.image = nil
        imageLoadErrorBgView.isHidden = true
        imageLoadErrorLabel.isHidden = true
    }

}


// MARK: - @objc function

private extension MenuCollectionViewCell {

    @objc
    func zooming(_ gesture: UIPinchGestureRecognizer) {
        switch gesture.state {
        case .ended:
            gesture.scale = 1.0
            imageView.clipsToBounds = true
            onZooming?(false)
        case .changed:
            imageView.clipsToBounds = false
            onZooming?(true)
        default: break
        }

        imageView.transform = CGAffineTransform(scaleX: gesture.scale, y: gesture.scale)
    }

}


// MARK: - Internal Methods

extension MenuCollectionViewCell {

    func setImage(imageURL: String, isPinchable: Bool) {
        imageView.kf.setImage(
            with: URL(string: imageURL),
            placeholder: UIImage.imgSkeletonBg,
            options: [.transition(.none), .cacheOriginalImage],
            completionHandler: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success:
                    [imageLoadErrorBgView, imageLoadErrorLabel].forEach { $0.isHidden = true }
                case .failure:
                    imageView.image = nil
                    [imageLoadErrorBgView, imageLoadErrorLabel].forEach { $0.isHidden = false }
                }
            }
        )
    }

}
