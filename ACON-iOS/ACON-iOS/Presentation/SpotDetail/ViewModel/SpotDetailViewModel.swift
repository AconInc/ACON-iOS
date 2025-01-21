//
//  SpotDetailViewModel.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/16/25.
//

import UIKit

import CoreLocation

class SpotDetailViewModel {
    
    let spotID: Int64
    
    let onSuccessGetSpotDetail: ObservablePattern<Bool> = ObservablePattern(nil)
        
    var spotDetail: ObservablePattern<SpotDetailInfoModel> = ObservablePattern(nil)
    
    let onSuccessGetSpotMenu: ObservablePattern<Bool> = ObservablePattern(nil)
        
    var spotMenu: ObservablePattern<[SpotMenuModel]> = ObservablePattern(nil)
    
    let onSuccessPostGuidedSpotRequest: ObservablePattern<Bool> = ObservablePattern(nil)
    
    init(spotID: Int64) {
        self.spotID = spotID
        ACLocationManager.shared.addDelegate(self)
    }
    
    deinit {
       ACLocationManager.shared.removeDelegate(self)
    }

}

// MARK: - 서버 통신 메소드

extension SpotDetailViewModel {
    
    func getSpotDetail() {
        ACService.shared.spotDetailService.getSpotDetail(spotID: spotID) { [weak self] response in
            switch response {
            case .success(let data):
                let spotDetailData = SpotDetailInfoModel(spotID: data.id,
                                                         name: data.name,
                                                         spotType: data.spotType,
                                                         firstImageURL: data.imageList[0],
                                                         openStatus: data.openStatus,
                                                         address: data.address,
                                                         localAcornCount: data.localAcornCount,
                                                         basicAcornCount: data.basicAcornCount,
                                                         latitude: data.latitude,
                                                         longitude: data.longitude)
                self?.spotDetail.value = spotDetailData
                self?.onSuccessGetSpotDetail.value = true
            default:
                print("VM - Failed To getSpotDetail")
                self?.onSuccessGetSpotDetail.value = false
                return
            }
        }
    }
    
    func getSpotMenu() {
        ACService.shared.spotDetailService.getSpotMenu(spotID: spotID) { [weak self] response in
            switch response {
            case .success(let data):
                let spotMenuData = data.menuList.map { menu in
                    return SpotMenuModel(menuID: menu.id,
                                         name: menu.name,
                                         price: menu.price,
                                         imageURL: menu.image)
                    }
                    self?.spotMenu.value = spotMenuData
                    self?.onSuccessGetSpotMenu.value = true
            default:
                print("VM - Failed To getSpotMenu")
                self?.onSuccessGetSpotMenu.value = false
                return
            }
        }
    }
    
    // TODO: - 추후 PostGuidedSpotRequest 그냥 삭제?
    func postGuidedSpot(spotID: Int64) {
        ACService.shared.spotDetailService.postGuidedSpot(requestBody: PostGuidedSpotRequest(spotId: spotID)){ [weak self] response in
            switch response {
            case .success(let data):
                self?.onSuccessPostGuidedSpotRequest.value = true
            default:
                print("VM - Failed To postGuidedSpot")
                self?.onSuccessPostGuidedSpotRequest.value = false
                return
            }
        }
    }
    
}


// MARK: - 네이버지도 Redirect

extension SpotDetailViewModel {
    
    func redirectToNaverMap() {
        ACLocationManager.shared.checkUserDeviceLocationServiceAuthorization()
        ACLocationManager.shared.startUpdatingLocation()
    }
    
}


// MARK: - 위치
extension SpotDetailViewModel: ACLocationManagerDelegate {
    
    func locationManager(_ manager: ACLocationManager, didUpdateLocation coordinate: CLLocationCoordinate2D) {
        guard let appName = Bundle.main.bundleIdentifier else { return }
        let sname = "내 위치"
        let urlString = "nmap://route/walk?slat=\(coordinate.latitude)&slng=\(coordinate.longitude)&sname=\(sname)&dlat=\(String(describing: spotDetail.value?.latitude))&dlng=\(String(describing: spotDetail.value?.longitude))&dname=\(String(describing: spotDetail.value?.name))&appname=\(appName)"
        guard let encodedStr = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        guard let url = URL(string: encodedStr) else { return }
        guard let appStoreURL = URL(string: "itms-apps://itunes.apple.com/app/id311867728?mt=8") else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            UIApplication.shared.open(appStoreURL)
        }
        
        // TODO: 최근 길 안내 POST 서버통신 -> spotDetailInfoModel.spotID POST
    }
    
}

