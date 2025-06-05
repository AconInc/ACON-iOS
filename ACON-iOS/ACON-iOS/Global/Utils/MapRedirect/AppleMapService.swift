//
//  AppleMapService.swift
//  ACON-iOS
//
//  Created by 김유림 on 6/6/25.
//

import Foundation
import CoreLocation
import MapKit

final class AppleMapService: MapServiceProtocol {

    private let currentLocationName = "내 위치"

    func openMap(from startCoordinate: CLLocationCoordinate2D, to destination: DestinationModel) {
        let startItem = createMapItem(coordinate: startCoordinate, name: currentLocationName)
        let destinationItem = createMapItem(
            coordinate: CLLocationCoordinate2D(latitude: destination.latitude, longitude: destination.longitude),
            name: destination.name
        )

        let launchOptions = [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking
        ]

        MKMapItem.openMaps(
            with: [startItem, destinationItem],
            launchOptions: launchOptions
        )
    }

    private func createMapItem(coordinate: CLLocationCoordinate2D, name: String) -> MKMapItem {
        let item = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
        item.name = name
        return item
    }

}
