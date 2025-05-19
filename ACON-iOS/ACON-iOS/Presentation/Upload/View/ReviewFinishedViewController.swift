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
    
    private var spotName: String = ""
    
    // MARK: - LifeCycle
    
    init(spotName: String) {
        self.spotName = spotName
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setXButton()
        addTarget()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
        self.reviewFinishedView.finishedReviewLottieView.play()
        var timeLeftToClose = 5
        let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            self.reviewFinishedView.closeViewLabel.do {
                $0.setLabel(text: "\(timeLeftToClose)"+StringLiterals.Upload.closeAfter,
                            style: .b3,
                            color: .gray300)
            }
            timeLeftToClose -= 1
            if timeLeftToClose < 0 {
                timer.invalidate()
                self.closeView()
            }
        }
        timer.fire()
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
        
        reviewFinishedView.finishedReviewLabel.do {
            $0.setLabel(text: spotName.abbreviatedString(9) + StringLiterals.Upload.finishedReview,
                        style: .t2SB,
                        alignment: .center)
        }
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
        
        topController.dismiss(animated: true) {
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let sceneDelegate = scene.delegate as? SceneDelegate,
               let tabBarController = sceneDelegate.window?.rootViewController as? ACTabBarController {
                tabBarController.selectedIndex = 0
            }
        }
    }
    
}
