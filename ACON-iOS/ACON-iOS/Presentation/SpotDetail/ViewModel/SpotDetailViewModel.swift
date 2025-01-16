//
//  SpotDetailViewModel.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/16/25.
//

import Foundation

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
    
}
