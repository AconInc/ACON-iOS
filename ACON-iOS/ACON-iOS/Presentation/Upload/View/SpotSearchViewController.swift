//
//  SpotSearchViewController.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/14/25.
//

import UIKit

import SnapKit
import Then

class SpotSearchViewController: BaseNavViewController {
    
    // MARK: - UI Properties
    
    private let spotSearchView = SpotSearchView()
    
    var recentSpotStackView: UIStackView = UIStackView()

//    var recommendedSpotCollectionView: UICollectionView = UICollectionView()

    let emptyImageView: UIImageView = UIImageView()

    let emptyLabel: UILabel = UILabel()

    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTarget()
        self.hideKeyboard()
    }
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.contentView.addSubview(spotSearchView)
    }
    
    override func setLayout() {
        super.setLayout()

        spotSearchView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(ScreenUtils.height*126/780)
        }
    }
    
    func addTarget() {
        spotSearchView.doneButton.addTarget(self,
                                              action: #selector(doneButtonTapped),
                                              for: .touchUpInside)
    }

}

    
// MARK: - @objc functions

extension SpotSearchViewController {
    
    @objc
    func doneButtonTapped() {
        self.dismiss(animated: true)
    }
    
}
