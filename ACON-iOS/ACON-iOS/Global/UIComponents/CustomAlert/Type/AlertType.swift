//
//  AlertType.swift
//  ACON-iOS
//
//  Created by Jaehyun Ahn on 1/16/25.
//

import UIKit

enum AlertType: CaseIterable {
    
    case stoppedPreferenceAnalysis // 온보딩 중
    case locationAccessFailImage // 이건 사진
    case locationAccessDenied // 업로드 중
    case uploadExit // 업로드 중
    
    var title: String {
        switch self {
        case .stoppedPreferenceAnalysis:
            return "취향분석을 그만둘까요?"
        case .locationAccessFailImage:
            return "위치 인식 실패"
        case .locationAccessDenied:
            return "위치를 확인할 수 없습니다."
        case .uploadExit:
            return "작성을 그만둘까요?"
        }
    }
    
    var content: String {
        switch self {
        case .stoppedPreferenceAnalysis:
            return "선호도 조사만이 남아있어요!\n1분 내로 빠르게 끝내실 수 있어요."
        case .locationAccessFailImage:
            return "현재 위치와 등록 장소가 오차 범위 밖에 있습니다.\n좀 더 가까이 이동해보세요."
        case .locationAccessDenied:
            return "acon을 사용하기 위해서는,\n설정에서 정확한 위치 권한을 허용해주세요."
        case .uploadExit:
            return "작성 중인 내용이 저장되지 않아요."
        }
    }
    
    var buttons: [String] {
        switch self {
        case .stoppedPreferenceAnalysis,
                .uploadExit:
            return ["그만두기", "계속하기"]
        case .locationAccessFailImage:
            return ["확인"]
        case .locationAccessDenied:
            return ["그만두기", "설정으로 가기"]
        }
    }

}
