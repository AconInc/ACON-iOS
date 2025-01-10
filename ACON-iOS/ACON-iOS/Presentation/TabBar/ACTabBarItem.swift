//
//  ACTabBarItem.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/11/25.
//

import UIKit

enum ACTabBarItem: CaseIterable {
    
    case place, upload, profile
    
    var viewController: UIViewController {
        // TODO: ViewController 인스턴스 수정
        switch self {
        case .place: return PlaceViewController()
        case .upload: return ViewController()
        case .profile: return ProfileViewController()
        }
    }
    
    var itemTitle: String {
        switch self {
        case .place: return "장소"
        case .upload: return "업로드"
        case .profile: return "프로필"
        }
    }
    
    var normalItemImage: UIImage {
        switch self {
        case .place:
            return .icSpotGla24
        case .upload:
            return .icUploadGla24
        case .profile:
            return .icMypageGla24
        }
    }
    
    var selectedItemImage: UIImage {
        switch self {
        case .place:
            return .icSpotW24
        case .upload:
            return .icUploadW24
        case .profile:
            return .icMypageW24
        }
    }
    
}
