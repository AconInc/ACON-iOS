//
//  SpotUploadSearchViewController.swift
//  ACON-iOS
//
//  Created by 김유림 on 7/16/25.
//

import UIKit

class SpotUploadSearchViewController: BaseUploadInquiryViewController {

    // MARK: - UI Properties

    private let spotSearchView = SpotSearchView()
    
    
    // MARK: - Properties

    override var contentViews: [UIView] {
        [spotSearchView]
    }

    override var canGoPrevious: Bool { false }

    override var canGoNext: Bool {
        guard let spotName = viewModel.spotName else { return false }
        return !spotName.isEmpty
    }

    private var selectedSpotName: String = ""
    
    private var spotUploadSearchViewModel = SpotUploadSearchViewModel()
    
    private let acDebouncer = ACDebouncer(delay: 0.3)
    
    private var keyboardWillShowObserver: NSObjectProtocol?
    
    private var keyboardWillHideObserver: NSObjectProtocol?
    

    // MARK: - init

    init(_ viewModel: SpotUploadViewModel) {
        super.init(viewModel: viewModel,
                   requirement: .required,
                   title: StringLiterals.SpotUpload.SearchThePlaceToRegister)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        spotSearchView.searchTextField.resignFirstResponder()
    }


    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
        bindTextField()
        registerCell()
        setDelegate()
        observeUserInputs()
    }
    

    // MARK: - UI Setting

    override func setLayout() {
        super.setLayout()

        spotSearchView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.greaterThanOrEqualTo(200)
        }
    }
    
    override func setStyle() {
        super.setStyle()

        self.hideKeyboard()
      
        spotSearchView.do {
            $0.searchSuggestionCollectionView.isHidden = true
            $0.searchTextField.setPlaceholder(as: "장소 선택")
            $0.searchTextField.isUserInteractionEnabled = true
            $0.searchTextField.textField.isEnabled = true
        }
    }
    
}


// MARK: - bindings

private extension SpotUploadSearchViewController {

    private func updateCollectionViewHeight() {
        let itemCount = spotUploadSearchViewModel.naverSearchResult.value?.count ?? 0
        let itemHeight = spotSearchView.searchKeywordCollectionViewFlowLayout.itemSize.height
        let spacing = spotSearchView.searchKeywordCollectionViewFlowLayout.minimumLineSpacing
        
        // 필요한 높이 계산 (여유 공간 포함)
        let requiredHeight = CGFloat(itemCount) * (itemHeight + spacing) + 40
        
        spotSearchView.snp.updateConstraints {
            $0.height.greaterThanOrEqualTo(min(requiredHeight, 400)) // 최대 400으로 제한
        }
    }

    func bindViewModel() {
        self.spotUploadSearchViewModel.naverSearchStatusCode.bind { [weak self] statusCode in
            guard let statusCode = statusCode else { return }
            if statusCode == 200 { return }
            
            let goToInstagram: () -> Void = { [weak self] in
                guard let self = self else { return }
                let termsOfUseVC = ACWebViewController(urlString: StringLiterals.WebView.instagramLink)
                self.present(termsOfUseVC, animated: true)
            }
            if statusCode == 429 {
                self?.presentACAlert(.naverAPILimitExceeded, leftAction: {self?.dismiss(animated: true)}, rightAction: goToInstagram)
            } else {
                self?.showDefaultAlert(title: "알림", message: "현재 장소 등록이 불가능해요.\nAcon Instagram을 통해 제보할 수 있어요.", okText: "제보하기", isCancelAvailable: true, completion: goToInstagram)
            }
        }
       
        self.spotUploadSearchViewModel.naverSearchResult.bind { [weak self] data in
            guard let data = data else { return }
            
            DispatchQueue.main.async {
                if data.isEmpty {
                    self?.spotSearchView.searchEmptyView.isHidden = self?.spotSearchView.searchTextField.text == ""
                    self?.spotSearchView.searchKeywordCollectionView.isHidden = true
                    self?.spotSearchView.searchKeywordCollectionView.reloadData()
                } else {
                    self?.spotSearchView.searchEmptyView.isHidden = true
                    self?.spotSearchView.searchKeywordCollectionView.isHidden = false
                    self?.spotSearchView.searchKeywordCollectionView.reloadData()
                    self?.updateCollectionViewHeight()
                }
            }
        }
    }
    
    func bindTextField() {
        spotSearchView.searchTextField.observableText.bind { [weak self] text in
            DispatchQueue.main.async {
                self?.spotSearchView.searchEmptyView.isHidden = true
                self?.spotSearchView.searchKeywordCollectionView.isHidden = true
            }

            guard let text else { return }
            
            self?.viewModel.spotName = text
            self?.updatePagingButtonStates()
            
            self?.spotSearchView.searchEmptyView.isHidden = text.isEmpty
            self?.spotSearchView.searchKeywordCollectionView.isHidden = text.isEmpty
            
            self?.acDebouncer.call { [weak self] in
                self?.updateSearchKeyword(text)
            }
        }
    }

}


// MARK: - CollectionView Setting Methods

private extension SpotUploadSearchViewController {
    
    func registerCell() {
        spotSearchView.searchKeywordCollectionView.register(SearchKeywordCollectionViewCell.self, forCellWithReuseIdentifier: SearchKeywordCollectionViewCell.cellIdentifier)
    }
    
    func setDelegate() {
        spotSearchView.searchTextField.delegate = self
        
        spotSearchView.searchKeywordCollectionView.delegate = self
        spotSearchView.searchKeywordCollectionView.dataSource = self
    }
    
}


// MARK: - CollectionView Delegate

extension SpotUploadSearchViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return spotSearchView.searchKeywordCollectionViewFlowLayout.itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: ScreenUtils.horizontalInset, bottom: 0, right: ScreenUtils.horizontalInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedSpotName = spotUploadSearchViewModel.naverSearchResult.value?[indexPath.item].spotName ?? ""
        spotSearchView.searchTextField.text = selectedSpotName
        self.dismissKeyboard()
    }
    
}


// MARK: - CollectionView DataSource

extension SpotUploadSearchViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return spotUploadSearchViewModel.naverSearchResult.value?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = spotUploadSearchViewModel.naverSearchResult.value?[indexPath.item]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchKeywordCollectionViewCell.cellIdentifier, for: indexPath) as? SearchKeywordCollectionViewCell else {
            return UICollectionViewCell() }
        cell.bindData(data, indexPath.item)
        return cell
    }
    
}


// MARK: - Search 메소드

private extension SpotUploadSearchViewController {
    
    func updateSearchKeyword(_ text: String) {
        if text == "" { return }
        spotUploadSearchViewModel.getNaverSearchResult(keyword: text)
    }
    
}


// MARK: - UITextFieldDelegate

extension SpotUploadSearchViewController: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        spotSearchView.glassView.isHidden = false
        spotSearchView.searchTextField.hideClearButton(isHidden: false)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        spotSearchView.glassView.isHidden = true
        spotSearchView.searchTextField.hideClearButton(isHidden: true)
    }
    
}


// MARK: - 스크롤 조정

extension SpotUploadSearchViewController {
    
    func observeUserInputs() {
        keyboardWillShowObserver = NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            self?.keyboardWillShow(notification)
        }

        keyboardWillHideObserver = NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            self?.keyboardWillHide(notification)
        }
    }
    
    @objc
    func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }

        if let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            
            var contentInset = spotUploadInquiryView.scrollView.contentInset
            contentInset.bottom = keyboardHeight
            spotUploadInquiryView.scrollView.contentInset = contentInset
            spotUploadInquiryView.scrollView.scrollIndicatorInsets = contentInset
            
            let scrollOffset = CGPoint(x: 0, y: 132*ScreenUtils.heightRatio)
            spotUploadInquiryView.scrollView.setContentOffset(scrollOffset, animated: true)
        }
    }

    @objc
    func keyboardWillHide(_ notification: Notification) {
        var contentInset = spotUploadInquiryView.scrollView.contentInset
        contentInset.bottom = 0
        spotUploadInquiryView.scrollView.contentInset = contentInset
        spotUploadInquiryView.scrollView.scrollIndicatorInsets = contentInset
    }
    
}
