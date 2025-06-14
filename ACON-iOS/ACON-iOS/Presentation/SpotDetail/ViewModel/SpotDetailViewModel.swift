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

    let onSuccessGetSpotDetail: ObservablePattern<Bool> = ObservablePattern(nil)
    let onSuccessGetMenuboardImageList: ObservablePattern<Bool> = ObservablePattern(nil)
    var onSuccessPostSavedSpot: ObservablePattern<Bool> = ObservablePattern(nil)
    var onSuccessDeleteSavedSpot: ObservablePattern<Bool> = ObservablePattern(nil)

    var spotDetail: ObservablePattern<SpotDetailInfoModel> = ObservablePattern(nil)

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
                self?.spotDetail.value = spotDetailData
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
