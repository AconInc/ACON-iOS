//
//  MapRedirectManager.swift
//  ACON-iOS
//
//  Created by 김유림 on 6/6/25.
//

import CoreLocation

final class MapRedirectManager {

    // MARK: - Properties

    static let shared = MapRedirectManager()
    private init() {}

    private var mapType: MapType?

    private var destination: MapRedirectModel?


    // MARK: - Redirect
    
    func redirect(to destination: MapRedirectModel, using mapType: MapType) {
        ACLocationManager.shared.addDelegate(self)
        self.destination = destination
        self.mapType = mapType
        ACLocationManager.shared.checkUserDeviceLocationServiceAuthorization()
    }


    // MARK: - Helper

    private func openMap(type: MapType, from startPoint: MapRedirectModel, to destination: MapRedirectModel) {
        type.service.openMap(from: startPoint, to: destination)
    }

}


// MARK: - ACLocationManagerDelegate

extension MapRedirectManager: ACLocationManagerDelegate {

    func locationManager(_ manager: ACLocationManager, didUpdateLocation coordinate: CLLocationCoordinate2D) {
        ACLocationManager.shared.removeDelegate(self)

        if let mapType = mapType,
           let destination = destination {
            let startPoint = MapRedirectModel(
                name: StringLiterals.Map.myLocation,
                latitude: coordinate.latitude,
                longitude: coordinate.longitude
            )

            self.openMap(type: mapType, from: startPoint, to: destination)
        }

        mapType = nil
        destination = nil
    }

}
