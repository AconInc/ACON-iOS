//
//  UICollectionViewCell+.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/6/25.
//

import UIKit

extension UICollectionViewCell {
    
    // MARK: - Cell identifier
    
    static var cellIdentifier : String {
        return String(describing: self)
    }
    
}
