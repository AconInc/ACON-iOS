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
    
    var selectedSpotID: Int = -1
    
//    var selectedSpotName: String = ""
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setXButton()
        self.setSecondTitleLabelStyle(title: StringLiterals.Upload.upload)
        addTarget()
        ACLocationManager.shared.addDelegate(self)
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

    
// MARK: - @objc functions

private extension SpotUploadViewController {

    @objc
    func spotSearchButtonTapped() {
        // TODO: - 위치 접근 권한 체크하기
        ACLocationManager.shared.checkUserDeviceLocationServiceAuthorization()
    }
    
    @objc
    func dropAcornButtonTapped() {
        let vc = DropAcornViewController()
        navigationController?.pushViewController(vc, animated: false)
    }
    
    @objc
    func xButtonTapped() {
        // TODO: 작성을 그만두시겠습니까 Alert 띄우기
    }
    
}

extension SpotUploadViewController: ACLocationManagerDelegate {
    
    func locationManager(_ manager: ACLocationManager, didUpdateLocation coordinate: CLLocationCoordinate2D) {
        // TODO: - 연관검색어 네트워크 요청
        print("성공 - 위도: \(coordinate.latitude), 경도: \(coordinate.longitude)")
        setSpotSearchModal()
    }
    
}


extension SpotUploadViewController {
    
    func setSpotSearchModal() {
        let vc = SpotSearchViewController()
        
        vc.dismissCompletion = { [weak self] in
            self?.removeBlurView()
        }
        
        // TODO: - 이 부분 로직 및 플로우 다시 짜기 !!
        vc.completionHandler = { [weak self] selectedSpotID, selectedSpotName in
            guard let self = self else { return }
            self.selectedSpotID = selectedSpotID
//            self?.selectedSpotName = selectedSpotName
            self.spotUploadView.spotSearchButton.do {
                $0.setAttributedTitle(text: selectedSpotName,
                                      style: .s2,
                                      color: .acWhite)
            }
            if selectedSpotID > 0 {
                self.spotUploadView.dropAcornButton.isEnabled = true
                self.spotUploadView.dropAcornButton.backgroundColor = .gray5
            } else {
                self.spotUploadView.dropAcornButton.isEnabled = false
                self.spotUploadView.dropAcornButton.backgroundColor = .gray8
                self.spotUploadView.spotSearchButton.setAttributedTitle(text: StringLiterals.Upload.uploadSpotName,
                                                                        style: .s2,
                                                                        color: .gray5)

            }
        }
        
        vc.setLongSheetLayout()
        self.addBlurView()
        self.present(vc, animated: true)
    }
    
}
