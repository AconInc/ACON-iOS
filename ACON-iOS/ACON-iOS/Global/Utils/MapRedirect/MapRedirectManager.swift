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

    private var transportMode: TransportModeType?


    // MARK: - Redirect
    
    func redirect(to destination: MapRedirectModel, mapType: MapType, transportMode: TransportModeType) {
        ACLocationManager.shared.addDelegate(self)
        self.destination = destination
        self.mapType = mapType
        self.transportMode = transportMode
        ACLocationManager.shared.checkUserDeviceLocationServiceAuthorization()
    }


    // MARK: - Helper

    private func openMap(map: MapType,
                         from startPoint: MapRedirectModel,
                         to destination: MapRedirectModel,
                         transportMode: TransportModeType) {
        map.service.openMap(from: startPoint, to: destination, transportMode: transportMode)
    }

}


// MARK: - ACLocationManagerDelegate

extension MapRedirectManager: ACLocationManagerDelegate {

    func locationManager(_ manager: ACLocationManager, didUpdateLocation location: CLLocation) {
        ACLocationManager.shared.removeDelegate(self)

        if let mapType = mapType,
           let destination = destination,
           let transportMode = transportMode {
            let startPoint = MapRedirectModel(
                name: StringLiterals.Map.myLocation,
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude
            )

            self.openMap(map: mapType, from: startPoint, to: destination, transportMode: transportMode)
        } else {
            print("❌ Redirect Optional binding Failed")
        }

        mapType = nil
        destination = nil
        transportMode = nil
    }

}
