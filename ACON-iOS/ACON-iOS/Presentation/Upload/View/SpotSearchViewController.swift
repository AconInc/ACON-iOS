//
//  SpotSearchViewController.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/14/25.
//

import UIKit

import SnapKit
import Then

class SpotSearchViewController: BaseViewController {
    
    // MARK: - UI Properties
    
    private let spotSearchView = SpotSearchView()


    // MARK: - Properties
    
    private var hasCompletedSelection = false
    
    private let spotSearchViewModel = SpotSearchViewModel()
    
    private let acDebouncer = ACDebouncer(delay: 0.3)
    
    var completionHandler: ((Int64, String) -> Void)?
    
    private var selectedSpotId: Int64 = 0
    
    private var selectedSpotName: String = ""
      
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboard()
        addTarget()
        registerCell()
        setDelegate()
        bindViewModel()
    }
    
    var dismissCompletion: (() -> Void)?

    override func viewWillAppear(_ animated: Bool) {
        // TODO: - getSearchSuggestion 서버통신
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        spotSearchView.searchTextField.resignFirstResponder()
        print("===== viewWillDisappear called =====")
        print("isBeingDismissed: \(isBeingDismissed)")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("===== viewDidDisappear called =====")
        print("hasCompletedSelection: \(hasCompletedSelection)")
        if isBeingDismissed {
            if hasCompletedSelection {
                print("===== completionHandler will be called =====")
                completionHandler?(selectedSpotId, selectedSpotName)
            }
            print("===== dismissCompletion will be called =====")
            dismissCompletion?()
        }
    }
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.view.addSubview(spotSearchView)
    }
    
    override func setLayout() {
        super.setLayout()

        spotSearchView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func setStyle() {
        super.setStyle()
        
        self.view.backgroundColor = .glaW10
        self.view.backgroundColor?.withAlphaComponent(0.95)
    }
    
    func addTarget() {
        spotSearchView.doneButton.addTarget(self,
                                              action: #selector(doneButtonTapped),
                                              for: .touchUpInside)
        
        spotSearchView.searchXButton.addTarget(self,
                                              action: #selector(searchXButtonTapped),
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
        print("===== doneButton tapped =====")
        hasCompletedSelection = true
        spotSearchView.searchTextField.resignFirstResponder()
        dismiss(animated: true)
    }
    
    @objc
    func searchXButtonTapped() {
        spotSearchView.searchTextField.text = ""
        spotSearchView.searchSuggestionStackView.isHidden = false
        spotSearchView.searchKeywordCollectionView.isHidden = true
    }
    
    @objc
    func searchTextFieldDidChange(_ textField: UITextField) {
        if let text = textField.text {
            spotSearchView.searchSuggestionStackView.isHidden = text != ""
            spotSearchView.searchKeywordCollectionView.isHidden = text == ""
        }
    }
    
}


// MARK: - Bind ViewModel

private extension SpotSearchViewController {

    func bindViewModel() {
        self.spotSearchViewModel.onSuccessGetSearchSuggestion.bind { [weak self] onSuccess in
            guard let onSuccess, let data = self?.spotSearchViewModel.searchSuggestionData.value else { return }
            if onSuccess {
                self?.spotSearchView.bindData(data)
            }
        }
        
        self.spotSearchViewModel.onSuccessGetSearchKeyword.bind { [weak self] onSuccess in
            guard let onSuccess, let onUpdate = self?.spotSearchViewModel.updateSearchKeyword.value, let data = self?.spotSearchViewModel.searchKeywordData.value else { return }
            if onSuccess && onUpdate {
                if data.count == 0 {
                    DispatchQueue.main.async {
                        // TODO: - 엠티뷰 처리
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.spotSearchView.searchKeywordCollectionView.reloadData()
                    }
                }
                self?.spotSearchViewModel.updateSearchKeyword.value = false
            }
        }
        
    }

}


// MARK: - CollectionView Setting Methods

private extension SpotSearchViewController {
    
    func registerCell() {
        spotSearchView.searchKeywordCollectionView.register(SearchKeywordCollectionViewCell.self, forCellWithReuseIdentifier: SearchKeywordCollectionViewCell.cellIdentifier)
    }
    
    func setDelegate() {
        spotSearchView.searchKeywordCollectionView.delegate = self
        spotSearchView.searchKeywordCollectionView.dataSource = self
        spotSearchView.searchTextField.delegate = self
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
        selectedSpotId = spotSearchViewModel.searchKeywordDummyData[indexPath.item].spotID
        selectedSpotName = spotSearchViewModel.searchKeywordDummyData[indexPath.item].spotName
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
        let data = spotSearchViewModel.searchKeywordData.value?[indexPath.item]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchKeywordCollectionViewCell.cellIdentifier, for: indexPath) as? SearchKeywordCollectionViewCell else {
            return UICollectionViewCell() }
        cell.bindData(data, indexPath.item)
        return cell
    }
    
}

// MARK: - TextField

extension SpotSearchViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        acDebouncer.call { [weak self] in
            self?.updateSearchKeyword(textField.text ?? "")
        }
        return true
    }
    
}


// MARK: - Search 메소드

extension SpotSearchViewController{
    
    func updateSearchKeyword(_ text: String) {
        // 뷰모델 서버통신함수 새로 부르기 - spotSearchViewModel.getSpotKeyword()
    }
    
}
