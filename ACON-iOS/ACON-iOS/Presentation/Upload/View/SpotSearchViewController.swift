//
//  SpotSearchViewController.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/14/25.
//

import UIKit
import CoreLocation

class SpotSearchViewController: BaseNavViewController {
    
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
    
    var latitude: Double = 0
    
    var longitude: Double = 0

    
    // MARK: - LifeCycle
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        ACLocationManager.shared.addDelegate(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
       ACLocationManager.shared.removeDelegate(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setXButton()
        self.setNextButton()
        self.setCenterTitleLabelStyle(title: StringLiterals.Upload.upload)
        self.rightButton.isEnabled = false
        
        addTarget()
        self.hideKeyboard()
        registerCell()
        setDelegate()
        bindTextField()
        bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        ACLocationManager.shared.checkUserDeviceLocationServiceAuthorization()
        // TODO: - 임시방편으로 asyncAfter, 타이밍 문제 고치기
        DispatchQueue.main.asyncAfter(deadline: .now()+0.05) {
            self.spotSearchViewModel.getSearchSuggestion()
        }
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
    
    func addTarget() {
        self.leftButton.addTarget(self,
                                  action: #selector(xButtonTapped),
                                  for: .touchUpInside)

        self.rightButton.addTarget(self,
                                   action: #selector(nextButtonTapped),
                                    for: .touchUpInside)
    }

}


// MARK: - Bind TextField, ViewModel

private extension SpotSearchViewController {

    func bindTextField() {
        spotSearchView.searchTextField.observableText.bind { [weak self] text in
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
        self.spotSearchViewModel.onSuccessGetSearchSuggestion.bind { [weak self] onSuccess in
            guard let onSuccess else { return }
            if onSuccess {
                guard let data = self?.spotSearchViewModel.searchSuggestionData.value else { return }
                self?.spotSearchView.searchSuggestionCollectionView.reloadData()
            } else {
                let errorType = self?.spotSearchViewModel.reviewVerificationErrorType
                let alertHandler = AlertHandler()
                if errorType == .unsupportedRegion {
                    alertHandler.showUnsupportedRegionImageAlert(from: self!)
                } // TODO: errorType == 존재하지 않는 장소일 때 Alert 필요 (40403 에러)
                self?.showDefaultAlert(title: "추천 검색어 로드 실패", message: "추천 검색어 로드에 실패했습니다.")
            }
            self?.spotSearchViewModel.onSuccessGetSearchSuggestion.value = nil
        }
        
        // TODO: - 계속 불러야 해서 일단 데이터 자체 바인딩. 추후 로딩이 필요한 경우 onSuccessGetSearchKeyword으로 바인딩 로직 재구성
        // TODO: - 또는 뷰모델에서 기존 키워드와 같은지 보고 updateKeyword이라는 옵저버블 패턴 만들어 updateKeyword.value = false
        self.spotSearchViewModel.searchKeywordData.bind { [weak self] data in
            guard let data = data else { return }
            
            // TODO: - 동시에 보여질 때 있음, 타이밍 문제
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
                    let alertHandler = AlertHandler()
                    alertHandler.showLocationAccessFailImageAlert(from: self!)
                }
            } else {
                let errorType = self?.spotSearchViewModel.reviewVerificationErrorType
                let alertHandler = AlertHandler()
                if errorType == .unsupportedRegion {
                    alertHandler.showUnsupportedRegionImageAlert(from: self!)
                } // TODO: errorType == 존재하지 않는 장소일 때 Alert 필요 (40403 에러)
                self?.showDefaultAlert(title: "연관 검색어 로드 실패", message: "연관 검색어 로드에 실패했습니다.")
            }
            self?.spotSearchViewModel.reviewVerification.value = nil
        }
    }

}


// MARK: - @objc functions

private extension SpotSearchViewController {
    
    @objc
    func nextButtonTapped() {
        let vc = DropAcornViewController(spotID: selectedSpotID)
        vc.modalPresentationStyle = .fullScreen
        AmplitudeManager.shared.trackEventWithProperties(AmplitudeLiterals.EventName.placeUpload, properties: ["click_review_next?": true])
        present(vc, animated: false)
    }
    
    @objc
    func xButtonTapped() {
        let alertHandler = AlertHandler()
        alertHandler.showUploadExitAlert(from: self)
    }
    
}


// MARK: - ACLocationManagerDelegate

extension SpotSearchViewController: ACLocationManagerDelegate {
    
    func locationManager(_ manager: ACLocationManager, didUpdateLocation coordinate: CLLocationCoordinate2D) {

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            print("성공 - 위도: \(coordinate.latitude), 경도: \(coordinate.longitude)")
            self.latitude = coordinate.latitude
            self.longitude = coordinate.longitude
            self.spotSearchViewModel.setCoordinates(self.latitude, self.longitude)
        }
    }
    
}


// MARK: - CollectionView Setting Methods

private extension SpotSearchViewController {
    
    func registerCell() {
        spotSearchView.searchSuggestionCollectionView.register(SearchSuggestionCollectionViewCell.self, forCellWithReuseIdentifier: SearchSuggestionCollectionViewCell.cellIdentifier)
        
        spotSearchView.searchKeywordCollectionView.register(SearchKeywordCollectionViewCell.self, forCellWithReuseIdentifier: SearchKeywordCollectionViewCell.cellIdentifier)
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
        return UIEdgeInsets(top: 0, left: ScreenUtils.widthRatio*16, bottom: 0, right: ScreenUtils.widthRatio*16)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == spotSearchView.searchSuggestionCollectionView {
            selectedSpotID = spotSearchViewModel.searchSuggestionData.value?[indexPath.item].spotID ?? 1
            selectedSpotName = spotSearchViewModel.searchSuggestionData.value?[indexPath.item].spotName ?? ""
        } else {
            selectedSpotID = spotSearchViewModel.searchKeywordData.value?[indexPath.item].spotID ?? 1
            selectedSpotName = spotSearchViewModel.searchKeywordData.value?[indexPath.item].spotName ?? ""
        }
        spotSearchView.searchTextField.text = selectedSpotName
        if collectionView == spotSearchView.searchKeywordCollectionView {
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
