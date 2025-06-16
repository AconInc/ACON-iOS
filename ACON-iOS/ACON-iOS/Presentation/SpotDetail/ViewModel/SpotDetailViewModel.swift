//
//  SpotDetailViewModel.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/16/25.
//

import UIKit
import CoreLocation
import MapKit

import BranchSDK

class SpotDetailViewModel: Serviceable {

    let spotID: Int64
    
    let onSuccessGetSpotDetail: ObservablePattern<Bool> = ObservablePattern(nil)
    let onSuccessGetMenuboardImageList: ObservablePattern<Bool> = ObservablePattern(nil)
    var onSuccessPostSavedSpot: ObservablePattern<Bool> = ObservablePattern(nil)
    var onSuccessDeleteSavedSpot: ObservablePattern<Bool> = ObservablePattern(nil)

    var spotDetail: SpotDetailInfoModel? = nil

    var menuImageURLs: [String] = []

    init(_ spotID: Int64) {
        self.spotID = spotID
    }

}

// MARK: - 서버 통신 메소드

extension SpotDetailViewModel {
    
    func getSpotDetail() {
        ACService.shared.spotDetailService.getSpotDetail(spotID: spotID) { [weak self] response in
            switch response {
            case .success(let data):
                let spotDetailData = SpotDetailInfoModel(from: data)
                self?.spotDetail = spotDetailData
                self?.onSuccessGetSpotDetail.value = true
            case .reIssueJWT:
                self?.handleReissue { [weak self] in
                    self?.getSpotDetail()
                }
            default:
                self?.onSuccessGetSpotDetail.value = false
                return
            }
        }
    }

    func getMenuboardImageList() {
        ACService.shared.spotDetailService.getSpotMenuboardImageList(spotID: spotID) { [weak self] response in
            switch response {
            case .success(let data):
                self?.menuImageURLs = data.menuboardImageList
                self?.onSuccessGetMenuboardImageList.value = true
            case .reIssueJWT:
                self?.handleReissue { [weak self] in
                    self?.getMenuboardImageList()
                }
            default:
                self?.onSuccessGetMenuboardImageList.value = false
                return
            }
        }
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
                return
            }
        }
    }

    func postSavedSpot() {
        ACService.shared.spotDetailService.postSavedSpot(spotID: spotID){ [weak self] response in
            switch response {
            case .success:
                self?.onSuccessPostSavedSpot.value = true
                return
            case .reIssueJWT:
                self?.handleReissue { [weak self] in
                    self?.postGuidedSpot()
                }
            default:
                self?.onSuccessPostSavedSpot.value = false
                return
            }
        }
    }

    func deleteSavedSpot() {
        ACService.shared.spotDetailService.deleteSavedSpot(spotID: spotID){ [weak self] response in
            switch response {
            case .success:
                self?.onSuccessDeleteSavedSpot.value = true
                return
            case .reIssueJWT:
                self?.handleReissue { [weak self] in
                    self?.postGuidedSpot()
                }
            default:
                self?.onSuccessDeleteSavedSpot.value = false
                return
            }
        }
    }

}


// MARK: - 딥링크 메소드

extension SpotDetailViewModel {

    func createBranchDeepLink() {
        guard let buo: BranchUniversalObject = makeBranchUniversalObject() else { return }
        let lp: BranchLinkProperties = makeBranchLinkProperties()
        buo.getShortUrl(with: lp) { url, error in
            if let error {
                print("🔗❌ 딥링크 생성 실패: \(error.localizedDescription)")
                return
            }

            guard let url = url else {
                print("🔗❓ 딥링크 생성은 성공했으나 URL == nil")
                return
            }

            print("🔗✅ deeplink 생성 성공: \(url)")
        }
    }

    private func makeBranchUniversalObject() -> BranchUniversalObject? {
        guard let spot = spotDetail else { return nil }
        let buo: BranchUniversalObject = BranchUniversalObject(canonicalIdentifier: "item/12345")
        buo.title = "[Acon] \(spot.name)"
        buo.contentDescription = "앱에서 가게 정보를 확인해보세요!"
        buo.imageUrl = "https://picsum.photos/200"
        buo.contentMetadata.customMetadata["spotId"] = spot.spotID
        return buo
    }

    private func makeBranchLinkProperties() -> BranchLinkProperties {
        let lp: BranchLinkProperties = BranchLinkProperties()
        lp.channel = "share" // NOTE: 링크 유입 경로 -> 대시보드에서 볼 수 있음
        lp.feature = "spot_detail_share" // NOTE: 생성된 링크의 목적/기능 -> 대시보드에서 볼 수 있음
        lp.addControlParam("$deeplink_path", withValue: "spot/\(spotID)") // NOTE: 딥링크 클릭 시 앱의 URI Scheme으로 이동
        return lp
    }

}
