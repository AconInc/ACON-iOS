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
    
    
    // MARK: - Properties
    
    var reviewAcornCount: Int = 0
    
    
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
        for i in 0...4 {
            let btn = dropAcornView.acornStackView.arrangedSubviews[i] as? UIButton
            btn?.tag = i
            btn?.addTarget(self, action: #selector(reviewAcornButtonTapped(_:)), for: .touchUpInside)
        }
    }

}

    
// MARK: - @objc functions

extension DropAcornViewController {
    
    @objc
    func leaveReviewButtonTapped() {
        // TODO: - reviewAcornCount 서버 POST
        let vc = ReviewFinishedViewController()
        navigationController?.pushViewController(vc, animated: false)
    }
    
    @objc
    func reviewAcornButtonTapped(_ sender: UIButton) {
        let selectedIndex = sender.tag
        for i in 0...4 {
            let btn = dropAcornView.acornStackView.arrangedSubviews[i] as? UIButton
            btn?.isSelected = i <= selectedIndex ? true : false
        }
        dropAcornView.acornReviewLabel.text = "\(selectedIndex+1)/5"
        reviewAcornCount = selectedIndex + 1
        enableLeaveReviewButton()
    }
    
}

extension DropAcornViewController {
    
    func enableLeaveReviewButton() {
        dropAcornView.leaveReviewButton.do {
            $0.isEnabled = true
            $0.backgroundColor = .org0
        }
    }
    
}
