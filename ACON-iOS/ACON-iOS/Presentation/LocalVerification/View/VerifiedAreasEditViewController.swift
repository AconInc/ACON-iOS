//
//  LocalVerificationEditViewController.swift
//  ACON-iOS
//
//  Created by 김유림 on 2/17/25.
//

import UIKit

class VerifiedAreasEditViewController: BaseNavViewController {
    
    // MARK: - Properties (View, ViewModels)
    
    private let localVerificationEditView = VerifiedAreasEditView()
    
    private let viewModel = LocalVerificationEditViewModel()
    
    private let localVerificationVMAdding = LocalVerificationViewModel(flowType: .adding)
    
    private let localVerificationVMChanging = LocalVerificationViewModel(flowType: .changing)
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTarget()
        setDelegate()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)

        self.tabBarController?.tabBar.isHidden = true
        viewModel.getVerifiedAreaList()
        
    }
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.contentView.addSubview(localVerificationEditView)
    }
    
    override func setLayout() {
        super.setLayout()

        localVerificationEditView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func setStyle() {
        super.setStyle()

        self.setBackButton()
        self.setSecondTitleLabelStyle(title: StringLiterals.LocalVerification.locateOnMap)
    }
    
    private func addTarget() {
        
    }
    
    private func setDelegate() {
        localVerificationEditView.delegate = self
    }
    
}


// MARK: - Bindings

private extension VerifiedAreasEditViewController {
    
    func bindViewModel(){
        
        viewModel.onGetVerifiedAreaListSuccess.bind { [weak self] onSuccess in
            guard let self = self,
                  let onSuccess = onSuccess else { return }
            
            if onSuccess && viewModel.isAppendingVerifiedAreaList == false {
                viewModel.isAppendingVerifiedAreaList = true
                 
                for area in viewModel.verifiedAreaList {
                    localVerificationEditView.addVerifiedArea(area)
                }
                
                viewModel.isAppendingVerifiedAreaList = false
            }
            
        }
        
        viewModel.onDeleteVerifiedAreaSuccess.bind { [weak self] onSuccess in
            guard let self = self,
                  let onSuccess = onSuccess else { return }
            
            if onSuccess,
               let area = viewModel.deletingVerifiedArea {
                localVerificationEditView.removeVerifiedArea(verifiedArea: area)
            } else if let error = viewModel.deleteVerifiedAreaErrorCode {
                presentDeleteErrorAlert(message: error.errorMessage)
            }
        }
        
        localVerificationVMAdding.onSuccessPostLocalArea.bind { [weak self] onSuccess in
            guard let self = self,
                  let onSuccess = onSuccess else { return }
            
//            var newAreas = viewModel.verifiedAreaListEditing.value ?? []
//            // TODO: VerifiedArea id 수정
//            newAreas.append(VerifiedAreaModel(id: 1, name: area))
//            viewModel.verifiedAreaListEditing.value = newAreas
        }
        
        localVerificationVMChanging.onSuccessPostLocalArea.bind { [weak self] onSuccess in
            guard let self = self,
                  let onSuccess = onSuccess else { return }
            if onSuccess,
                let verifiedArea = localVerificationVMChanging.verifiedArea {
                viewModel.verifiedAreaList.append(verifiedArea)
                
                // TODO: DELETE Area
            }
        }
    }
    
}


// MARK: - Delegate

extension VerifiedAreasEditViewController: LocalVerificationEditViewDelegate {
    
    func didTapAreaDeleteButton(_ verifiedArea: VerifiedAreaModel) {
//        let onSuccessDeleting = viewModel.postDeleteVerifiedArea(area: verifiedArea)
        if viewModel.verifiedAreaList.count == 1 {
            AlertHandler.shared.showWillYouChangeVerifiedAreaAlert(from: self) { [weak self] in
                guard let self = self else { return }
                // TODO: 1. push 동네인증 VC
                let vc = LocalVerificationViewController(viewModel: localVerificationVMChanging)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        viewModel.postDeleteVerifiedArea(verifiedArea)
    }
    
    // TODO: 삭제 (임시 코드임)
    private func presentDeleteErrorAlert(message: String) {
        let alert = UIAlertController(title: "삭제 실패", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        self.present(alert, animated: true)
    }
    
}
