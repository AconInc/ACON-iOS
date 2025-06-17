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
                self?.handleNetworkError { [weak self] in
                    self?.getSpotDetail()
                }
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
                self?.handleNetworkError { [weak self] in
                    self?.getMenuboardImageList()
                }
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
            case .reIssueJWT:
                self?.handleReissue { [weak self] in
                    self?.postGuidedSpot()
                }
            default:
                self?.handleNetworkError { [weak self] in
                    self?.postGuidedSpot()
                }
            }
        }
    }

    func deleteSavedSpot() {
        ACService.shared.spotDetailService.deleteSavedSpot(spotID: spotID){ [weak self] response in
            switch response {
            case .success:
                self?.onSuccessDeleteSavedSpot.value = true
            case .reIssueJWT:
                self?.handleReissue { [weak self] in
                    self?.deleteSavedSpot()
                }
            default:
                self?.handleNetworkError { [weak self] in
                    self?.deleteSavedSpot()
                }
            }
        }
    }

}


// MARK: - 딥링크 메소드

extension SpotDetailViewModel {

    func createBranchDeepLink(_ completion: @escaping (String) -> ()) {
        guard let buo: BranchUniversalObject = makeBranchUniversalObject() else { return }
        let lp: BranchLinkProperties = makeBranchLinkProperties()
        buo.getShortUrl(with: lp) { [weak self] url, error in
            if let error {
                print("🔗❌ 딥링크 생성 실패: \(error.localizedDescription)")
                return
            }

            guard let url = url else {
                print("🔗❓ 딥링크 생성은 성공했으나 URL == nil")
                return
            }

            let spotName = self?.spotDetail?.name ?? ""
            let deepLinkString = StringLiterals.DeepLink.atAcon + spotName + StringLiterals.DeepLink.checkOut + "\n\(url)"
            completion(deepLinkString)
            print("🔗✅ deeplink 생성 성공: \(url)")
        }
    }

    private func makeBranchUniversalObject() -> BranchUniversalObject? {
        guard let spot = spotDetail else { return nil }
        let buo: BranchUniversalObject = BranchUniversalObject(canonicalIdentifier: "spot/\(spot.spotID)")
        buo.title = StringLiterals.DeepLink.deepLinkTitleAcon + " " + spot.name
        buo.contentDescription = StringLiterals.DeepLink.deepLinkDescription
        buo.contentMetadata.customMetadata["spotId"] = spot.spotID
        return buo
    }

    private func makeBranchLinkProperties() -> BranchLinkProperties {
        let lp: BranchLinkProperties = BranchLinkProperties()
        lp.channel = StringLiterals.DeepLink.branchLinkChannel
        lp.feature = StringLiterals.DeepLink.branchLinkFeature
        lp.addControlParam(StringLiterals.DeepLink.branchDeepLinkPathParamName, withValue: "spot/\(spotID)")
        return lp
    }

}
