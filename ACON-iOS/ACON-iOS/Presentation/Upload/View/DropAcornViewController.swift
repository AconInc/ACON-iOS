//
//  DropAcornViewController.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/13/25.
//

import UIKit

import SnapKit
import Then

class DropAcornViewController: BaseNavViewController {
    
    // MARK: - UI Properties
    
    private let dropAcornView = DropAcornView()
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setXButton()
        self.setSecondTitleLabelStyle(title: StringLiterals.Upload.upload)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)

        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.contentView.addSubview(dropAcornView)
    }
    
    override func setLayout() {
        super.setLayout()

        dropAcornView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func setStyle() {
        super.setStyle()
        
        self.dropAcornView.leaveReviewButton.isEnabled = false
    }
    
    func addTarget() {
        dropAcornView.leaveReviewButton.addTarget(self,
                                                  action: #selector(leaveReviewButtonTapped),
                                                  for: .touchUpInside)
    }

}

    
// MARK: - @objc functions

extension DropAcornViewController {
    
    @objc
    func leaveReviewButtonTapped() {
        // TODO: - push to reviewFinishVC
    }
    
}
