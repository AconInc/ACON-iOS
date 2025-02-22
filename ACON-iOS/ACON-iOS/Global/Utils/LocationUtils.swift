//
//  LocationUtils.swift
//  ACON-iOS
//
//  Created by 이수민 on 2/22/25.
//

struct LocationUtils {
    
    static let minLatitude = 33.1
    
    static let maxLatitude = 38.6
    
    static let minLongitude = 124.6
    
    static let maxLongitude = 131.9
    
    static func isKorea(_ lat: Double, _ long: Double) -> Bool {
        if lat > minLatitude
            && lat < maxLatitude
            && long > minLongitude
            && long < maxLongitude {
            return true
        } else {
            return false
        }
    }
    
}
