//
//  SpotDetailViewModel.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/16/25.
//

import UIKit

import CoreLocation

class SpotDetailViewModel {
    
    let menuDummyData: [SpotMenuInfo] = [
        SpotMenuInfo(menuID: 1, name: "마라탕", price: 10000, imageURL: ""),
        SpotMenuInfo(menuID: 1, name: "꿔바로우", price: 22000, imageURL: ""),
        SpotMenuInfo(menuID: 1, name: "마라탕", price: 10000, imageURL: ""),
        SpotMenuInfo(menuID: 1, name: "꿔바로우", price: 22000, imageURL: ""),
        SpotMenuInfo(menuID: 1, name: "마라탕", price: 10000, imageURL: ""),
        SpotMenuInfo(menuID: 1, name: "마라탕", price: 10000, imageURL: ""),
        SpotMenuInfo(menuID: 1, name: "마라탕", price: 10000, imageURL: ""),
        SpotMenuInfo(menuID: 1, name: "꿔바로우", price: 22000, imageURL: ""),
        SpotMenuInfo(menuID: 1, name: "마라탕", price: 10000, imageURL: ""),
    ]
    
    let spotDetailDummyData: SpotDetail = SpotDetail(name: "아콘네 라면가게", spotType: "음식점", firstImageURL: "", openStatus: true, address: "서울시 마포구 동교동 27길 27", localAcornCount: 1, basicAcornCount: 1000, latitude: 37.556944, longitude: 126.923917)
    
    
    init() {
        ACLocationManager.shared.addDelegate(self)
    }
    
    deinit {
       ACLocationManager.shared.removeDelegate(self)
    }
    
    // MARK: - 네이버지도 Redirect
    
    func redirectToNaverMap() {
        ACLocationManager.shared.checkUserDeviceLocationServiceAuthorization()
        ACLocationManager.shared.startUpdatingLocation()
    }
    
}

extension SpotDetailViewModel: ACLocationManagerDelegate {
    
    func locationManager(_ manager: ACLocationManager, didUpdateLocation coordinate: CLLocationCoordinate2D) {
        guard let appName = Bundle.main.bundleIdentifier else { return }
        let sname = "내 위치"
        let urlString = "nmap://route/walk?slat=\(coordinate.latitude)&slng=\(coordinate.longitude)&sname=\(sname)&dlat=\(spotDetailDummyData.latitude)&dlng=\(spotDetailDummyData.longitude)&dname=\(spotDetailDummyData.name)&appname=\(appName)"
        guard let encodedStr = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        guard let url = URL(string: encodedStr) else { return }
        guard let appStoreURL = URL(string: "itms-apps://itunes.apple.com/app/id311867728?mt=8") else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            UIApplication.shared.open(appStoreURL)
        }
        
        // TODO: 최근 길 안내 POST 서버통신 -> spotId POST
    }
    
}

