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

    var onBackgroundTapped: (() -> Void)?

    private let imageView = UIImageView()

    private let noImageErrorView = SpotListErrorView(.imageTitle)

    private let imageWidth: CGFloat = 230 * ScreenUtils.widthRatio
    private let imageHeight: CGFloat = 325 * ScreenUtils.heightRatio


    // MARK: - Initializing

    override func setHierarchy() {
        super.setHierarchy()

        self.addSubviews(imageView, noImageErrorView)
    }

    override func setLayout() {
        super.setLayout()

        imageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(imageWidth)
            $0.height.equalTo(imageHeight)
        }
        
        noImageErrorView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    override func setStyle() {
        super.setStyle()

        self.do {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedBackground))
            $0.backgroundColor = .clear
            $0.addGestureRecognizer(tapGesture)
        }

        imageView.do {
            let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(zooming))
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(pinchGesture)
        }
        
        noImageErrorView.do {
            $0.isHidden = true
            $0.setStyle(errorImage: .icAcornGlass,
                        errorMessage: StringLiterals.SpotList.preparingImages,
                        glassMorphismtype: .noImageErrorGlass)
        }
    }

}


// MARK: - @objc function

private extension MenuCollectionViewCell {

    @objc
    private func zooming(_ gesture: UIPinchGestureRecognizer) {
        switch gesture.state {
        case .ended:
            gesture.scale = 1.0
            imageView.clipsToBounds = true
        case .changed:
            imageView.clipsToBounds = false
        default: break
        }

        imageView.transform = CGAffineTransform(scaleX: gesture.scale, y: gesture.scale)
    }

    @objc
    private func tappedBackground(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: self)
        if imageView.frame.contains(location) { return }

        onBackgroundTapped?()
    }

}


// MARK: - Internal Methods

extension MenuCollectionViewCell {

    func setImage(imageURL: String, isPinchable: Bool) {
        imageView.kf.setImage(
            with: URL(string: imageURL),
            placeholder: UIImage.imgSkeletonBg,
            options: [.transition(.none), .cacheOriginalImage],
            completionHandler: { result in
                switch result {
                case .success:
                    self.noImageErrorView.isHidden = true
                case .failure(let error):
                    print("😢 이미지 로드 실패: \(error)")
                    self.imageView.image = nil
                    self.noImageErrorView.isHidden = false
                }
            }
        )
    }

}
