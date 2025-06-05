//
//  MapRedirectManager.swift
//  ACON-iOS
//
//  Created by 김유림 on 6/6/25.
//

import Foundation
import CoreLocation
import MapKit

final class MapRedirectManager {

    // MARK: - Properties

    static let shared = MapRedirectManager()
    private init() {}

    private var mapType: MapType?

    private var destination: DestinationModel?


    // MARK: - Redirect
    
    func redirect(to destination: DestinationModel, using mapType: MapType) {
        ACLocationManager.shared.addDelegate(self)
        self.destination = destination
        self.mapType = mapType
        ACLocationManager.shared.checkUserDeviceLocationServiceAuthorization()
    }


    // MARK: - Helper

    private func openMap(type: MapType, from startCoordinate: CLLocationCoordinate2D, to destination: DestinationModel) {
        let mapService = MapServiceFactory.createService(for: type)
        mapService.openMap(from: startCoordinate, to: destination)
    }

}


// MARK: - ACLocationManagerDelegate

extension MapRedirectManager: ACLocationManagerDelegate {

    func locationManager(_ manager: ACLocationManager, didUpdateLocation coordinate: CLLocationCoordinate2D) {
        ACLocationManager.shared.removeDelegate(self)

        if let mapType = mapType,
           let destination = destination {
            self.openMap(type: mapType, from: coordinate, to: destination)
        }

        mapType = nil
        destination = nil
    }

}
