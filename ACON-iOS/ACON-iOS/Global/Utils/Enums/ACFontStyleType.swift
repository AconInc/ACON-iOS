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
    static var h2: ACFontStyleType { ACFont.h2 }
    static var h3: ACFontStyleType { ACFont.h3 }
    static var h4: ACFontStyleType { ACFont.h4 }
    static var h5: ACFontStyleType { ACFont.h5 }
    static var h6: ACFontStyleType { ACFont.h6 }
    static var h7: ACFontStyleType { ACFont.h7 }
    static var h8: ACFontStyleType { ACFont.h8 }
    
    static var t1: ACFontStyleType { ACFont.t1 }
    static var t2: ACFontStyleType { ACFont.t2 }
    static var t3: ACFontStyleType { ACFont.t3 }
    
    static var s1: ACFontStyleType { ACFont.s1 }
    static var s2: ACFontStyleType { ACFont.s2 }
    
    static var b1: ACFontStyleType { ACFont.b1 }
    static var b2: ACFontStyleType { ACFont.b2 }
    static var b3: ACFontStyleType { ACFont.b3 }
    static var b4: ACFontStyleType { ACFont.b4 }
    
    static var c1: ACFontStyleType { ACFont.c1 }
    
}
