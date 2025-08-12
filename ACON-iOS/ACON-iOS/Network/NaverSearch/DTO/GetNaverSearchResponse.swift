//
//  GetNaverPlaceResponse.swift
//  ACON-iOS
//
//  Created by 이수민 on 8/1/25.
//

import Foundation

struct GetNaverSearchResponse: Decodable {
    
    let items: [NaverPlaceDTO]
    
}

struct NaverPlaceDTO: Decodable {
    
    let title: String

    let roadAddress: String
    
    let address: String
    
    let category: String
    
}
