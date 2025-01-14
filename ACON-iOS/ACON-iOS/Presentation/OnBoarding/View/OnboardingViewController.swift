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

let customBlueColor = UIColor(red: 172/255.0, green: 203/255.0, blue: 255/255.0, alpha: 1.0)
let customBackgroundColor = UIColor(red: 247/255.0, green: 247/255.0, blue: 251/255.0, alpha: 1.0)
let BgColor = UIColor(red: 26/255.0, green: 27/255.0, blue: 29/255.0, alpha: 1.0)

final class OnboardingViewController: UIViewController {
    
    let viewModel = OnboardingViewModel()
    
    private let navigationBar = UIView()
    private let backButton = UIButton()
    private let skipButton = UIButton()
    private let progressView = UIView()
    private let progressIndicator = UIView()
    private let nextButton = UIButton()
    private let progressNumber = UILabel()
    private let progressTitle = UILabel()
    
    private let progressNumberList = ["01", "02", "03", "04", "05"]
    private let progressTitleList = [
        "싫어하는 음식을 선택해 주세요",
        "선호하는 음식을 Top3까지 순위를 매겨주세요",
        "어디를 더 자주 가나요?",
        "내가 좋아하는 맛집 스타일은?",
        "내가 선호하는 공간의 순위는?"
    ]
    
    private var contentView: UIView?
    private let dislikeCollectionView = DislikeCollectionView()
    private let favoriteCuisineCollectionView = FavoriteCuisineCollectionView()
    private let favoriteSpotTypeCollectionView = FavoriteSpotTypeCollectionView()
    private let favoriteSpotStyleCollectionView = FavoriteSpotStyleCollectionView()
    private let favoriteSpotRankCollectionView = FavoriteSpotRankCollectionView()
    
    var currentStep = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = BgColor
        setStyle()
        setHierarchy()
        setLayout()
        setBinding()
        updateContentView(for: currentStep)
    }
    
    private func setStyle() {
        navigationBar.do {
            $0.backgroundColor = .white
        }
        
        backButton.do {
            $0.setImage(UIImage(systemName: "chevron.left"), for: .normal)
            $0.tintColor = .black
            $0.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        }
        
        skipButton.do {
            $0.setTitle("건너뛰기", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        }
        
        progressView.do {
            $0.backgroundColor = .lightGray
        }
        
        progressIndicator.do {
            $0.backgroundColor = .orange
        }
        
        progressNumber.do {
            $0.font = UIFont.systemFont(ofSize: 30, weight: .bold)
            $0.textColor = .gray
        }
        
        progressTitle.do {
            $0.font = UIFont.systemFont(ofSize: 30, weight: .bold)
            $0.textColor = .black
            $0.numberOfLines = 0
            $0.lineBreakMode = .byWordWrapping
        }
        
        nextButton.do {
            $0.setTitle("다음", for: .normal)
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
            $0.backgroundColor = .lightGray
            $0.layer.cornerRadius = 8
            $0.isEnabled = false
            $0.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        }
    }
    
    private func setHierarchy() {
        view.addSubview(navigationBar)
        navigationBar.addSubview(backButton)
        navigationBar.addSubview(skipButton)
        view.addSubview(progressView)
        progressView.addSubview(progressIndicator)
        view.addSubview(progressNumber)
        view.addSubview(progressTitle)
        view.addSubview(nextButton)
    }
    
    private func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(56)
        }
        
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(CGSize(width: 24, height: 24))
        }
        
        skipButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
        }
        
        progressView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(9)
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
    
    private func updateNextButtonState(isEnabled: Bool) {
        nextButton.isEnabled = isEnabled
        nextButton.backgroundColor = isEnabled ? .orange : .lightGray
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
            setupFavoriteCuisineCollectionView()
        case 2:
            setupFavoriteSpotTypeCollectionView()
        case 3:
            setupFavoriteSpotStyleCollectionView()
        case 4:
            setupFavoriteSpotRankCollectionView()
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
        
        progressNumber.text = progressNumberList[step]
        progressTitle.text = progressTitleList[step]
    }
    
    private func setupDislikeCollectionView() {
        contentView = dislikeCollectionView
        dislikeCollectionView.onSelectionChanged = { [weak self] selectedIndices in
            self?.viewModel.dislike.value = selectedIndices
        }
    }

    
    private func setupFavoriteCuisineCollectionView() {
        contentView = favoriteCuisineCollectionView
        favoriteCuisineCollectionView.onSelectionChanged = { [weak self] selectedIndices in
            self?.viewModel.favoriteCuisne.value = selectedIndices
        }
    }

    
    private func setupFavoriteSpotTypeCollectionView() {
        contentView = favoriteSpotTypeCollectionView
        favoriteSpotTypeCollectionView.onSelectionChanged = { [weak self] selectedType in
            self?.viewModel.favoriteSpotType.value = selectedType
        }
    }

    
    private func setupFavoriteSpotStyleCollectionView() {
        contentView = favoriteSpotStyleCollectionView
        favoriteSpotStyleCollectionView.onSelectionChanged = { [weak self] selectedStyle in
            self?.viewModel.favoriteSpotStyle.value = selectedStyle
        }
    }

    
    private func setupFavoriteSpotRankCollectionView() {
        contentView = favoriteSpotRankCollectionView
        favoriteSpotRankCollectionView.onSelectionChanged = { [weak self] selectedIndices in
            self?.viewModel.favoriteSpotRank.value = selectedIndices
        }
    }

    
    @objc private func nextButtonTapped() {
        guard currentStep < progressNumberList.count - 1 else { return }
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
    
    private func updateProgressIndicator() {
        let totalSteps: Float = Float(progressNumberList.count)
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
