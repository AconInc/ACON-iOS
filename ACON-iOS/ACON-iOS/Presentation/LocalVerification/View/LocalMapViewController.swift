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
    
    private let viewModel: LocalVerificationViewModel
    
    
    // MARK: - LifeCycle

    init(viewModel: LocalVerificationViewModel) {
        self.viewModel = viewModel
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
        moveCameraToLocation(latitude: viewModel.userCoordinate?.latitude ?? 0,
                             longitude: viewModel.userCoordinate?.longitude ?? 0)
        if viewModel.flowType == .onboarding {
            DispatchQueue.main.async {
                ACToastController.show(
                    .canChangeLocalVerification,
                    bottomInset: 591
                )
            }
        }
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
        self.setCenterTitleLabelStyle(title: StringLiterals.LocalVerification.locateOnMap)
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
        viewModel.onPostLocalAreaSuccess.bind { [weak self] onSuccess in
            guard let onSuccess,
                  let flowType = self?.viewModel.flowType
            else { return }
            
            UserDefaults.standard.set(onSuccess,
                                      forKey: StringLiterals.UserDefaults.hasVerifiedArea)
            if onSuccess {
                switch flowType {
                case .onboarding:
                    self?.navigateToOnboarding()
                case .setting:
                    self?.navigateToSetting()
                }
            } else {
                let errorType = self?.viewModel.postLocalAreaErrorType
                switch errorType {
                case .unsupportedRegion:
                    self?.presentACAlert(.locationAccessFail)
                case .outOfRange:
                    self?.presentACAlert(.timeoutFromVerification)
                default:
                    self?.showServerErrorAlert()
                }
                self?.viewModel.postLocalAreaErrorType = nil
            }
            self?.viewModel.onPostLocalAreaSuccess.value = nil
        }
        
        viewModel.onPostReplaceVerifiedAreaSuccess.bind { [weak self] onSuccess in
            guard let self = self,
                  let onSuccess = onSuccess else { return }
            if onSuccess {
                self.navigateToSetting()
            } else {
                switch viewModel.postReplaceVerifiedAreaErrorType {
                case .unsupportedRegion:
                    self.presentACAlert(.locationAccessFail)
                case .timeOut:
                    self.presentACAlert(.timeoutFromVerification)
                default:
                    return
                }
                viewModel.postReplaceVerifiedAreaErrorType = nil
            }
            viewModel.onPostReplaceVerifiedAreaSuccess.value = nil
        }
    }
    
}


// MARK: - @objc functions

private extension LocalMapViewController {

    @objc
    func finishVerificationButtonTapped() {
        AmplitudeManager.shared.trackEventWithProperties(AmplitudeLiterals.EventName.areaVerified, properties: ["complete_area?": true])
        
        if self.viewModel.flowType == .setting && self.viewModel.isSwitching {
            self.viewModel.postReplaceVerifiedArea()
        } else {
            self.viewModel.postLocalArea()
        }
    }
    
}


// MARK: - navigation functions

private extension LocalMapViewController {

    func navigateToOnboarding() {
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController = OnboardingViewController(flowType: .login)
        }
    }
    
    func navigateToSetting() {
        guard let vcStack = self.navigationController?.viewControllers else { return }
        for vc in vcStack {
            if let verifiedAreaEditVC = vc as? VerifiedAreasEditViewController {
                self.navigationController?.popToViewController(verifiedAreaEditVC.self, animated: true)
            }
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
