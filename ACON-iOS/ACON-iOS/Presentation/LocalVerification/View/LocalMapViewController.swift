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
        print(localVerificationViewModel.userCoordinate)
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
            $0.edges.equalToSuperview()
        }
    }
    
    override func setStyle() {
        super.setStyle()

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

            if onSuccess {
                switch flowType {
                case .onboarding:
                    self?.localArea = areaName
                    self?.presentVerificationFinsishedVC()
                case .profileEdit:
                    guard let vcStack = self?.navigationController?.viewControllers else { return }
                    self?.localArea = areaName
                    for vc in vcStack {
                        if let profileEditVC = vc as? ProfileEditViewController {
                            self?.navigationController?.popToViewController(profileEditVC.self, animated: true)
                        }
                    }
                }
            }
        }
    }
    
}


// MARK: - @objc functions

private extension LocalMapViewController {

    @objc
    func finishVerificationButtonTapped() {
        self.localVerificationViewModel.postLocalArea()
    }
    
}


// MARK: - @objc functions

private extension LocalMapViewController {

    func presentVerificationFinsishedVC() {
        let vc = LocalVerificationFinishedViewController(localArea: self.localArea)
        vc.dismissCompletion = { [weak self] in
            self?.removeBlurView()
        }
        
        vc.setMiddleSheetLayout()
        self.addBlurView()
        self.present(vc, animated: true)
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
