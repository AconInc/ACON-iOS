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
    func locationManagerDidChangeAuthorization(_ manager: ACLocationManager)
    
}

extension ACLocationManagerDelegate {
    
    func locationManager(_ manager: ACLocationManager, didFailWithError error: Error, vc: UIViewController?) {
        print(error)
        vc?.showDefaultAlert(title: StringLiterals.Alert.notLocatedTitle,
                             message: StringLiterals.Alert.notLocatedMessage)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: ACLocationManager) {
        // TODO: - 이거 안 하면 위치 접근 권한 뜰 때 누르고, 다시 한 번 더 눌러야 제대로 된 서버통신 진행됨.
        // NOTE: 위치 접근 권한 변경 시 바로 위치 로드
        if manager.locationManager.authorizationStatus == .authorizedWhenInUse || manager.locationManager.authorizationStatus == .authorizedAlways {
            manager.checkUserCurrentLocationAuthorization(manager.locationManager.authorizationStatus)
        }
    }
    
}

class ACLocationManager: NSObject {
    
    static let shared = ACLocationManager()
    
    let locationManager = CLLocationManager()
    private let multicastDelegate = MulticastDelegate<ACLocationManagerDelegate>()
    private var isRequestingLocation: Bool = false
    
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
        // NOTE: - Execute on background thread to prevent UI blocking ??
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
            let scenes = UIApplication.shared.connectedScenes
            let windowScene = scenes.first as? UIWindowScene
            let window = windowScene?.windows.first
            let vc = (window?.rootViewController)!
            vc.presentACAlert(.locationAccessDenied,
                                  longAction: ACAlertActionType.openSettings)
        case .authorizedWhenInUse, .authorizedAlways:
            guard !isRequestingLocation else { return }
            isRequestingLocation = true
            locationManager.startUpdatingLocation()
        default:
            print("zz 여기로안빠질듯")
        }
    }
    
}

extension ACLocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard isRequestingLocation, let coordinate = locations.last?.coordinate else {
            return
        }
        isRequestingLocation = false
        stopUpdatingLocation()
        
        multicastDelegate.invoke { delegate in
            delegate.locationManager(self, didUpdateLocation: coordinate)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        multicastDelegate.invoke { delegate in
            delegate.locationManager(self, didFailWithError: error, vc: nil)
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        multicastDelegate.invoke { delegate in
            delegate.locationManagerDidChangeAuthorization(self)
        }
    }
    
}
