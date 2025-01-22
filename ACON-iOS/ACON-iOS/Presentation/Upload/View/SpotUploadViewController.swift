//
//  SpotUploadViewController.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/13/25.
//

import UIKit
import CoreLocation

import SnapKit
import Then

class SpotUploadViewController: BaseNavViewController {
    
    // MARK: - UI Properties
    
    private let spotUploadView = SpotUploadView()
    
    private var viewBlurEffect: UIVisualEffectView = UIVisualEffectView()
    
    // MARK: - Properties
    
    var spotReviewViewModel = SpotReviewViewModel()
    
    var selectedSpotID: Int64 = -1
    
//    var selectedSpotName: String = ""
    
    var latitude: Double = 0
    
    var longitude: Double = 0
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTarget()
        ACLocationManager.shared.addDelegate(self)
        bindViewModel()
    }
    
    deinit {
       ACLocationManager.shared.removeDelegate(self)
   }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)

        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.contentView.addSubview(spotUploadView)
    }
    
    override func setLayout() {
        super.setLayout()

        spotUploadView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func setStyle() {
        super.setStyle()
        
        self.setXButton()
        self.setNextButton()
        self.spotUploadView.dropAcornButton.isEnabled = false
        self.rightButton.isEnabled = false
    }
    
    func addTarget() {
        self.leftButton.addTarget(self,
                                  action: #selector(xButtonTapped),
                                  for: .touchUpInside)
        spotUploadView.spotSearchButton.addTarget(self,
                                                  action: #selector(spotSearchButtonTapped),
                                                  for: .touchUpInside)
        self.rightButton.addTarget(self,
                                   action: #selector(nextButtonTapped),
                                    for: .touchUpInside)
    }

}


private extension SpotUploadViewController {

    func bindViewModel() {
        self.spotReviewViewModel.onSuccessGetReviewVerification.bind { [weak self] onSuccess in
            guard let onSuccess, let data = self?.spotReviewViewModel.reviewVerification.value else { return }
            if onSuccess {
                if data {
                    self?.rightButton.isEnabled = true
                } else {
                    let alertHandler = AlertHandler()
                    alertHandler.showLocationAccessFailImageAlert(from: self!)
                    self?.rightButton.isEnabled = false
                    self?.spotUploadView.spotSearchButton.setAttributedTitle(text: StringLiterals.Upload.searchSpot,
                                                                            style: .s2,
                                                                            color: .gray5)
                }
                self?.spotReviewViewModel.reviewVerification.value = nil
            }
        }
    }
    
}
    
// MARK: - @objc functions

private extension SpotUploadViewController {

    @objc
    func spotSearchButtonTapped() {
        ACLocationManager.shared.checkUserDeviceLocationServiceAuthorization()
    }
    
    @objc
    func nextButtonTapped() {
        let vc = DropAcornViewController(spotID: selectedSpotID)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false)
    }
    
    @objc
    func xButtonTapped() {
        let alertHandler = AlertHandler()
        alertHandler.showUploadExitAlert(from: self)
    }
    
}

extension SpotUploadViewController: ACLocationManagerDelegate {
    
    func locationManager(_ manager: ACLocationManager, didUpdateLocation coordinate: CLLocationCoordinate2D) {
        // TODO: - 연관검색어 네트워크 요청 - 여기 아니면 spotSearch viewWillAppear

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            print("성공 - 위도: \(coordinate.latitude), 경도: \(coordinate.longitude)")
            self.latitude = coordinate.latitude
            self.longitude = coordinate.longitude
            self.setSpotSearchModal()
        }
    }
    
}


extension SpotUploadViewController {
    
    func setSpotSearchModal() {
        let vc = SpotSearchViewController(spotSearchViewModel: SpotSearchViewModel(latitude: self.latitude, longitude: self.longitude))
        vc.dismissCompletion = { [weak self] in
            DispatchQueue.main.async {
                self?.removeBlurView()
            }
        }
        
        vc.completionHandler = { [weak self] selectedSpotID, selectedSpotName in
            guard let self = self else { return }
            self.selectedSpotID = selectedSpotID
            
            DispatchQueue.main.async {
                self.spotUploadView.spotSearchButton.do {
                    $0.setAttributedTitle(text: selectedSpotName,
                                          style: .s2,
                                          color: .acWhite)
                }
                
                if selectedSpotID > 0 {
                    self.spotReviewViewModel.getReviewVerification(spotId: selectedSpotID,
                                                                   latitude: self.latitude,
                                                                   longitude: self.longitude)
                } else {
                    self.rightButton.isEnabled = false
                    self.spotUploadView.spotSearchButton.setAttributedTitle(
                        text: StringLiterals.Upload.searchSpot,
                        style: .s2,
                        color: .gray5)
                }
            }
        }

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.addBlurView()
            vc.setLongSheetLayout()
            self.present(vc, animated: true)
        }
    }
    
}
