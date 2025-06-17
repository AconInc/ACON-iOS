//
//  LocalVerificationEditViewController.swift
//  ACON-iOS
//
//  Created by 김유림 on 2/17/25.
//

import UIKit

class VerifiedAreasEditViewController: BaseNavViewController {
    
    // MARK: - UI Properties
    
    private let verifiedAreasEditView = VerifiedAreasEditView()
    
    private lazy var tappedAddVerifiedAreaGesture = UITapGestureRecognizer(target: self, action: #selector(tappedAddVerifiedArea))

    
    // MARK: - Properties
    
    private var viewModel = LocalVerificationViewModel(flowType: .setting)
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        registerCell()
        setDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)

        viewModel.getVerifiedAreaList()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.contentView.addSubview(verifiedAreasEditView)
    }
    
    override func setLayout() {
        super.setLayout()

        verifiedAreasEditView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func setStyle() {
        super.setStyle()

        self.setBackButton()
        self.setCenterTitleLabelStyle(title: StringLiterals.LocalVerification.locateOnMap)
    }
    
}

// MARK: - CollectionView Setting Methods

private extension VerifiedAreasEditViewController {
    
    func registerCell() {
        verifiedAreasEditView.verifiedAreaCollectionView.register(VerifiedAreasCollectionViewCell.self, forCellWithReuseIdentifier: VerifiedAreasCollectionViewCell.cellIdentifier)
    }
    
    func setDelegate() {
        verifiedAreasEditView.verifiedAreaCollectionView.delegate = self
        verifiedAreasEditView.verifiedAreaCollectionView.dataSource = self
    }
    
}


// MARK: - CollectionView Delegate

extension VerifiedAreasEditViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: ScreenUtils.horizontalInset, bottom: 0, right: ScreenUtils.horizontalInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if viewModel.verifiedAreaList.count != 3 &&
            indexPath.item == viewModel.verifiedAreaList.count { return true }
        else { return false }
    }

}


// MARK: - CollectionView DataSource

extension VerifiedAreasEditViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.verifiedAreaList.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VerifiedAreasCollectionViewCell.cellIdentifier, for: indexPath) as? VerifiedAreasCollectionViewCell else {
            return UICollectionViewCell() }
        
        if viewModel.verifiedAreaList.count != 3 &&
            indexPath.item == viewModel.verifiedAreaList.count {
            cell.setAddButton()
            cell.addGestureRecognizer(tappedAddVerifiedAreaGesture)
        } else {
            if !viewModel.verifiedAreaList.isEmpty {
                cell.bindData(viewModel.verifiedAreaList[indexPath.item].name, indexPath.item)
            }
            cell.deleteButton.tag = indexPath.item
            cell.deleteButton.addTarget(self, action: #selector(tappedAreaDeleteButton(_:)), for: .touchUpInside)
        }
        return cell
    }
    
}


// MARK: - Bindings

private extension VerifiedAreasEditViewController {
    
    func bindViewModel(){
        viewModel.onGetVerifiedAreaListSuccess.bind { [weak self] onSuccess in
            guard let self = self,
                  let onSuccess = onSuccess else { return }
            
            DispatchQueue.main.async {
                if onSuccess && !self.viewModel.verifiedAreaList.isEmpty {
                    self.verifiedAreasEditView.verifiedAreaCollectionView.reloadData()
                } else {
                    self.showServerErrorAlert()
                }
            }
        }
        
        viewModel.onDeleteVerifiedAreaSuccess.bind { [weak self] onSuccess in
            guard let self = self,
                  let onSuccess = onSuccess else { return }
            if onSuccess {
                viewModel.getVerifiedAreaList()
            } else {
                switch viewModel.deleteVerifiedAreaErrorType {
                case .unsupportedRegion:
                    self.presentACAlert(.locationAccessFail)
                case .timeOut:
                    self.presentACAlert(.timeoutFromVerification)
                default:
                    self.showServerErrorAlert()
                    viewModel.deleteVerifiedAreaErrorType = nil
                }
                viewModel.onDeleteVerifiedAreaSuccess.value = nil
            }
        }
    }
    
}


// MARK: - Delegate

extension VerifiedAreasEditViewController {
    
    @objc
    func tappedAreaDeleteButton(_ sender: UIButton) {
        // NOTE: 동네가 1개 남은 상황에서 삭제버튼 누른 경우 -> Alert -> 동네인증
        if viewModel.verifiedAreaList.count == 1 {
            let action: () -> Void = { [weak self] in
                guard let self = self else { return }
                viewModel.isSwitching = true
                let vc = LocalVerificationViewController(viewModel: self.viewModel)
                self.navigationController?.pushViewController(vc, animated: true)
            }
            self.presentACAlert(.changeVerifiedArea, rightAction: action)
        } else {
            let index = sender.tag
            let verifiedArea = viewModel.verifiedAreaList[index]
            viewModel.deleteVerifiedArea(verifiedArea)
        }
    }
    
}


// MARK: - @objc functions

private extension VerifiedAreasEditViewController {
    
    @objc
    func tappedAddVerifiedArea() {
        viewModel.isSwitching = false
        let vc = LocalVerificationViewController(viewModel: self.viewModel)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
