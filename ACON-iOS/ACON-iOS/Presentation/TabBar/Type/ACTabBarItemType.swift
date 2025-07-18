//
//  ACTabBarItem.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/11/25.
//

import UIKit

enum ACTabBarItemType: CaseIterable {
    
    case spotList, upload, profile
    
    var viewController: UIViewController {
        // TODO: ViewController 인스턴스 수정
        switch self {
        case .spotList: return SpotListViewController()
        case .upload: return SpotSearchViewController()
        case .profile: return ProfileViewController()
        }
    }
    
    var itemTitle: String {
        switch self {
        case .spotList: return StringLiterals.TabBar.spotList
        case .upload: return StringLiterals.TabBar.upload
        case .profile: return StringLiterals.TabBar.profile
        }
    }
    
    var normalItemImage: UIImage {
        switch self {
        case .spotList:
            return .icStarLightLine
        case .upload:
            return .icUpload
        case .profile:
            return .icProfileLine
        }
    }
    
    var selectedItemImage: UIImage {
        switch self {
        case .spotList:
            return .icStarLightFill
        case .upload:
            return .icUpload
        case .profile:
            return .icProfileFill
        }
    }
    
}
