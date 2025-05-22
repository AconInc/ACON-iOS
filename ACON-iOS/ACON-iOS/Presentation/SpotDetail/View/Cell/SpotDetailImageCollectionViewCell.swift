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

    let imageView = UIImageView()

    let imageErrorView = TempSpotListErrorView(.imageTitle) // TODO: 디자인 요청함


    // MARK: - Initializing

    override func setHierarchy() {
        super.setHierarchy()

        self.addSubviews(imageView, imageErrorView)
    }

    override func setLayout() {
        super.setLayout()

        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        imageErrorView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    override func setStyle() {
        super.setStyle()

        imageView.do {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
        }
        
        imageErrorView.do {
            $0.isHidden = true
            $0.setStyle(errorImage: .icAcornGlass,
                        errorMessage: StringLiterals.SpotList.preparingImages,
                        glassMorphismtype: .noImageErrorGlass)
        }
    }

}


// MARK: - @objc function

private extension SpotDetailImageCollectionViewCell {

    @objc
    func zooming(_ gesture: UIPinchGestureRecognizer) {
        if gesture.state == .ended {
            gesture.scale = 1.0
            imageView.clipsToBounds = true
        } else if gesture.state == .changed {
            imageView.clipsToBounds = false
        }
        imageView.transform = CGAffineTransform(scaleX: gesture.scale, y: gesture.scale)
    }

}


// MARK: - Internal Methods

extension SpotDetailImageCollectionViewCell {

    func setImage(imageURL: String) {
        imageView.kf.setImage(
            with: URL(string: imageURL),
            placeholder: UIImage.imgSkeletonBg,
            options: [.transition(.none), .cacheOriginalImage],
            completionHandler: { result in
                switch result {
                case .success:
                    self.imageErrorView.isHidden = true
                case .failure(let error):
                    print("😢 이미지 로드 실패: \(error)")
                    self.imageView.image = nil
                    self.imageErrorView.isHidden = false
                }
            }
        )
    }

}
