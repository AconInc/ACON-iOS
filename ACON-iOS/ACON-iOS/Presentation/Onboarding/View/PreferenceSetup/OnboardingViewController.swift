//
//  OnboardingViewController.swift
//  ACON-iOS
//
//  Created by 이수민 on 5/8/25.
//

import UIKit

class OnboardingViewController: BaseViewController {
    
    // MARK: - UI Properties
    
    private let onboardingView = OnboardingView()
    
    private let backButton = UIButton()
    
    private lazy var backCompletion: (() -> Void)? = {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - Properties
    
    private let onboardingViewModel = OnboardingViewModel()
    
    private let flowType: OnboardingFlowType
    
    let selectedFood: ObservablePattern<[String]> = ObservablePattern(nil)
    
    
    // MARK: - LifeCycle
    
    init(flowType: OnboardingFlowType) {
        self.flowType = flowType
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
       
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCell()
        setDelegate()
        addTarget()
        bindSelectedFood()
        bindViewModel()
    }
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.view.addSubviews(onboardingView, backButton)
    }
    
    override func setLayout() {
        super.setLayout()
        
        onboardingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        backButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(ScreenUtils.heightRatio*28 - 10)
            $0.leading.equalToSuperview().inset(ScreenUtils.horizontalInset)
        }
    }
    
    override func setStyle() {
        super.setStyle()
        
        backButton.do {
            $0.setImage(.icLeft, for: .normal)
            $0.clipsToBounds = true
            $0.isHidden = flowType == .login ? true : false
        }
    }
    
    private func addTarget() {
        onboardingView.noDislikeFoodButton.addTarget(self,
                                                     action: #selector(noDislikeButtonTapped),
                                                     for: .touchUpInside)
        onboardingView.startButton.addTarget(self,
                                             action: #selector(startButtonTapped),
                                             for: .touchUpInside)
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        addForegroundObserver(action: #selector(appWillEnterForeground))
    }
    
    private func bindSelectedFood() {
        selectedFood.bind { _ in
            if let selectedFoodValue = self.selectedFood.value {
                self.onboardingView.do {
                    let commentLabelText = selectedFoodValue.isEmpty ? StringLiterals.Onboarding.allFood : StringLiterals.Onboarding.notAllFood
                    $0.commentLabel.setLabel(text: commentLabelText,
                                            style: .t5R,
                                            color: .gray300)
                    $0.commentLabel.isHidden = false
                    $0.lightImageView.isHidden = false
                    if $0.startButton.buttonState != .default {
                        $0.startButton.updateGlassButtonState(state: .default)
                    }
                }
            } else {
                self.onboardingView.do {
                    $0.commentLabel.isHidden = true
                    $0.lightImageView.isHidden = true
                    if $0.startButton.buttonState != .disabled {
                        $0.startButton.updateGlassButtonState(state: .disabled)
                    }
                }
            }
        }
    }
    
}


// MARK: - Bind VM

private extension OnboardingViewController {
    
    func bindViewModel() {
        onboardingViewModel.onPutOnboardingSuccess.bind { [weak self] onSuccess in
            guard let self = self,
                  let onSuccess = onSuccess else { return }
            if onSuccess {
                if flowType == .login {
                    NavigationUtils.navigateToTabBar()
                } else {
                    NavigationUtils.popToParentVC(from: self, targetVCType: ProfileSettingViewController.self)
                }
            } else {
                self.showServerErrorAlert()
            }
            onboardingViewModel.onPutOnboardingSuccess.value = nil
        }
    }
    
}


// MARK: - CollectionView Setting Methods

private extension OnboardingViewController {
    
    func registerCell() {
        onboardingView.dislikeFoodCollectionView.register(DislikeFoodCollectionViewCell.self, forCellWithReuseIdentifier: DislikeFoodCollectionViewCell.cellIdentifier)
    }
    
    func setDelegate() {
        onboardingView.dislikeFoodCollectionView.delegate = self
        onboardingView.dislikeFoodCollectionView.dataSource = self
    }
    
}


// MARK: - CollectionView Delegate

extension OnboardingViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: ScreenUtils.horizontalInset, bottom: 0, right: ScreenUtils.widthRatio*10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? DislikeFoodCollectionViewCell {
            cell.isChipSelected.toggle()
            
            if cell.isChipSelected {
                /// 해산물 예외처리
                if selectedFood.value == nil || selectedFood.value == [] {
                    selectedFood.value = []
                    disableNoDislikeFoodButton()
                    enableAllCells(true)
                }
                if indexPath.item == 6 {
                    for i in 0..<6 {
                        let seafoodIndexPath = IndexPath(item: i, section: indexPath.section)
                        if let otherCell = collectionView.cellForItem(at: seafoodIndexPath) as? DislikeFoodCollectionViewCell, !otherCell.isChipSelected {
                            otherCell.isChipSelected = true
                            if !(selectedFood.value?.contains(DislikeFood.engValue[indexPath.item]) ?? false) {
                                selectedFood.value?.append(DislikeFood.engValue[i])
                            }
                        }
                    }
                }
                if !(selectedFood.value?.contains(DislikeFood.engValue[indexPath.item]) ?? false) {
                    selectedFood.value?.append(DislikeFood.engValue[indexPath.item])
                }
            } else {
                if let index = selectedFood.value?.firstIndex(of: DislikeFood.engValue[indexPath.item]) {
                    selectedFood.value?.remove(at: index)
                    if selectedFood.value == [] {
                        selectedFood.value = nil
                        onboardingView.noDislikeFoodButton.updateGlassButtonState(state: .default)
                        enableAllCells(true)
                    }
                }
            }
        }
    }

}


// MARK: - CollectionView DataSource

extension OnboardingViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DislikeFood.korValue.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = DislikeFood.korValue[indexPath.item]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DislikeFoodCollectionViewCell.cellIdentifier, for: indexPath) as? DislikeFoodCollectionViewCell else {
            return UICollectionViewCell() }
        cell.bindData(data, indexPath.item)
        return cell
    }
    
}


// MARK: - @objc methods

private extension OnboardingViewController {
    
    @objc
    func noDislikeButtonTapped() {
        if onboardingView.noDislikeFoodButton.buttonState == .selected {
            onboardingView.noDislikeFoodButton.updateGlassButtonState(state: .default)
            selectedFood.value = nil
            enableAllCells(true)
            
        } else {
            onboardingView.noDislikeFoodButton.updateGlassButtonState(state: .selected)
            selectedFood.value = []
            enableAllCells(false)
        }
    }
    
    @objc
    func startButtonTapped() {
        guard let dislikeFoodList = selectedFood.value else { return }
        onboardingViewModel.putOnboarding(dislikeFoodList)
    }
    
    @objc
    func backButtonTapped() {
        self.presentACAlert(.quitOnboarding,
                            rightAction: backCompletion)
    }
    
    @objc
    func appWillEnterForeground() {
        onboardingView.setNeedsLayout()
    }
}


// MARK: - 셀 전체 활성화 / 비활성화 로직

extension OnboardingViewController {
    
    private func enableAllCells(_ enable: Bool) {
        for cell in onboardingView.dislikeFoodCollectionView.visibleCells {
            if let cell = cell as? DislikeFoodCollectionViewCell {
                if !enable { cell.isChipSelected = false }
                cell.isChipEnabled = enable
            }
        }
    }
    
    private func disableNoDislikeFoodButton() {
        onboardingView.noDislikeFoodButton.do {
            $0.updateGlassButtonState(state: .default)
            $0.refreshButtonBlurEffect(.buttonGlassDisabled)
            $0.updateButtonTitle(color: .gray300)
        }
    }
    
}
