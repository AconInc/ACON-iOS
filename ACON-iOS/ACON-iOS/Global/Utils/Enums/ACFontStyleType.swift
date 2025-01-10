//
//  ACFontStyleType.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/10/25.
//

import UIKit

struct ACFontStyleType {
    
    let font: UIFont
    let kerning: CGFloat
    let lineHeight: CGFloat
    
}

extension ACFontStyleType {
    
    static var h1: ACFontStyleType { ACFont.h1 }
    
}
