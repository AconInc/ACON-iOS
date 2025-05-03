//
//  UIImage+.swift
//  ACON-iOS
//
//  Created by 김유림 on 5/4/25.
//

import UIKit

extension UIImage {

    /// 이미지의 크기를 지정한 사이즈로 리사이징합니다.
    func resize(to targetSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }

}
