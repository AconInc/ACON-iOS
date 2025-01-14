//
//  LocalMapViewController.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/15/25.
//

import UIKit

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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)

        self.tabBarController?.tabBar.isHidden = true
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
        self.setSecondTitleLabelStyle(title: "지도에서 위치 확인하기")
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
