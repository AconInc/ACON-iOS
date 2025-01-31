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
    
    private var spotSearchViewModel: SpotSearchViewModel
    
    private let acDebouncer = ACDebouncer(delay: 0.3)
    
    var completionHandler: ((Int64, String) -> Void)?
    
    private var selectedSpotId: Int64 = 0
    
    private var selectedSpotName: String = ""
      
    private let emptyStateView: SearchEmptyView = SearchEmptyView()
    
    // MARK: - LifeCycle
    
    init(spotSearchViewModel: SpotSearchViewModel) {
        self.spotSearchViewModel = spotSearchViewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        spotSearchViewModel.getSearchSuggestion()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        spotSearchView.searchTextField.resignFirstResponder()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if isBeingDismissed {
            if hasCompletedSelection {
                completionHandler?(selectedSpotId, selectedSpotName)
            }
            dismissCompletion?()
            hasCompletedSelection = false
        }
    }
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.view.addSubviews(spotSearchView, emptyStateView)
    }
    
    override func setLayout() {
        super.setLayout()

        spotSearchView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        emptyStateView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(ScreenUtils.heightRatio * 496)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    override func setStyle() {
        super.setStyle()
        
        self.view.backgroundColor = .glaW10
        self.view.backgroundColor?.withAlphaComponent(0.95)
        
        emptyStateView.do {
            $0.isHidden = true
        }
    }
    
    func addTarget() {
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
    func searchXButtonTapped() {
        spotSearchView.searchTextField.text = ""
        spotSearchViewModel.getSearchSuggestion()
        spotSearchView.searchSuggestionStackView.isHidden = false
        spotSearchView.searchKeywordCollectionView.isHidden = true
        emptyStateView.isHidden = true
    }
    
    @objc
    func searchTextFieldDidChange(_ textField: UITextField) {
        if let text = textField.text {
            emptyStateView.isHidden = text == ""
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
                self?.addActionToSearchKeywordButton()
            }
        }
        
        // TODO: - 계속 불러야 해서 일단 데이터 자체 바인딩. 추후 로딩이 필요한 경우 onSuccessGetSearchKeyword으로 바인딩 로직 재구성
        // TODO: - 또는 뷰모델에서 기존 키워드와 같은지 보고 updateKeyword이라는 옵저버블 패턴 만들어 updateKeyword.value = false
        self.spotSearchViewModel.searchKeywordData.bind { [weak self] data in
            guard let data = data else { return }
            
            DispatchQueue.main.async {
                if data.count == 0 {
                    self?.emptyStateView.isHidden = self?.spotSearchView.searchTextField.text == ""
                    self?.spotSearchView.searchKeywordCollectionView.isHidden = true
                    self?.spotSearchView.searchKeywordCollectionView.reloadData()
                } else {
                    self?.emptyStateView.isHidden = true
                    self?.spotSearchView.searchKeywordCollectionView.isHidden = false
                    self?.spotSearchView.searchKeywordCollectionView.reloadData()
                }
            }
        }
        
        self.spotSearchViewModel.onSuccessGetReviewVerification.bind { [weak self] onSuccess in
            guard let onSuccess, let data = self?.spotSearchViewModel.reviewVerification.value else { return }
            if onSuccess {
                if data {
                    self?.hasCompletedSelection = true
                    self?.dismiss(animated: true)
                } else {
                    let alertHandler = AlertHandler()
                    alertHandler.showLocationAccessFailImageAlert(from: self!)
                }
                self?.spotSearchViewModel.reviewVerification.value = nil
            }
        }
        
    }

}


// MARK: - 추천 검색어 클릭 로직

private extension SpotSearchViewController {
    
    func addActionToSearchKeywordButton() {
        spotSearchView.searchSuggestionStackView.arrangedSubviews.forEach { view in
            if let button = view as? UIButton {
                button.addTarget(self,
                                 action: #selector(searchKeywordButtonTapped(_:)),
                                 for: .touchUpInside)
            }
        }
    }
    
    @objc
    func searchKeywordButtonTapped(_ sender: UIButton) {
        guard let spotName = sender.currentAttributedTitle?.string else { return }
        selectedSpotId = sender.spotID
        selectedSpotName = spotName
        spotSearchViewModel.getReviewVerification(spotId: selectedSpotId)
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
        selectedSpotId = spotSearchViewModel.searchKeywordData.value?[indexPath.item].spotID ?? 1
        selectedSpotName = spotSearchViewModel.searchKeywordData.value?[indexPath.item].spotName ?? ""
        spotSearchView.searchTextField.text = selectedSpotName
        self.dismissKeyboard()
        spotSearchViewModel.getReviewVerification(spotId: selectedSpotId)
    }
    
}


// MARK: - CollectionView DataSource

extension SpotSearchViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return spotSearchViewModel.searchKeywordData.value?.count ?? 0
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
        spotSearchViewModel.getSearchKeyword(keyword: text)
        // TODO: - 빈 리스트?
    }
    
}
