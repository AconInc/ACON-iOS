//
//  SpotSearchViewController.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/14/25.
//

import UIKit

class SpotSearchViewController: BaseNavViewController{
    
    // MARK: - UI Properties
    
    private let spotSearchView = SpotSearchView()


    // MARK: - Properties
    
    private var hasCompletedSelection = false
    
    private var spotSearchViewModel = SpotSearchViewModel()
    
    private let acDebouncer = ACDebouncer(delay: 0.3)
    
    var completionHandler: ((Int64, String) -> Void)?
    
    private var selectedSpotID: Int64 = -1
    
    private var selectedSpotName: String = ""
    
    var dismissCompletion: (() -> Void)?
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTarget()
        self.hideKeyboard()
        registerCell()
        setDelegate()
        bindTextField()
        bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.spotSearchViewModel.checkLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        spotSearchView.searchTextField.resignFirstResponder()
    }
    
    
    // MARK: - UI Setting Methods
    
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
        
        self.setXButton(#selector(spotSearchXButtonTapped))
        self.setNextButton()
        self.setCenterTitleLabelStyle(title: StringLiterals.Upload.upload)
        self.rightButton.isEnabled = false
        
        spotSearchView.searchKeywordCollectionViewFlowLayout.footerReferenceSize = CGSize(width: ScreenUtils.widthRatio*328, height: ScreenUtils.heightRatio*60)
    }
    
    func addTarget() {
        self.rightButton.addTarget(self,
                                   action: #selector(nextButtonTapped),
                                    for: .touchUpInside)
    }

}


// MARK: - Bind TextField, ViewModel

private extension SpotSearchViewController {

    func bindTextField() {
        spotSearchView.searchTextField.observableText.bind { [weak self] text in
            DispatchQueue.main.async {
                self?.spotSearchView.searchEmptyView.isHidden = true
                self?.spotSearchView.searchKeywordCollectionView.isHidden = true
            }

            if let text = text {
                if text != self?.selectedSpotName {
                    self?.rightButton.isEnabled = false
                }
                self?.spotSearchView.searchEmptyView.isHidden = text.isEmpty
                self?.spotSearchView.searchKeywordCollectionView.isHidden = text.isEmpty
                
                self?.acDebouncer.call { [weak self] in
                    self?.updateSearchKeyword(text)
                }
            }
        }
    }

    func bindViewModel() {
        self.spotSearchViewModel.isLocationReady.bind { [weak self] isReady in
            guard let isReady else { return }
            if isReady {
                self?.spotSearchViewModel.getSearchSuggestion()
            }
            self?.spotSearchViewModel.isLocationReady.value = nil
        }
        
        self.spotSearchViewModel.onSuccessGetSearchSuggestion.bind { [weak self] onSuccess in
            guard let onSuccess else { return }
            if onSuccess {
                guard (self?.spotSearchViewModel.searchSuggestionData.value) != nil else { return }
                self?.spotSearchView.searchSuggestionCollectionView.reloadData()
            } else {
                let errorType = self?.spotSearchViewModel.reviewVerificationErrorType
                if errorType == .unsupportedRegion {
                    self?.presentACAlert(.locationAccessFail)
                }
            }
            self?.spotSearchViewModel.onSuccessGetSearchSuggestion.value = nil
        }
        
        // TODO: - 계속 불러야 해서 일단 데이터 자체 바인딩. 추후 로딩이 필요한 경우 onSuccessGetSearchKeyword으로 바인딩 로직 재구성
        // TODO: - 또는 뷰모델에서 기존 키워드와 같은지 보고 updateKeyword이라는 옵저버블 패턴 만들어 updateKeyword.value = false
        self.spotSearchViewModel.searchKeywordData.bind { [weak self] data in
            guard let data = data else { return }
            
            // TODO: - 🆘 동시에 보여질 때 있음, 타이밍 문제
            DispatchQueue.main.async {
                if data.isEmpty {
                    self?.spotSearchView.searchEmptyView.isHidden = self?.spotSearchView.searchTextField.text == ""
                    self?.spotSearchView.searchKeywordCollectionView.isHidden = true
                    self?.spotSearchView.searchKeywordCollectionView.reloadData()
                } else {
                    self?.spotSearchView.searchEmptyView.isHidden = true
                    self?.spotSearchView.searchKeywordCollectionView.isHidden = false
                    self?.spotSearchView.searchKeywordCollectionView.reloadData()
                }
            }
        }
        
        self.spotSearchViewModel.onSuccessGetReviewVerification.bind { [weak self] onSuccess in
            guard let onSuccess else { return }
            if onSuccess {
                guard let data = self?.spotSearchViewModel.reviewVerification.value else { return }
                if data {
                    self?.rightButton.isEnabled = true
                } else {
                    self?.presentACAlert(.reviewLocationFail)
                    self?.rightButton.isEnabled = false
                }
            } else {
                let errorType = self?.spotSearchViewModel.reviewVerificationErrorType
                if errorType == .unsupportedRegion {
                    self?.presentACAlert(.locationAccessFail)
                }
                self?.rightButton.isEnabled = false
            }
            self?.spotSearchViewModel.reviewVerification.value = nil
        }
    }

}


// MARK: - @objc functions

private extension SpotSearchViewController {
                    
    @objc
    func spotSearchXButtonTapped() {
        self.navigationController?.dismiss(animated: true)
    }
    
    @objc
    func nextButtonTapped() {
        AmplitudeManager.shared.trackEventWithProperties(AmplitudeLiterals.EventName.upload, properties: ["click_review_next?": true])

        let vm = SpotReviewViewModel(spotID: selectedSpotID, spotName: selectedSpotName)
        let vc = ReviewMenuRecommendationViewController(vm)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    func addPlaceFooterTapped() {
//        AmplitudeManager.shared.trackEventWithProperties(AmplitudeLiterals.EventName.upload, properties: ["click_register_form?": true])
        let addPlaceVC = SpotUploadViewController()
        addPlaceVC.modalPresentationStyle = .fullScreen
        self.present(addPlaceVC, animated: true)
    }
    
}


// MARK: - CollectionView Setting Methods

private extension SpotSearchViewController {
    
    func registerCell() {
        spotSearchView.searchSuggestionCollectionView.register(SearchSuggestionCollectionViewCell.self, forCellWithReuseIdentifier: SearchSuggestionCollectionViewCell.cellIdentifier)
        
        spotSearchView.searchKeywordCollectionView.register(SearchKeywordCollectionViewCell.self, forCellWithReuseIdentifier: SearchKeywordCollectionViewCell.cellIdentifier)
        spotSearchView.searchKeywordCollectionView.register(SearchKeywordCollectionFooterView.self,
                                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                                            withReuseIdentifier: SearchKeywordCollectionFooterView.identifier)
    }
    
    func setDelegate() {
        spotSearchView.searchTextField.delegate = self
        
        spotSearchView.searchSuggestionCollectionView.delegate = self
        spotSearchView.searchSuggestionCollectionView.dataSource = self
        
        spotSearchView.searchKeywordCollectionView.delegate = self
        spotSearchView.searchKeywordCollectionView.dataSource = self
    }
    
}


// MARK: - CollectionView Delegate

extension SpotSearchViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView == spotSearchView.searchSuggestionCollectionView ? spotSearchView.searchSuggestionCollectionViewFlowLayout.itemSize : spotSearchView.searchKeywordCollectionViewFlowLayout.itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: ScreenUtils.horizontalInset, bottom: 0, right: ScreenUtils.horizontalInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == spotSearchView.searchSuggestionCollectionView {
            selectedSpotID = spotSearchViewModel.searchSuggestionData.value?[indexPath.item].spotID ?? 1
            selectedSpotName = spotSearchViewModel.searchSuggestionData.value?[indexPath.item].spotName ?? ""
            spotSearchView.searchTextField.text = selectedSpotName
            updateSearchKeyword(selectedSpotName)
        } else if collectionView == spotSearchView.searchKeywordCollectionView {
            selectedSpotID = spotSearchViewModel.searchKeywordData.value?[indexPath.item].spotID ?? 1
            selectedSpotName = spotSearchViewModel.searchKeywordData.value?[indexPath.item].spotName ?? ""
            spotSearchView.searchTextField.text = selectedSpotName
            self.dismissKeyboard()
        }
        spotSearchViewModel.getReviewVerification(spotId: selectedSpotID)
    }
    
}


// MARK: - CollectionView DataSource

extension SpotSearchViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == spotSearchView.searchSuggestionCollectionView {
            return spotSearchViewModel.searchSuggestionData.value?.count ?? 0
        } else {
            return spotSearchViewModel.searchKeywordData.value?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == spotSearchView.searchSuggestionCollectionView {
            let data = spotSearchViewModel.searchSuggestionData.value?[indexPath.item]
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchSuggestionCollectionViewCell.cellIdentifier, for: indexPath) as? SearchSuggestionCollectionViewCell else {
                return UICollectionViewCell() }
            cell.bindData(data?.spotName, indexPath.item)
            return cell
        } else {
            let data = spotSearchViewModel.searchKeywordData.value?[indexPath.item]
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchKeywordCollectionViewCell.cellIdentifier, for: indexPath) as? SearchKeywordCollectionViewCell else {
                return UICollectionViewCell() }
            cell.bindData(data, indexPath.item)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SearchKeywordCollectionFooterView.identifier, for: indexPath)
        
            footer.gestureRecognizers?.removeAll()
        
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addPlaceFooterTapped))
            tapGesture.cancelsTouchesInView = false
            footer.addGestureRecognizer(tapGesture)

        return footer
    }
    
}


// MARK: - Search 메소드

private extension SpotSearchViewController {
    
    func updateSearchKeyword(_ text: String) {
        spotSearchViewModel.getSearchKeyword(keyword: text)
        // TODO: - 빈 리스트?
    }
    
}


// MARK: - UITextFieldDelegate

extension SpotSearchViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        spotSearchView.glassView.isHidden = false
        spotSearchView.searchTextField.hideClearButton(isHidden: false)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        spotSearchView.glassView.isHidden = true
        spotSearchView.searchTextField.hideClearButton(isHidden: true)
    }

}
