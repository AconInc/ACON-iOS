//
//  ACLocationManager.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/11/25.
//

import UIKit
import CoreLocation

protocol ACLocationManagerDelegate: AnyObject {
    
    func locationManager(_ manager: ACLocationManager, didUpdateLocation coordinate: CLLocationCoordinate2D)
    func locationManager(_ manager: ACLocationManager, didFailWithError error: Error, vc: UIViewController?)
    
}

extension ACLocationManagerDelegate {
    
    func locationManager(_ manager: ACLocationManager, didFailWithError error: Error, vc: UIViewController?) {
        print(error)
        vc?.showDefaultAlert(title: StringLiterals.Alert.notLocatedTitle,
                             message: StringLiterals.Alert.notLocatedMessage)
    }
    
}

class ACLocationManager: NSObject {
    
    static let shared = ACLocationManager()
    
    private let locationManager = CLLocationManager()
    private let multicastDelegate = MulticastDelegate<ACLocationManagerDelegate>()
    
    private override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func addDelegate(_ delegate: ACLocationManagerDelegate) {
        multicastDelegate.add(delegate)
    }
    
    func removeDelegate(_ delegate: ACLocationManagerDelegate) {
        multicastDelegate.remove(delegate)
    }
    
    func requestLocationAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    func checkUserDeviceLocationServiceAuthorization() {
        // Execute on background thread to prevent UI blocking
        DispatchQueue.global().async { [weak self] in
            guard CLLocationManager.locationServicesEnabled() else {
                DispatchQueue.main.async {
                    let scenes = UIApplication.shared.connectedScenes
                    let windowScene = scenes.first as? UIWindowScene
                    let window = windowScene?.windows.first
                    window?.rootViewController?.showDefaultAlert(title: StringLiterals.Alert.gpsDeprecatedTitle, message: StringLiterals.Alert.gpsDeprecatedMessage)
                }
                return
            }
            
            DispatchQueue.main.async {
                let authorizationStatus = self?.locationManager.authorizationStatus
                if let status = authorizationStatus {
                    self?.checkUserCurrentLocationAuthorization(status)
                }
            }
        }
    }
    
    func checkUserCurrentLocationAuthorization(_ status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            // TODO: 설정 이동 Alert 커스텀 Alert으로 변경
            let scenes = UIApplication.shared.connectedScenes
            let windowScene = scenes.first as? UIWindowScene
            let window = windowScene?.windows.first
            window?.rootViewController?.showDefaultAlert(title: StringLiterals.Alert.gpsDeniedTitle, message: StringLiterals.Alert.gpsDeniedMessage)
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        default:
            print("zz 여기로안빠질듯")
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: ACLocationManager) {
        checkUserDeviceLocationServiceAuthorization()
    }
    
}

extension ACLocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.last?.coordinate {
            multicastDelegate.invoke { delegate in
                delegate.locationManager(self, didUpdateLocation: coordinate)
            }
        }
        stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        multicastDelegate.invoke { delegate in
            delegate.locationManager(self, didFailWithError: error, vc: nil)
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: ACLocationManager, vc: UIViewController) {
        checkUserDeviceLocationServiceAuthorization()
    }
    
}
