//
//  CustomAlertType.swift
//  ACON-iOS
//
//  Created by 이수민 on 5/20/25.
//

import Foundation

enum ACAlertType: CaseIterable {
    
    case essentialUpdate // NOTE: 강제업데이트
    case plainUpdate // NOTE: 일반업데이트
    
    case locationAccessDenied // NOTE: 위치 권한 X
    case locationAccessFail // NOTE: 위치 인식 실패 - 외국, GPS 지원 공간 X
    
    case reviewLocationFail // NOTE: 리뷰 위치 인증 실패
    
    case naverAPILimitExceeded // NOTE: 일일 네이버 API 호출 가능 횟수 (25000회) 초과
    case quitSpotUpload // NOTE: 장소 등록 취소
    
    case libraryAccessDenied // NOTE: 사진 권한 X
    case changeNotSaved // NOTE: 프로필 변경사항 저장 X
    
    case changeVerifiedArea // NOTE: 지역인증 변경 (지역 1개)
    case timeoutFromVerification // NOTE: 지역인증 변경 (인증 1주일 - 3개월)
    
    case quitOnboarding // NOTE: 취향탐색 그만두기
    
    case logout // NOTE: 로그아웃
    
    case deletePhoto // NOTE: 사진 삭제 (장소 업로드)
    case spotUploadFail // NOTE: 장소 업로드 실패
    
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
        
        case .naverAPILimitExceeded:
            return "장소 등록 마감"
        case .quitSpotUpload:
            return "등록을 취소하시겠습니까?"
            
        case .libraryAccessDenied:
            return "'Acon'에 대한 라이브러리\n읽기/쓰기 기능이 없습니다."
        case .changeNotSaved:
            return "변경사항이 저장되지 않았습니다."
            
        case .changeVerifiedArea, .timeoutFromVerification:
            return "지역 삭제 불가"
        
        case .quitOnboarding:
            return "취향탐색을 그만둘까요?"
            
        case .logout:
            return "로그아웃 하시겠어요?"
            
        case .deletePhoto:
            return "사진을 삭제 하시겠습니까?"
            
        case .spotUploadFail:
            return "장소 업로드 실패"
        }
    }
    
    var description: String? {
        switch self {
        case .locationAccessDenied:
            return "설정에서 위치접근 권한을 허용해주세요."
        case .locationAccessFail, .spotUploadFail:
            return "문제가 발생했습니다.\n나중에 다시 시도해주세요."
        case .reviewLocationFail:
            return "현재 위치와 리뷰 등록 장소가\n오차범위 밖에 있습니다.\n좀 더 가까이 이동해보세요."
        case .naverAPILimitExceeded:
            return "오늘 너무 많은 장소가 등록돼서\n새로운 장소 등록이 불가능해요.\nAcon Instagram을 통해 제보할 수 있어요."
        case .libraryAccessDenied:
            return "설정에서 권한을 켤 수 있습니다."
        case .changeVerifiedArea:
            return "지역은 최소 1개 이상을 등록해야 해요.\n현재 설정된 지역을 변경할까요?"
        case .timeoutFromVerification:
            return "인증한 지 1주일이 지난 지역은\n3개월 간 삭제가 불가능해요."
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
        case .locationAccessFail, .reviewLocationFail, .timeoutFromVerification:
            return "확인"
        default:
            return nil
        }
    }
    
    var leftButtonTitle: String? {
        switch self {
        case .plainUpdate, .libraryAccessDenied, .changeVerifiedArea, .logout, .deletePhoto, .quitSpotUpload:
            return "취소"
        case .naverAPILimitExceeded:
            return "끝내기"
        case .changeNotSaved:
            return "계속 작성"
        case .quitOnboarding:
            return "계속하기"
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
        case .naverAPILimitExceeded:
            return "제보하기"
        case .changeNotSaved, .quitSpotUpload:
            return "나가기"
        case .changeVerifiedArea:
            return "변경하기"
        case .quitOnboarding:
            return "그만두기"
        case .logout:
            return "로그아웃"
        case .deletePhoto:
            return "삭제"
        default:
            return nil
        }
    }

    var isDangerButton: Bool {
        return false
    }
    
}
