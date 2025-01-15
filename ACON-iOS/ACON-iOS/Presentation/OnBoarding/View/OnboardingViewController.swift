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

final class OnboardingViewController: UIViewController {
    
    let viewModel = OnboardingViewModel()
    
    private let backButton = UIButton()
    private let skipButton = UIButton()
    private let progressView = UIView()
    private let progressIndicator = UIView()
    private let nextButton = UIButton()
    private let progressNumber = UILabel()
    private let progressTitle = UILabel()
    private let overlayView: UIView = UIView()
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
        view.backgroundColor = .gray9
        setStyle()
        setHierarchy()
        setLayout()
        setBinding()
        updateContentView(for: currentStep)
    }
    
    private func setStyle() {
        
        overlayView.do {
            $0.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            $0.isHidden = true
        }
        
        backButton.do {
            $0.setImage(UIImage(systemName: "chevron.left"), for: .normal)
            $0.tintColor = .acWhite
            $0.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        }
        
        skipButton.do {
            $0.setTitle("건너뛰기", for: .normal)
            $0.setTitleColor(.acWhite, for: .normal)
            $0.titleLabel?.font = ACFont.b2.font
            $0.addTarget(self, action: #selector(nextStack), for: .touchUpInside)
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
            $0.setTitle("다음", for: .normal)
            $0.setTitleColor(.gray6, for: .normal)
            $0.titleLabel?.font = ACFont.h8.font
            $0.layer.cornerRadius = 8
            $0.isEnabled = false
            $0.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        }
    }
    
    private func setHierarchy() {
        
        view.addSubviews(backButton, skipButton, progressView, progressNumber, progressTitle, overlayView, nextButton)
        progressView.addSubview(progressIndicator)
    }
    
    
    private func setLayout() {
        
        overlayView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.size.equalTo(CGSize(width: 24, height: 24))
        }
        
        skipButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-20)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
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
    
    private func updateNextButtonState(isEnabled: Bool) {
        nextButton.isEnabled = isEnabled
        nextButton.backgroundColor = isEnabled ? .gray5 : .gray8
        nextButton.setTitleColor(isEnabled ? .acWhite : .gray6, for: .normal)
        
    }
    
    private func setBinding() {
        
        viewModel.dislike.bind { [weak self] dislikedFoods in
            print("Disliked Foods: \(dislikedFoods ?? [])")
            self?.updateNextButtonState(isEnabled: !(dislikedFoods?.isEmpty ?? true))
        }
        
        viewModel.favoriteCuisne.bind { [weak self] cuisines in
            print("Favorite Cuisines: \(cuisines ?? [])")
            self?.updateNextButtonState(isEnabled: cuisines?.count == 3)
        }
        
        viewModel.favoriteSpotType.bind { [weak self] spotType in
            print("Favorite Spot Type: \(spotType ?? "None")")
            self?.updateNextButtonState(isEnabled: spotType != nil)
        }
        
        viewModel.favoriteSpotStyle.bind { [weak self] spotStyle in
            print("Favorite Spot Style: \(spotStyle ?? "None")")
            self?.updateNextButtonState(isEnabled: spotStyle != nil)
        }
        
        viewModel.favoriteSpotRank.bind { [weak self] ranks in
            print("Favorite Spot Rank: \(ranks ?? [])")
            self?.updateNextButtonState(isEnabled: ranks?.count == 4)
        }
    }
    
    private func updateContentView(for step: Int) {
        contentView?.removeFromSuperview()
        
        switch step {
        case 0:
            setupDislikeCollectionView()
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
                $0.top.equalTo(progressTitle.snp.bottom).offset(16)
                $0.leading.trailing.equalToSuperview()
                $0.bottom.equalTo(nextButton.snp.top).offset(-16)
            }
        }
        progressNumber.text = OnboardingType.progressNumberList[step]
        progressTitle.text = OnboardingType.progressTitleList[step]
    }
    
    private func setupDislikeCollectionView() {
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
    
    
    @objc private func nextButtonTapped() {
        if currentStep >= OnboardingType.progressNumberList.count - 1 {
            
            // 확인용
            print("Disliked Foods: \(String(describing: viewModel.dislike.value))")
            print("Favorite Cuisines: \(String(describing: viewModel.favoriteCuisne.value))")
            print("Favorite Spot Type: \(viewModel.favoriteSpotType.value ?? "None")")
            print("Favorite Spot Style: \(viewModel.favoriteSpotStyle.value ?? "None")")
            print("Favorite Spot Rank: \(String(describing: viewModel.favoriteSpotRank.value))")
            
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
        // MARK : TODO -> Popup alert
        print("alert")
    }
    
    // 배경 어두워지는 로직 on
    private func showOverlay() {
        overlayView.isHidden = false
        overlayView.alpha = 0.0
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.overlayView.alpha = 1.0
            self.contentView?.alpha = 0.5
            
            self.view.bringSubviewToFront(self.progressNumber)
            self.view.bringSubviewToFront(self.progressTitle)
        }
    }
    
    // 배경 어두워지는 로직 off
    private func hideOverlay() {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.overlayView.alpha = 0.0
            self?.contentView?.alpha = 1.0
            
        }) { [weak self] _ in
            self?.overlayView.isHidden = true
            
        }
    }
    
    // 게이지 차는 로직
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


//
//
//enum Onboarding {
//
//
//    static let progressNumberList = ["01", "02", "03", "04", "05"]
//    
//    static let progressTitleList = [
//        "싫어하는 음식을 선택해 주세요",
//        "선호하는 음식을 Top3까지 순위를 매겨주세요",
//        "어디를 더 자주 가나요?",
//        "내가 좋아하는 맛집 스타일은?",
//        "내가 선호하는 공간의 순위는?"
//    ]
//    
//
//}
