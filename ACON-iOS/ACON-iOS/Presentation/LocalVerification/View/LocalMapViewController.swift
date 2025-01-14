//
//  LocalMapViewController.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/15/25.
//

import UIKit

import NMapsMap
import SnapKit
import Then

class LocalMapViewController: BaseNavViewController {
    
    // MARK: - UI Properties
    
    private let localMapView = LocalMapView()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setXButton()
        addTarget()
        ACLocationManager.shared.addDelegate(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)

        self.tabBarController?.tabBar.isHidden = true
        ACLocationManager.shared.checkUserDeviceLocationServiceAuthorization()
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
           CLLocationManager.authorizationStatus() == .authorizedAlways {
            ACLocationManager.shared.startUpdatingLocation()
        }
    }
    
    deinit {
        ACLocationManager.shared.removeDelegate(self)
    }
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.contentView.addSubview(localMapView)
    }
    
    override func setLayout() {
        super.setLayout()

        localMapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func setStyle() {
        super.setStyle()
        
        self.setXButton()
        self.setSecondTitleLabelStyle(title: StringLiterals.LocalVerification.locateOnMap)
    }
    
    func addTarget() {
        localMapView.finishVerificationButton.addTarget(self,
                                  action: #selector(finishVerificationButtonTapped),
                                  for: .touchUpInside)
    }

}

    
// MARK: - @objc functions

private extension LocalMapViewController {

    @objc
    func finishVerificationButtonTapped() {
        // TODO: - 인증완료모달
    }
    
}


// MARK: - Map Functions

extension LocalMapViewController {
    
    func moveCameraToLocation(latitude: Double, longitude: Double) {
        let position = NMGLatLng(lat: latitude, lng: longitude)
        let cameraUpdate = NMFCameraUpdate(scrollTo: position, zoomTo: 17)
        localMapView.nMapView.mapView.moveCamera(cameraUpdate)
        // NOTE: 최초 1회만 받고 중지
        ACLocationManager.shared.stopUpdatingLocation()
    }
    
}


// MARK: - LocationManagerDelegate

extension LocalMapViewController: ACLocationManagerDelegate {
    
    func locationManager(_ manager: ACLocationManager, didUpdateLocation coordinate: CLLocationCoordinate2D) {
        moveCameraToLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
    
}
