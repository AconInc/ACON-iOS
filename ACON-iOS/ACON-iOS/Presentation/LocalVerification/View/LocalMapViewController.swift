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
    
    private var viewBlurEffect: UIVisualEffectView = UIVisualEffectView()
    
    private var localArea: String = ""
    
    private let localVerificationViewModel: LocalVerificationViewModel
    
    
    // MARK: - LifeCycle

    init(viewModel: LocalVerificationViewModel) {
        self.localVerificationViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTarget()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)

        self.tabBarController?.tabBar.isHidden = true
        moveCameraToLocation(latitude: localVerificationViewModel.userCoordinate?.latitude ?? 0,
                             longitude: localVerificationViewModel.userCoordinate?.longitude ?? 0)
    }
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.contentView.addSubview(localMapView)
    }
    
    override func setLayout() {
        super.setLayout()

        localMapView.snp.makeConstraints {
            $0.top.equalTo(self.topInsetView.snp.top)
            $0.bottom.horizontalEdges.equalToSuperview()
        }
    }
    
    override func setStyle() {
        super.setStyle()

        self.setGlassMorphism()
        self.setBackButton()
        self.setSecondTitleLabelStyle(title: StringLiterals.LocalVerification.locateOnMap)
    }
    
    func addTarget() {
        localMapView.finishVerificationButton.addTarget(self,
                                  action: #selector(finishVerificationButtonTapped),
                                  for: .touchUpInside)
    }

}


// MARK: - bindViewModel

private extension LocalMapViewController {

    func bindViewModel() {
        self.localVerificationViewModel.onSuccessPostLocalArea.bind { [weak self] onSuccess in
            guard let onSuccess,
                  let flowType = self?.localVerificationViewModel.flowType
            else { return }
            
            let areaName: String = self?.localVerificationViewModel.localAreaName.value ?? ""
            
            print("onSuccessPostLocalArea: \(onSuccess)")
            UserDefaults.standard.set(onSuccess,
                                      forKey: StringLiterals.UserDefaults.hasVerifiedArea)
            if onSuccess {
                switch flowType {
                case .onboarding:
                    self?.localArea = areaName
                    self?.navigateToOnboarding()
                case .adding, .switching:
                    guard let vcStack = self?.navigationController?.viewControllers else { return }
                    self?.localArea = areaName
                    for vc in vcStack {
                        if let verifiedAreaEditVC = vc as? VerifiedAreasEditViewController {
                            self?.navigationController?.popToViewController(verifiedAreaEditVC.self, animated: true)
                        }
                    }
                }
            }
            // TODO: 에러코드별 액션 분기처리 (이후 스프린트)
            else {
                self?.showDefaultAlert(title: "알림", message: "동네 인증을 완료할 수 없습니다. 앱을 재실행해주시기 바랍니다.")
            }
            
            self?.localVerificationViewModel.onSuccessPostLocalArea.value = nil
        }
    }
    
}


// MARK: - @objc functions

private extension LocalMapViewController {

    @objc
    func finishVerificationButtonTapped() {
        AmplitudeManager.shared.trackEventWithProperties(AmplitudeLiterals.EventName.areaVerified, properties: ["complete_area?": true])
        self.localVerificationViewModel.postLocalArea()
    }
    
}


// MARK: - navigation functions

private extension LocalMapViewController {

    func navigateToOnboarding() {
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController = OnboardingViewController()
        }
    }
    
}

// MARK: - Map Functions

extension LocalMapViewController {
    
    func moveCameraToLocation(latitude: Double, longitude: Double) {
        let position = NMGLatLng(lat: latitude, lng: longitude)
        localMapView.acMapMarker.position = position
        localMapView.acMapMarker.mapView = localMapView.nMapView.mapView
        let cameraUpdate = NMFCameraUpdate(scrollTo: position, zoomTo: 17)
        localMapView.nMapView.mapView.moveCamera(cameraUpdate)
    }
      
}
