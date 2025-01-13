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


    // MARK: - Properties
    
    private let spotSearchViewModel = SpotSearchViewModel()
    
    var completionHandler: ((Int, String) -> Void)?
    
    var selectedSpotId: Int = 0
    
    var selectedSpotName: String = ""
      
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboard()
        addTarget()
        registerCell()
        setDelegate()
    }
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.contentView.addSubview(spotSearchView)
    }
    
    override func setLayout() {
        super.setLayout()

        spotSearchView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func setStyle() {
        super.setStyle()
        
        setRecommendedSpotStackView(data: spotSearchViewModel.recommendedSearchDummyData)
    }
    
    func addTarget() {
        spotSearchView.doneButton.addTarget(self,
                                              action: #selector(doneButtonTapped),
                                              for: .touchUpInside)
        spotSearchView.searchTextField.addTarget(self,
                           action: #selector(searchTextFieldDidChange),
                           for: .editingChanged)
    }

}

    
// MARK: - @objc functions

private extension SpotSearchViewController {
    
    @objc
    func doneButtonTapped() {
        completionHandler?(selectedSpotId, selectedSpotName)
        self.dismiss(animated: true)
    }
    
    @objc
    func searchTextFieldDidChange(_ textField: UITextField) {
        if let text = textField.text {
            spotSearchView.recommendedSpotStackView.isHidden = text != ""
            spotSearchView.relatedSearchCollectionView.isHidden = text == ""
            
            if text != "" {
                // TODO: - 여기서 디바운스 로직? + reloadData()?
            }
        }
    }
    
}


// MARK: - Set UI

private extension SpotSearchViewController {
    
    func setRecommendedSpotStackView(data: RecommendedSearchModel) {
        for i in 0...4 {
            let button = spotSearchView.makeRecommendedSpotButton(data.spotList[i])
            spotSearchView.recommendedSpotStackView.addArrangedSubview(button)
        }
    }
    
}


// MARK: - CollectionView Setting Methods

private extension SpotSearchViewController {
    
    func registerCell() {
        spotSearchView.relatedSearchCollectionView.register(RelatedSearchCollectionViewCell.self, forCellWithReuseIdentifier: RelatedSearchCollectionViewCell.cellIdentifier)
    }
    
    func setDelegate() {
        spotSearchView.relatedSearchCollectionView.delegate = self
        spotSearchView.relatedSearchCollectionView.dataSource = self
    }
    
}


// MARK: - CollectionView Delegate

extension SpotSearchViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return SpotSearchView.relatedSearchCollectionViewFlowLayout.itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: ScreenUtils.width * 0.112, bottom: 0, right: ScreenUtils.width * 0.112)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedSpotId = spotSearchViewModel.relatedSearchDummyData[indexPath.item].spotID
        selectedSpotName = spotSearchViewModel.relatedSearchDummyData[indexPath.item].spotName
        spotSearchView.searchTextField.text = selectedSpotName
        self.dismissKeyboard()
    }
    
}


// MARK: - CollectionView DataSource

extension SpotSearchViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = spotSearchViewModel.relatedSearchDummyData[indexPath.item]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RelatedSearchCollectionViewCell.cellIdentifier, for: indexPath) as? RelatedSearchCollectionViewCell else {
            return UICollectionViewCell() }
        cell.dataBind(data, indexPath.item)
        return cell
    }
    
}
