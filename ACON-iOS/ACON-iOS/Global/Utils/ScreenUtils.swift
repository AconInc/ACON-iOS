//
//  StringUtils.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/6/25.
//

import UIKit

struct ScreenUtils {
    
    // MARK: 디바이스 width
    
    static var width: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    
    // MARK: 디바이스 height
    
    static var height: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    
    // MARK: - 비율 프로퍼티
    
    static var widthRatio: CGFloat {
        let figmaWidth: CGFloat = 360
        return width / figmaWidth
    }
    
    static var heightRatio: CGFloat {
        let figmaHeight: CGFloat = 740
        return height / figmaHeight
    }
    
    
    // MARK: - navBarView Height
    
    static var navViewHeight: CGFloat {
        return ScreenUtils.heightRatio * 54
    }
    
    static var safeAreaTopHeight: CGFloat {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return 0
        }
        return window.safeAreaInsets.top
    }

    
    // MARK: - horizontal inset
    
    static var horizontalInset: CGFloat {
        return ScreenUtils.widthRatio * 16
    }
    
}
