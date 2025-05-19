//
//  CustomAlertType.swift
//  ACON-iOS
//
//  Created by 이수민 on 5/20/25.
//

import Foundation

enum CustomAlertType: CaseIterable {
    
    case essentialUpdate
    case plainUpdate
    
    case locationAccessDenied // 위치 권한 X
    case locationAccessFail // 위치 인식 실패 - 외국, GPS 지원 공간 X
    
    case reviewLocationFail // 리뷰 위치 인증 실패
    
    case libraryAccessDenied // 사진 권한 X
    case changeNotSaved // 프로필 변경사항 저장 X
    
    case changeVerifiedArea // 지역인증 변경 (지역 1개)
    
    case logout // TODO : 로그아웃 알럿 포함인지 기디측에 문의함. 현재 없음
    
    var title: String {
        switch self {
        case .essentialUpdate:
            return "필수적인 업데이트가 있습니다"
        case .plainUpdate:
            return "최신 버전 업데이트가 있습니다"
        case .locationAccessDenied:
            return "'Acon'에 대한 위치접근\n권한이 없습니다."
        case .locationAccessFail, .reviewLocationFail:
            return "위치 인식 실패"
            
        case .libraryAccessDenied:
            return "'Acon'에 대한 라이브러리\n읽기/쓰기 기능이 없습니다."
        case .changeNotSaved:
            return "변경사항이 저장되지 않았습니다."
            
        case .changeVerifiedArea:
            return "지역 삭제 불가"
        
        case .logout:
            return "로그아웃 하시겠어요?"
        }
    }
    
    var description: String? {
        switch self {
        case .locationAccessDenied:
            return "설정에서 위치접근 권한을 허용해주세요."
        case .locationAccessFail:
            return "문제가 발생했습니다.\n나중에 다시 시도해주세요."
        case .reviewLocationFail:
            return "현재 위치와 리뷰 등록 장소가\n오차범위 밖에 있습니다.\n좀 더 가까이 이동해보세요."
        case .libraryAccessDenied:
            return "설정에서 권한을 켤 수 있습니다."
        case .changeVerifiedArea:
            return "지역은 최소 1개 이상을 등록해야 해요.\n현재 설정된 지역을 변경할까요?"
//        case .logout:
//            return "현재 계정으로 다시 로그인하면\n데이터를 불러올 수 있어요"
        default:
            return nil
        }
    }
    
    var longButtonTitle: String? {
        switch self {
        case .essentialUpdate:
            return "업데이트"
        case .locationAccessDenied:
            return "설정으로 가기"
        case .changeVerifiedArea, .locationAccessFail, .reviewLocationFail:
            return "확인"
        default:
            return nil
        }
    }
    
    var leftButtonTitle: String? {
        switch self {
        case .plainUpdate, .libraryAccessDenied, .changeVerifiedArea, .logout:
            return "취소"
        case .changeNotSaved:
            return "계속 작성"
        default:
            return nil
        }
    }
    
    var rightButtonTitle: String? {
        switch self {
        case .plainUpdate:
            return "업데이트"
        case .libraryAccessDenied:
            return "설정으로 가기"
        case .changeNotSaved:
            return "나가기"
        case .changeVerifiedArea:
            return "변경하기"
        case .logout:
            return "로그아웃"
        default:
            return nil
        }
    }

    var isDangerButton: Bool {
        return false
    }
    
}
