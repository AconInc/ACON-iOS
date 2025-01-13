//
//  ReviewFinishedViewController.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/13/25.
//

import UIKit

import SnapKit
import Then

class ReviewFinishedViewController: BaseNavViewController {
    
    // MARK: - UI Properties
    
    private let reviewFinishedView = ReviewFinishedView()
    
    
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
        
        self.contentView.addSubview(reviewFinishedView)
    }
    
    override func setLayout() {
        super.setLayout()

        reviewFinishedView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func addTarget() {
        reviewFinishedView.okButton.addTarget(self,
                                              action: #selector(okButtonTapped),
                                              for: .touchUpInside)
    }

}

    
// MARK: - @objc functions

extension ReviewFinishedViewController {
    
    @objc
    func okButtonTapped() {
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController = ACTabBarController()
        }
    }
    
}
