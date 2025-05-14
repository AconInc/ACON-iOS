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
        
    var spotDetail: ObservablePattern<SpotDetailInfoModel> = ObservablePattern(nil)

    // TODO: DTO 수정 후 삭제
    let imageURLs: [String] = ["https://www.bhc.co.kr/upload/bhc/menu/%EC%96%91%EB%85%90%EC%B9%98%ED%82%A8_%EC%BD%A4%EB%B3%B4_410x271.jpg","https://cdn.kmecnews.co.kr/news/photo/202311/32217_20955_828.jpg","https://images.immediate.co.uk/production/volatile/sites/30/2022/03/Pancake-grazing-board-bc15106.jpg?quality=90&resize=556,505","https://natashaskitchen.com/wp-content/uploads/2020/03/Pan-Seared-Steak-4.jpg","https://i.namu.wiki/i/oFHlYDjoEh8f-cc3lNK9jAemRkbXxNGwUg7XiW5LGS6DF1P2x8GCeNQxbQhVIwtUS1u53YPw-uoyqpmLtrGNJA.webp","https://i.namu.wiki/i/dgjXU86ae29hDSCza-L0GZlFt3T9lRx1Ug9cKtqWSzMzs7Cd0CN2SzyLFEJcHVFviKcxAlIwxcllT9s2sck0RA.jpg","https://www.bhc.co.kr/upload/bhc/menu/%EC%96%91%EB%85%90%EC%B9%98%ED%82%A8_%EC%BD%A4%EB%B3%B4_410x271.jpg","https://cdn.kmecnews.co.kr/news/photo/202311/32217_20955_828.jpg","https://images.immediate.co.uk/production/volatile/sites/30/2022/03/Pancake-grazing-board-bc15106.jpg?quality=90&resize=556,505","https://natashaskitchen.com/wp-content/uploads/2020/03/Pan-Seared-Steak-4.jpg"]
    let menuImageURLs: [String] = ["https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRTriTWtuRKLT48PiNsFnViIxL2ZiZZ4f3Aig&s", "https://marketplace.canva.com/EAGEDq-_tZQ/1/0/1035w/canva-grey-and-beige-minimalist-restaurant-menu-hb5BNMWcQS4.jpg","https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS_afmmWy7JhYJNGi3igyJ3tb0VSwFO58h4XA&s","https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSmR-HwbkD_gFMN5Mv3fKRikt-IeJpYbayxAQ&s","https://t3.ftcdn.net/jpg/01/75/06/34/360_F_175063465_nPAUPd3x4uoqbmKyGqDLRDsIvMejnraQ.jpg","https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS3fjP3BWKbK_YDzsVBsI3EXKr7q0JCYMZWKQ&s"
        
    ]
    
    let onSuccessGetSpotMenu: ObservablePattern<Bool> = ObservablePattern(nil)
        
    var spotMenu: ObservablePattern<[SpotMenuModel]> = ObservablePattern(nil)
    
    let onSuccessPostGuidedSpotRequest: ObservablePattern<Bool> = ObservablePattern(nil)
    
    var mapType: String = "APPLE"
    
    let sname = "내 위치"
    
    init(spotID: Int64) {
        self.spotID = spotID
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
                                                         spotType: data.spotType.koreanText,
                                                         firstImageURL: data.imageList[0],
                                                         openStatus: data.openStatus,
                                                         address: data.address,
                                                         localAcornCount: data.localAcornCount,
                                                         basicAcornCount: data.basicAcornCount,
                                                         latitude: data.latitude,
                                                         longitude: data.longitude)
                self?.spotDetail.value = spotDetailData
                self?.onSuccessGetSpotDetail.value = true
            case .reIssueJWT:
                self?.handleReissue { [weak self] in
                    self?.getSpotDetail()
                }
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
            case .reIssueJWT:
                self?.handleReissue { [weak self] in
                    self?.getSpotMenu()
                }
            default:
                print("VM - Failed To getSpotMenu")
                self?.onSuccessGetSpotMenu.value = false
                return
            }
        }
    }
    
    // TODO: - 추후 PostGuidedSpotRequest 그냥 삭제?
    func postGuidedSpot() {
        ACService.shared.spotDetailService.postGuidedSpot(requestBody: PostGuidedSpotRequest(spotId: self.spotID)){ [weak self] response in
            switch response {
            case .success:
                self?.onSuccessPostGuidedSpotRequest.value = true
            case .reIssueJWT:
                self?.handleReissue { [weak self] in
                    self?.postGuidedSpot()
                }
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
        ACLocationManager.shared.addDelegate(self)
        self.mapType = "NAVER"
        ACLocationManager.shared.checkUserDeviceLocationServiceAuthorization()
    }
    
    func redirectToAppleMap() {
        ACLocationManager.shared.addDelegate(self)
        self.mapType = "APPLE"
        ACLocationManager.shared.checkUserDeviceLocationServiceAuthorization()
    }
    
    func openNMaps(startCoordinate: CLLocationCoordinate2D) {
        guard let appName = Bundle.main.bundleIdentifier else { return }
        let urlString = "nmap://route/walk?slat=\(startCoordinate.latitude)&slng=\(startCoordinate.longitude)&sname=\(sname)&dlat=\(spotDetail.value?.latitude ?? 0)&dlng=\(spotDetail.value?.longitude ?? 0)&dname=\(spotDetail.value?.name ?? "")&appname=\(appName)"
        guard let encodedStr = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        guard let url = URL(string: encodedStr) else { return }
        guard let appStoreURL = URL(string: "itms-apps://itunes.apple.com/app/id311867728?mt=8") else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            UIApplication.shared.open(appStoreURL)
        }
    }
    
    func openAppleMaps(startCoordinate: CLLocationCoordinate2D) {
        let start = MKMapItem(placemark: MKPlacemark(coordinate: startCoordinate))
        start.name = self.sname
        let destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: spotDetail.value?.latitude ?? 0, longitude: spotDetail.value?.longitude ?? 0)))
        destination.name = spotDetail.value?.name ?? ""
        
        let launchOptions = [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking
        ]
        
        MKMapItem.openMaps(
            with: [start, destination],
            launchOptions: launchOptions
        )
    }
    
}


// MARK: - 위치

extension SpotDetailViewModel: ACLocationManagerDelegate {
    
    func locationManager(_ manager: ACLocationManager, didUpdateLocation coordinate: CLLocationCoordinate2D) {
        ACLocationManager.shared.removeDelegate(self)
        
        if mapType == "NAVER" {
            openNMaps(startCoordinate: coordinate)
        } else if mapType == "APPLE" {
            openAppleMaps(startCoordinate: coordinate)
        }
    }
    
}

