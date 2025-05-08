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
    
    
    // MARK: - Properties
    
    let categories = ["새우", "게", "조개", "굴", "회", "생선", "해산물", "육회/육사시미", "선지", "순대", "곱창/대창/막창", "닭발", "닭똥집", "양고기", "돼지/소 특수부위", "채소"]
    
    let selectedFood: ObservablePattern<[String]> = ObservablePattern(nil)
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCell()
        setDelegate()
        addTarget()
        bindSelectedFood()
    }
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.view.addSubview(onboardingView)
    }
    
    override func setLayout() {
        super.setLayout()

        onboardingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func addTarget() {
        onboardingView.noDislikeFoodButton.addTarget(self,
                                                     action: #selector(noDislikeButtonTapped),
                                                     for: .touchUpInside)
        onboardingView.startButton.addTarget(self,
                                             action: #selector(startButtonTapped),
                                             for: .touchUpInside)
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
                    $0.startButton.updateGlassButtonState(state: .default)
                }

            } else {
                self.onboardingView.do {
                    $0.commentLabel.isHidden = true
                    $0.lightImageView.isHidden = true
                    $0.startButton.updateGlassButtonState(state: .disabled)
                }
            }
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
        return UIEdgeInsets(top: 0, left: ScreenUtils.widthRatio*16, bottom: 0, right: ScreenUtils.widthRatio*10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? DislikeFoodCollectionViewCell {
            cell.isSelected.toggle()
            /// 해산물 예외처리
            if cell.isSelected {
                if indexPath.item == 6 {
                    for i in 0..<6 {
                        let seafoodIndexPath = IndexPath(item: i, section: indexPath.section)
                        if let otherCell = collectionView.cellForItem(at: seafoodIndexPath) as? DislikeFoodCollectionViewCell, !otherCell.isSelected {
                            otherCell.isSelected = true
                            if ((selectedFood.value?.contains(categories[i])) == nil) {
                                selectedFood.value?.append(categories[i])
                            }
                        }
                    }
                }
                if ((selectedFood.value?.contains(categories[indexPath.item])) == nil) {
                    selectedFood.value?.append(categories[indexPath.item])
                }
            } else {
                if let index = selectedFood.value?.firstIndex(of: categories[indexPath.item]) {
                    selectedFood.value?.remove(at: index)
                }
            }
            
            print(selectedFood.value)
        }
    }

}


// MARK: - CollectionView DataSource

extension OnboardingViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = categories[indexPath.item]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DislikeFoodCollectionViewCell.cellIdentifier, for: indexPath) as? DislikeFoodCollectionViewCell else {
            return UICollectionViewCell() }
        cell.bindData(data, indexPath.item)
        return cell
    }
    
}


// MARK: - @objc methods

extension OnboardingViewController {
    
    @objc
    func noDislikeButtonTapped() {
        if onboardingView.noDislikeFoodButton.buttonState == .selected {
            onboardingView.noDislikeFoodButton.updateGlassButtonState(state: .default)
            selectedFood.value = nil
            // TODO: 컬뷰 모든 버튼 able
            
        } else {
            onboardingView.noDislikeFoodButton.updateGlassButtonState(state: .selected)
            selectedFood.value = []
            // TODO: 컬뷰 모든 버튼 disable
        }
    }
    
    @objc
    func startButtonTapped() {
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController = ACTabBarController()
        }
    }
    
}
