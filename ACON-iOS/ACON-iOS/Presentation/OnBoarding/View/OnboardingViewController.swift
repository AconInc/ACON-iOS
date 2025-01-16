//
//  OnboardingViewController.swift
//  ACON-iOS
//
//  Created by Jaehyun Ahn on 1/15/25.
//

import SwiftUI
import UIKit

import SnapKit
import Then

final class OnboardingViewController: BaseViewController {
    
    let viewModel = OnboardingViewModel()
    
    private let backButton = UIButton()
    private let skipButton = UIButton()
    private let progressView = UIView()
    private let progressIndicator = UIView()
    private let nextButton = UIButton()
    private let progressNumber = UILabel()
    private let progressTitle = UILabel()
    private var isOverlayVisible = false
    var currentStep = 0
    
    private var contentView: UIView?
    private let dislikeCollectionView = DislikeCollectionView()
    private let favoriteCuisineCollectionView = FavoriteCuisineCollectionView()
    private let favoriteSpotTypeCollectionView = FavoriteSpotTypeCollectionView()
    private let favoriteSpotStyleCollectionView = FavoriteSpotStyleCollectionView()
    private let favoriteSpotRankCollectionView = FavoriteSpotRankCollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBinding()
        updateContentView(for: currentStep)
    }
    
    override func setStyle() {
        super.setStyle()
        
        backButton.do {
            $0.setImage(UIImage(named: "chevron.left"), for: .normal)
            $0.tintColor = .acWhite
            $0.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        }
        
        skipButton.do {
            $0.addTarget(self, action: #selector(nextStack), for: .touchUpInside)
            $0.setAttributedTitle(text: "건너뛰기",
            style: ACFont.b2,
            color: .acWhite,
            for: .normal)
            
        }
        
        progressView.do {
            $0.backgroundColor = .lightGray
        }
        
        progressIndicator.do {
            $0.backgroundColor = .orange
        }
        
        progressNumber.do {
            $0.font = ACFont.h4.font
            $0.textColor = .gray5
        }
        
        progressTitle.do {
            $0.font = ACFont.h6.font
            $0.textColor = .acWhite
            $0.numberOfLines = 0
            $0.lineBreakMode = .byWordWrapping
            
        }
        
        nextButton.do {
            $0.backgroundColor = .gray8
            $0.layer.cornerRadius = 8
            $0.isEnabled = false
            $0.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
            $0.setAttributedTitle(text: "다음",
            style: ACFont.h8,
            color: .gray6,
            for: .normal)
        }
    }
    
    override func setHierarchy() {
        super.setHierarchy()

        view.addSubviews(backButton, skipButton, progressView, progressNumber, progressTitle, nextButton)
        progressView.addSubview(progressIndicator)
    }
    
    
    override func setLayout() {
        super.setLayout()
        
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.size.equalTo(ScreenUtils.width * 24 / 260)
        }
        
        skipButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-20)
            $0.centerY.equalTo(backButton.snp.centerY)
        }
        
        progressView.snp.makeConstraints {
            $0.top.equalTo(backButton.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(2)
        }
        
        progressIndicator.snp.makeConstraints {
            $0.leading.top.bottom.equalTo(progressView)
            $0.width.equalTo(0)
        }
        
        progressNumber.snp.makeConstraints {
            $0.top.equalTo(progressIndicator.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(20)
        }
        
        progressTitle.snp.makeConstraints {
            $0.top.equalTo(progressNumber.snp.bottom).offset(4)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-40)
            $0.height.equalTo(44)
        }
    }
}
    

extension OnboardingViewController {
    
    private func setBinding() {
        viewModel.dislike.bind { [weak self] dislikedFoods in
            self?.updateNextButtonState(isEnabled: !(dislikedFoods?.isEmpty ?? true))
        }
        
        viewModel.favoriteCuisne.bind { [weak self] cuisines in
            self?.updateNextButtonState(isEnabled: cuisines?.count == 3)
        }
        
        viewModel.favoriteSpotType.bind { [weak self] spotType in
            self?.updateNextButtonState(isEnabled: spotType != nil)
        }
        
        viewModel.favoriteSpotStyle.bind { [weak self] spotStyle in
            self?.updateNextButtonState(isEnabled: spotStyle != nil)
        }
        
        viewModel.favoriteSpotRank.bind { [weak self] ranks in
            self?.updateNextButtonState(isEnabled: ranks?.count == 4)
        }
    }
    
    private func updateContentView(for step: Int) {
        contentView?.removeFromSuperview()
        
        switch step {
        case 0:
            setDislikeCollectionView()
        case 1:
            setFavoriteCuisineCollectionView()
        case 2:
            setFavoriteSpotTypeCollectionView()
        case 3:
            setFavoriteSpotStyleCollectionView()
        case 4:
            setFavoriteSpotRankCollectionView()
        default:
            contentView = nil
        }
        
        if let contentView = contentView {
            view.addSubview(contentView)
            contentView.snp.makeConstraints {
                $0.top.equalTo(progressTitle.snp.bottom).offset(10)
                $0.leading.trailing.equalToSuperview()
                $0.bottom.equalTo(nextButton.snp.top)
            }
        }
        progressNumber.text = OnboardingType.progressNumberList[step]
        progressTitle.text = OnboardingType.progressTitleList[step]
    }
    
    private func setDislikeCollectionView() {
        contentView = dislikeCollectionView
        dislikeCollectionView.onSelectionChanged = { [weak self] selectedIndices in
            guard let self = self else { return }
            
            if selectedIndices.map({ $0.uppercased() }) == ["NONE"] {
                self.isOverlayVisible.toggle()
                if self.isOverlayVisible {
                    self.showOverlay()
                } else {
                    self.hideOverlay()
                }
            } else {
                self.hideOverlay()
                self.isOverlayVisible = false
            }
            self.viewModel.dislike.value = selectedIndices
        }
    }
    
    private func setFavoriteCuisineCollectionView() {
        contentView = favoriteCuisineCollectionView
        favoriteCuisineCollectionView.onSelectionChanged = { [weak self] selectedIndices in
            self?.viewModel.favoriteCuisne.value = selectedIndices
        }
    }
    
    private func setFavoriteSpotTypeCollectionView() {
        contentView = favoriteSpotTypeCollectionView
        favoriteSpotTypeCollectionView.onSelectionChanged = { [weak self] selectedType in
            self?.viewModel.favoriteSpotType.value = selectedType
        }
    }
    
    private func setFavoriteSpotStyleCollectionView() {
        contentView = favoriteSpotStyleCollectionView
        favoriteSpotStyleCollectionView.onSelectionChanged = { [weak self] selectedStyle in
            self?.viewModel.favoriteSpotStyle.value = selectedStyle
        }
    }
    
    private func setFavoriteSpotRankCollectionView() {
        contentView = favoriteSpotRankCollectionView
        favoriteSpotRankCollectionView.onSelectionChanged = { [weak self] selectedIndices in
            self?.viewModel.favoriteSpotRank.value = selectedIndices
        }
    }
    
}


extension OnboardingViewController {
    
    private func updateNextButtonState(isEnabled: Bool) {
        nextButton.isEnabled = isEnabled
        nextButton.backgroundColor = isEnabled ? .gray5 : .gray8
        nextButton.setTitleColor(isEnabled ? .acWhite : .gray6, for: .normal)
    }
    
    private func showOverlay() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.contentView?.alpha = 0.5
        }
    }
    
    private func hideOverlay() {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.contentView?.alpha = 1.0
            
        }) { [weak self] _ in
            self?.contentView?.alpha = 1.0

        }
    }
    
    private func updateProgressIndicator() {
        let totalSteps: Float = Float(OnboardingType.progressNumberList.count)
        let progressViewWidth = Float(progressView.frame.width) / totalSteps
        let progressWidth = progressViewWidth * Float(currentStep + 1)
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.progressIndicator.snp.updateConstraints {
                $0.width.equalTo(progressWidth)
            }
            self?.view.layoutIfNeeded()
        }
    }
    
}


extension OnboardingViewController {
    
    @objc private func nextButtonTapped() {
        if currentStep >= OnboardingType.progressNumberList.count - 1 {
            
            let analyzingVC = AnalyzingViewController()
            analyzingVC.modalPresentationStyle = .fullScreen
            present(analyzingVC, animated: true, completion: nil)
            return
        }
        
        if isOverlayVisible {
            hideOverlay()
            isOverlayVisible = false
        }
        
        currentStep += 1
        updateContentView(for: currentStep)
        updateNextButtonState(isEnabled: false)
        updateProgressIndicator()
    }
    
    @objc private func backButtonTapped() {
        guard currentStep > 0 else { return }
        currentStep -= 1
        updateContentView(for: currentStep)
        updateNextButtonState(isEnabled: true)
        updateProgressIndicator()
    }
    
    @objc private func nextStack(){
        // MARK: TODO -> Popup alert
        print("alert")
    }
    
}

// MARK: 삭제 예정
struct FoodSelectionViewControllerPreview: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> OnboardingViewController {
        OnboardingViewController()
    }
    
    func updateUIViewController(_ uiViewController: OnboardingViewController, context: Context) {}
}

struct FoodSelectionViewControllerPreview_Previews: PreviewProvider {
    
    static var previews: some View {
        FoodSelectionViewControllerPreview()
            .edgesIgnoringSafeArea(.all)
            .previewLayout(.sizeThatFits)
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
}
