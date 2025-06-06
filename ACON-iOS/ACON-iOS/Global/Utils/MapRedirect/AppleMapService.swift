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

    func openMap(from startPoint: MapRedirectModel, to destination: MapRedirectModel) {
        let startItem = createMapItem(for: startPoint)
        let destinationItem = createMapItem(for: destination)

        let launchOptions = [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking
        ]

        MKMapItem.openMaps(
            with: [startItem, destinationItem],
            launchOptions: launchOptions
        )
    }

    private func createMapItem(for place: MapRedirectModel) -> MKMapItem {
        let item = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)))
        item.name = place.name
        return item
    }

}
