//
//  OnboardingViewController.swift
//  ACON-iOS
//
//  Created by 이수민 on 5/8/25.
//

import UIKit

class OnboardingViewController: BaseViewController {
    
    // MARK: - UI Properties
    
    private let onboardingView = OnboardingView()
    
    let categories = ["새우", "게", "조개", "굴", "회", "생선", "해산물", "육회/육사시미", "선지", "순대", "곱창/대창/막창", "닭발", "닭똥집", "양고기", "돼지/소 특수부위", "채소"]
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCell()
        setDelegate()
    }
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.view.addSubview(onboardingView)
    }
    
    override func setLayout() {
        super.setLayout()

        onboardingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
}


// MARK: - CollectionView Setting Methods

private extension OnboardingViewController {
    
    func registerCell() {
        onboardingView.dislikeFoodCollectionView.register(DislikeFoodCollectionViewCell.self, forCellWithReuseIdentifier: DislikeFoodCollectionViewCell.cellIdentifier)
    }
    
    func setDelegate() {
        onboardingView.dislikeFoodCollectionView.delegate = self
        onboardingView.dislikeFoodCollectionView.dataSource = self
    }
    
}


// MARK: - CollectionView Delegate

extension OnboardingViewController: UICollectionViewDelegateFlowLayout {
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return OnboardingView.dislikeFoodCollectionViewFlowLayout.itemSize
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: ScreenUtils.widthRatio*16, bottom: 0, right: ScreenUtils.widthRatio*16)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}


// MARK: - CollectionView DataSource

extension OnboardingViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = categories[indexPath.item]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DislikeFoodCollectionViewCell.cellIdentifier, for: indexPath) as? DislikeFoodCollectionViewCell else {
            return UICollectionViewCell() }
        cell.bindData(data, indexPath.item)
        return cell
    }
    
}
