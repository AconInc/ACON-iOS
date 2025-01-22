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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
        self.reviewFinishedView.finishedReviewLottieView.play()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.closeView()
        }
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
    
    override func setStyle() {
        super.setStyle()
        
        self.setXButton()
    }
    
    func addTarget() {
        self.leftButton.addTarget(self,
                                  action: #selector(xButtonTapped),
                                  for: .touchUpInside)
        reviewFinishedView.okButton.addTarget(self,
                                              action: #selector(okButtonTapped),
                                              for: .touchUpInside)
    }

}

    
// MARK: - @objc functions

private extension ReviewFinishedViewController {
    
    @objc
    func xButtonTapped() {
        closeView()
    }
    
    @objc
    func okButtonTapped() {
        closeView()
    }
    
}


// MARK: - Close View

private extension ReviewFinishedViewController {
    
    @objc
    func closeView() {
        var topController: UIViewController = self
        while let presenting = topController.presentingViewController {
            topController = presenting
        }
        
        topController.dismiss(animated: true){ [weak self] in
            if let tabBarController = UIApplication.shared.keyWindow?.rootViewController as? ACTabBarController {
                tabBarController.selectedIndex = 0
            }
        }
    }
    
}
