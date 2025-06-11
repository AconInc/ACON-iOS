//
//  SpotListSkeletonHeader.swift
//  ACON-iOS
//
//  Created by 김유림 on 6/12/25.
//

import UIKit

import SkeletonView

class SpotListSkeletonHeader: UICollectionReusableView {

    // MARK: - UI Properties

    private let skeletonView = UIView()


    // MARK: - Life Cycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setHierarchy()
        setLayout()
        setStyle()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setHierarchy() {
        self.addSubview(skeletonView)
    }

    private func setLayout() {
        skeletonView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(8)
            $0.width.equalTo(100 * ScreenUtils.widthRatio)
            $0.height.equalTo(28)
        }
    }

    private func setStyle() {
        self.do {
            $0.backgroundColor = .clear
            $0.isSkeletonable = true
        }

        skeletonView.do {
            $0.isSkeletonable = true
            $0.skeletonCornerRadius = 8
        }
    }

}
