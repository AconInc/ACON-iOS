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
    
    var selectedSpotID: Int = -1
    
//    var selectedSpotName: String = ""
    
    var latitude: Double = 0
    
    var longitude: Double = 0
    
    // NOTE: isModalPresenting, isLocationUpdated으로 플래그 검증 시도해봤으나, 유무 상관없이 튕김 🍠
    
    
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
        self.setSecondTitleLabelStyle(title: StringLiterals.Upload.upload)
        self.spotUploadView.dropAcornButton.isEnabled = false
    }
    
    func addTarget() {
        self.leftButton.addTarget(self,
                                  action: #selector(xButtonTapped),
                                  for: .touchUpInside)
        spotUploadView.spotSearchButton.addTarget(self,
                                                  action: #selector(spotSearchButtonTapped),
                                                  for: .touchUpInside)
        spotUploadView.dropAcornButton.addTarget(self,
                                                 action: #selector(dropAcornButtonTapped),
                                                 for: .touchUpInside)
    }

}


private extension SpotUploadViewController {

    func bindViewModel() {
        self.spotReviewViewModel.onSuccessGetReviewVerification.bind { [weak self] onSuccess in
            guard let onSuccess, let data = self?.spotReviewViewModel.reviewVerification.value else { return }
            if onSuccess {
                if data {
                    self?.spotUploadView.dropAcornButton.isEnabled = true
                    self?.spotUploadView.dropAcornButton.backgroundColor = .gray5
                } else {
                    // TODO: - show Alert
                    self?.spotUploadView.dropAcornButton.isEnabled = false
                    self?.spotUploadView.dropAcornButton.backgroundColor = .gray8
                    self?.spotUploadView.spotSearchButton.setAttributedTitle(text: StringLiterals.Upload.uploadSpotName,
                                                                            style: .s2,
                                                                            color: .gray5)
                }
                self?.spotReviewViewModel.reviewVerification.value = false
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
    func dropAcornButtonTapped() {
//        TODO: - 🍠 딱히 이거의 타이밍 시점도 아닌 것 같음 -> 해결되면 지우기
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
//            guard let self = self else { return }
//            let vc = DropAcornViewController(spotID: selectedSpotID)
//            self.navigationController?.pushViewController(vc, animated: false)
//        }
        let vc = DropAcornViewController(spotID: selectedSpotID)
        navigationController?.pushViewController(vc, animated: false)
    }
    
    @objc
    func xButtonTapped() {
        let alertHandler = AlertHandler()
        alertHandler.showReviewExitAlert(from: self)
    }
    
}

extension SpotUploadViewController: ACLocationManagerDelegate {
    
    func locationManager(_ manager: ACLocationManager, didUpdateLocation coordinate: CLLocationCoordinate2D) {
        // TODO: - 연관검색어 네트워크 요청 - 여기 아니면 spotSearch viewWillAppear

        manager.stopUpdatingLocation()
        manager.removeDelegate(self)
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
        print("===== setSpotSearchModal 시작 =====")
        // TODO: - 🍠 이미 모달이 표시되어있는 문제도 아닌 듯. 해결되면 지울 것
//        print("isModalPresenting", isModalPresenting)
//        if presentedViewController == nil {
//            isModalPresenting = false  // 실제로 표시된 모달이 없으면 강제로 false로 리셋
//        }
//        guard !isModalPresenting else { return }  // 이미 모달이 표시중이면 리턴
        presentSpotSearchModal()
    }
    
    func presentSpotSearchModal() {
        print("===== presentSpotSearchModal 시작 =====")

        let vc = SpotSearchViewController()
        // TODO: 🍠 메인 스레드 업데이트도 딱히 의미없어보임. 해결되면 걍 없이 ㄱㄱ할 것
        // NOTE: - 튕기는 시점도 제각각 🍠
        // NOTE: - 정상 프로세스와 튕기는 프로세스의 콘솔이 아예 일치할 때도 있음...🍠
        vc.dismissCompletion = { [weak self] in
            print("===== dismissCompletion 호출 =====")
            DispatchQueue.main.async {
                self?.removeBlurView()
            }
        }
        
        vc.completionHandler = { [weak self] selectedSpotID, selectedSpotName in
            print("===== completionHandler 호출 =====")
            guard let self = self else { return }
            self.selectedSpotID = selectedSpotID
            
            DispatchQueue.main.async {
                self.spotUploadView.spotSearchButton.do {
                    $0.setAttributedTitle(text: selectedSpotName,
                                          style: .s2,
                                          color: .acWhite)
                }
                
                if selectedSpotID > 0 {
                    // TODO: - ReviewVerification 서버통신
                } else {
                    self.spotUploadView.dropAcornButton.isEnabled = false
                    self.spotUploadView.dropAcornButton.backgroundColor = .gray8
                    self.spotUploadView.spotSearchButton.setAttributedTitle(
                        text: StringLiterals.Upload.uploadSpotName,
                        style: .s2,
                        color: .gray5)
                }
            }
        }

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.addBlurView()
            vc.setLongSheetLayout()
            self.present(vc, animated: true) {
                print("===== present 완료 =====")
            }
        }
    }

}
