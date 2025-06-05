//
//  ShadowColorCache.swift
//  ACON-iOS
//
//  Created by 김유림 on 6/5/25.
//

import UIKit

class ShadowColorCache {

    // MARK: - Properties

    static let shared = ShadowColorCache()

    static let noImageKey: String = "noImage"

    private let cache = NSCache<NSString, UIColor>()


    // MARK: - Methods

    func color(for key: String) -> UIColor? {
        return cache.object(forKey: key as NSString)
    }

    func setColor(_ color: UIColor, for key: String) {
        cache.setObject(color, forKey: key as NSString)
    }

}
