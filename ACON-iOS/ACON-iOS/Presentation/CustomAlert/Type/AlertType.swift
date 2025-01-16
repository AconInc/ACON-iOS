//
//  AlertType.swift
//  ACON-iOS
//
//  Created by Jaehyun Ahn on 1/16/25.
//

import Foundation

import UIKit

enum AlertType: CaseIterable {
    
    case locationAccessDeniedOneButton  // 위치접근 허용 안함 (1개 버튼)
    case locationAccessDenied           // 위치접근 허용 안함 (2개 버튼)
    case locationAccessFail             // 위치 인식 실패 (1개 버튼)
    case locationAccessFailImage        // 위치 인식 실패 (이미지 + 1개 버튼)
    case stoppedWriting                 // 작성을 그만둠 (2개 버튼)
    case stoppedPreferenceAnalysis      // 취향분석 그만둠 (2개 버튼)
    
    var title: String {
        switch self {
        case .locationAccessDeniedOneButton:
            return "‘acon’에 대해 위치 접근\n 권한이 없습니다."
        case .locationAccessDenied:
            return "위치를 확인할 수 없습니다."
        case .locationAccessFail:
            return "위치 인식 실패"
        case .locationAccessFailImage:
            return "위치 인식 실패"
        case .stoppedWriting:
            return "작성을 그만둘까요?"
        case .stoppedPreferenceAnalysis:
            return "취향분석을 그만둘까요?"
        }
    }
    
    var content: String {
        switch self {
        case .locationAccessDeniedOneButton:
            return "설정에서 정확한 위치 권한을 허용해주세요."
        case .locationAccessDenied:
            return "acon 사용을 위해서는,\n 설정에서 위치 접근 권한을 허용해주세요."
        case .locationAccessFail:
            return "현재 위치와 등록 장소가 오차 범위 밖에 있습니다. 좀 더 가까이 이동해보세요."
        case .locationAccessFailImage:
            return "현재 위치와 등록 장소가 오차 범위 밖에 있습니다. 좀 더 가까이 이동해보세요."
        case .stoppedWriting:
            return "작성 중인 내용이 저장되지 않아요."
        case .stoppedPreferenceAnalysis:
            return "선호도 조사만 남아있어요! 1분 내로 빠르게 끝내실 수 있어요."
        }
    }
    
    var buttons: [String] {
        switch self {
        case .locationAccessDeniedOneButton:
            return ["설정으로 가기"]
        case .locationAccessDenied:
            return ["그만두기", "설정으로 가기"]
        case .locationAccessFail:
            return ["확인"]
        case .locationAccessFailImage:
            return ["확인"]
        case .stoppedWriting:
            return ["그만두기", "계속하기"]
        case .stoppedPreferenceAnalysis:
            return ["그만두기", "계속하기"]
        }
    }
    
    var hasImage: Bool {
        switch self {
        case .locationAccessFailImage:
            return true
        default:
            return false
        }
    }
    
    /// If navigation is required (e.g., to Settings)
    var navigationAction: (() -> Void)? {
        switch self {
        case .locationAccessDeniedOneButton, .locationAccessDenied:
            return {
                // Navigate to app settings
                print("Navigating to settings...")
            }
        default:
            return nil
        }
    }
}
