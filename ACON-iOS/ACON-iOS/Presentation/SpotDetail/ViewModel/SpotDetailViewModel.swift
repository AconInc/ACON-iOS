//
//  SpotDetailViewModel.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/16/25.
//

import UIKit

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
    
    let spotDetailDummyData: SpotDetail = SpotDetail(firstImageURL: "", isOpen: true, address: "서울시 마포구 동교동 27길 27", localAcornCount: 1, basicAcornCount: 9999)
    
    
    func redirectToNaverMap(spotName: String, latitude: Double, longitude: Double) {
        guard let appName = Bundle.main.bundleIdentifier else { return }
        let urlString = "nmap://place?lat=\(latitude)&lng=\(longitude)&name=\(spotName)&appname=\(appName)"
        guard let encodedStr = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        guard let url = URL(string: encodedStr) else { return }
        guard let appStoreURL = URL(string: "itms-apps://itunes.apple.com/app/id311867728?mt=8") else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            UIApplication.shared.open(appStoreURL)
        }
    }
    
}
