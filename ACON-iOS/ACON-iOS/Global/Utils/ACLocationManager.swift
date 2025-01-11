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
        //TODO: - 추후 StringLiterals에 추가
        vc?.showDefaultAlert(title: "위치 인식 실패", message: "문제가 발생했습니다.\n나중에 다시 시도해주세요.")
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
                    UIApplication.shared.windows.first?.rootViewController?.showDefaultAlert(title: "위치 안됨", message: "시스템 설정에서 디바이스 위치 활성화해주세요")
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
            // TODO: 설정 이동 Alert 띄우기
            if let topVC = UIApplication.shared.windows.first?.rootViewController {
                topVC.showDefaultAlert(title: "이미 허용 안 함 누름", message: "설정으로 redirect")
            }
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
