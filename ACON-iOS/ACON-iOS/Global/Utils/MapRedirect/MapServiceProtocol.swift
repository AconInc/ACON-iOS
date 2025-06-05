//
//  MapServiceProtocol.swift
//  ACON-iOS
//
//  Created by 김유림 on 6/6/25.
//

import Foundation
import CoreLocation

protocol MapServiceProtocol {

    func openMap(from startCoordinate: CLLocationCoordinate2D, to destination: DestinationModel)

}

enum MapServiceError: Error {

    case invalidURL

    case bundleIdentifierFailed

}
