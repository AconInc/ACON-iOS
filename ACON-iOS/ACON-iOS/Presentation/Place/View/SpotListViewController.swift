//
//  SpotListViewController.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/11/25.
//

import UIKit

class SpotListViewController: BaseViewController {
    
    // MARK: - UI Properties
    
    private let spotListView = SpotListView()
    
    
    // MARK: - Properties
    
//    private let spotiewModel =
    
    
    // MARK: - LifeCycle
    
    override func loadView() {
        view = spotListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCollectionView()
    }
    
    override func setHierarchy() {}
    
    override func setLayout() {}
    
    override func setStyle() {
        self.view.backgroundColor = .gray9
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
}


// MARK: - CollectionView Settings

extension SpotListViewController {
    
    private func setCollectionView() {
        setDelegate()
        registerCells()
    }
    
    private func setDelegate() {
        spotListView.collectionView.dataSource = self
        spotListView.collectionView.delegate = self
    }
    
    private func registerCells() {
        spotListView.collectionView.register(
            LargeSpotListCollectionViewCell.self,
            forCellWithReuseIdentifier: LargeSpotListCollectionViewCell.cellIdentifier
        )
    }
    
}

extension SpotListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = collectionView.dequeueReusableCell(withReuseIdentifier: LargeSpotListCollectionViewCell.cellIdentifier, for: indexPath) as? LargeSpotListCollectionViewCell
        else { return UICollectionViewCell() }
        
        return item
    }
    
}

extension SpotListViewController: UICollectionViewDelegate {
    
}
