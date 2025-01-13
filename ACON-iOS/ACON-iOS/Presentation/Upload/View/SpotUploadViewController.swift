//
//  SpotUploadViewController.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/13/25.
//

import UIKit

import SnapKit
import Then

class SpotUploadViewController: BaseNavViewController {
    
    // MARK: - UI Properties
    
    private let spotUploadView = SpotUploadView()
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setXButton()
        self.setSecondTitleLabelStyle(title: StringLiterals.Upload.upload)
        addTarget()
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
        
        self.spotUploadView.dropAcornButton.isEnabled = true
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

extension SpotUploadViewController {

    @objc
    func spotSearchButtonTapped() {
        let vc = SpotSearchViewController()
        // TODO: - set spotsearchvc to modal
        self.present(vc, animated: true)
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
