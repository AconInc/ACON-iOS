//
//  LocalVerificationViewController.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/15/25.
//

import UIKit

import SnapKit
import Then

class LocalVerificationViewController: BaseNavViewController {
    
    // MARK: - UI Properties
    
    private let localVerificationView = LocalVerificationView()
    
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
        
        self.contentView.addSubview(localVerificationView)
    }
    
    override func setLayout() {
        super.setLayout()

        localVerificationView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func setStyle() {
        super.setStyle()
        
        self.localVerificationView.nextButton.isEnabled = false
    }
    
    func addTarget() {
        localVerificationView.verifyNewLocalButton.addTarget(self,
                                                             action: #selector(verifyLocationButtonTapped),
                                                             for: .touchUpInside)
        localVerificationView.nextButton.addTarget(self,
                                  action: #selector(nextButtonTapped),
                                  for: .touchUpInside)
    }

}

    
// MARK: - @objc functions

private extension LocalVerificationViewController {
    
    @objc
    func verifyLocationButtonTapped() {
        localVerificationView.verifyNewLocalButton.isSelected.toggle()
        let isSelected = localVerificationView.verifyNewLocalButton.isSelected
        localVerificationView.verifyNewLocalButton.configuration?.baseBackgroundColor = isSelected ? .gray7 : .gray9
        localVerificationView.nextButton.isEnabled = isSelected
        localVerificationView.nextButton.backgroundColor = isSelected ? .gray5 : .gray8
    }
    
    @objc
    func nextButtonTapped() {
        let vc = LocalMapViewController()
        navigationController?.pushViewController(vc, animated: false)
    }
    
}
