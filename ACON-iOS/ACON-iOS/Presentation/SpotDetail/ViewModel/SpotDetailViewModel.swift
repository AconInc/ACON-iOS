//
//  SpotDetailViewModel.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/16/25.
//

import UIKit

import CoreLocation
import MapKit

class SpotDetailViewModel: Serviceable {
    
    let spotID: Int64
    let tagList: [SpotTagType]
    
    let onSuccessGetSpotDetail: ObservablePattern<Bool> = ObservablePattern(nil)
        
    var spotDetail: ObservablePattern<SpotDetailInfoModel> = ObservablePattern(nil)

    // TODO: DTO 수정 후 삭제
    private lazy var spotDetailDummy = SpotDetailInfoModel(
        spotID: spotID,
        imageURLs: self.spotID == 1 ? [] : imageURLs,
        name: self.spotID == 1 ? "이미지없는 식당" : "장소상세더미장소상세더미장소상세더미장소상세더미장소상세더미장소상세더미장소상세더미",
        acornCount: 10000,
        hasMenuboardImage: true,
        signatureMenuList: [
            SignatureMenuModel(name: "Free", price: 0),
            SignatureMenuModel(name: "맛있는메뉴1", price: 13000),
            SignatureMenuModel(name: "Very loooong name", price: 999999)
        ],
        latitude: 37.587038,
        longitude: 127.0310,
        tagList: tagList
    )
    
    let imageURLs: [String] = ["https://i.pinimg.com/originals/05/b4/fb/05b4fbc3f169175e6deb97b3977175b6.jpg","wrongURL","https://cdn.kmecnews.co.kr/news/photo/202311/32217_20955_828.jpg","https://images.immediate.co.uk/production/volatile/sites/30/2022/03/Pancake-grazing-board-bc15106.jpg?quality=90&resize=556,505","https://natashaskitchen.com/wp-content/uploads/2020/03/Pan-Seared-Steak-4.jpg","https://i.namu.wiki/i/oFHlYDjoEh8f-cc3lNK9jAemRkbXxNGwUg7XiW5LGS6DF1P2x8GCeNQxbQhVIwtUS1u53YPw-uoyqpmLtrGNJA.webp","https://i.namu.wiki/i/dgjXU86ae29hDSCza-L0GZlFt3T9lRx1Ug9cKtqWSzMzs7Cd0CN2SzyLFEJcHVFviKcxAlIwxcllT9s2sck0RA.jpg","https://www.bhc.co.kr/upload/bhc/menu/%EC%96%91%EB%85%90%EC%B9%98%ED%82%A8_%EC%BD%A4%EB%B3%B4_410x271.jpg","https://cdn.kmecnews.co.kr/news/photo/202311/32217_20955_828.jpg"]
    let menuImageURLs: [String] = ["https://marketplace.canva.com/EAGEDq-_tZQ/1/0/1035w/canva-grey-and-beige-minimalist-restaurant-menu-hb5BNMWcQS4.jpg","https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSmR-HwbkD_gFMN5Mv3fKRikt-IeJpYbayxAQ&s","https://t3.ftcdn.net/jpg/01/75/06/34/360_F_175063465_nPAUPd3x4uoqbmKyGqDLRDsIvMejnraQ.jpg","https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS3fjP3BWKbK_YDzsVBsI3EXKr7q0JCYMZWKQ&s"
    ]

    var mapType: String = "APPLE"
    
    let sname = "내 위치"
    
    init(_ spotID: Int64, _ tagList: [SpotTagType]) {
        self.spotID = spotID
        self.tagList = tagList
    }

}

// MARK: - 서버 통신 메소드

extension SpotDetailViewModel {
    
    func getSpotDetail() {
        self.spotDetail.value = spotDetailDummy
        self.onSuccessGetSpotDetail.value = true
//        ACService.shared.spotDetailService.getSpotDetail(spotID: spotID) { [weak self] response in
//            switch response {
//            case .success(let data):
//                let spotDetailData = SpotDetailInfoModel(from: data, tagList: self?.tagList ?? [])
//                self?.spotDetail.value = spotDetailData
//                self?.onSuccessGetSpotDetail.value = true
//            case .reIssueJWT:
//                self?.handleReissue { [weak self] in
//                    self?.getSpotDetail()
//                }
//            default:
//                print("VM - Failed To getSpotDetail")
////#if DEBUG
//                // TODO: 삭제
//                self?.spotDetail.value = self?.spotDetailDummy
//                self?.onSuccessGetSpotDetail.value = true
//                return
////#endif
//                // TODO: 주석 해제
////                self?.onSuccessGetSpotDetail.value = false
////                return
//            }
//        }
    }

    func postGuidedSpot() {
        ACService.shared.spotDetailService.postGuidedSpot(spotID: spotID){ [weak self] response in
            switch response {
            case .success:
                return
            case .reIssueJWT:
                self?.handleReissue { [weak self] in
                    self?.postGuidedSpot()
                }
            default:
                print("VM - Failed To postGuidedSpot")
                return
            }
        }
    }
    
}
