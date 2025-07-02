//
//  ReviewFinishedViewController.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/13/25.
//

import UIKit

class ReviewFinishedViewController: BaseViewController {
    
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
        
        addTarget()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
        self.reviewFinishedView.finishedReviewLottieView.play()
    }
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.view.addSubview(reviewFinishedView)
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
            $0.setLabel(text: spotName.abbreviatedString(19) + StringLiterals.Upload.finishedReview,
                        style: .t2SB,
                        alignment: .center)
        }
    }
    
    func addTarget() {
        reviewFinishedView.doneButton.addTarget(self,
                                              action: #selector(doneButtonTapped),
                                              for: .touchUpInside)
    }

}

    
// MARK: - @objc functions

private extension ReviewFinishedViewController {
    
    @objc
    func doneButtonTapped() {
        closeView()
    }
    
}


// MARK: - Close View

private extension ReviewFinishedViewController {
    
    @objc
    func closeView() {
        NavigationUtils.navigateToTabBar()
    }
    
}
