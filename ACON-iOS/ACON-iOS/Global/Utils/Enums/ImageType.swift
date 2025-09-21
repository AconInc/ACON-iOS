//
//  ImageType.swift
//  ACON-iOS
//
//  Created by 이수민 on 2/19/25.
//

import Foundation

enum ImageType: String {

    case SPOT
    case MENUBOARD
    case PROFILE

    var allowedUTIs: Set<String> {
        switch self {
        case .SPOT:
            return ["public.jpeg", "public.heic", "org.webm.webp"]
        case .MENUBOARD, .PROFILE:
            return ["public.png", "public.jpeg", "public.heic", "org.webm.webp"]
        }
    }

    var compressionQuality: CGFloat {
        switch self {
        case .SPOT, .MENUBOARD:
            return 1.0
        case .PROFILE:
            return 0.7
        }
    }

}
