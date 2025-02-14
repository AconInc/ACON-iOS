//
//  UITableViewCell+.swift
//  ACON-iOS
//
//  Created by 이수민 on 2/13/25.
//

import UIKit

extension UITableViewCell {
    
    // MARK: - Cell identifier
    
    static var cellIdentifier : String {
        return String(describing: self)
    }
    
}
