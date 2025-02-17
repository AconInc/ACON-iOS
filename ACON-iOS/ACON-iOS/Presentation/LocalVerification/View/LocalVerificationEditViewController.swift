//
//  LocalVerificationEditViewController.swift
//  ACON-iOS
//
//  Created by 김유림 on 2/17/25.
//

import UIKit

class LocalVerificationEditViewController: BaseNavViewController {
    
    // MARK: - Properties (View, ViewModels)
    
    private let localVerificationEditView = LocalVerificationEditView()
    
    private let viewModel = LocalVerificationEditViewModel()
    
    private let localVerificationVM = LocalVerificationViewModel(flowType: .profileEdit)
    
    
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

private extension LocalVerificationEditViewController {
    
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
        
        localVerificationVM.localAreaName.bind { [weak self] area in
            guard let self = self,
                  let area = area else { return }
            
//            var newAreas = viewModel.verifiedAreaListEditing.value ?? []
//            // TODO: VerifiedArea id 수정
//            newAreas.append(VerifiedAreaModel(id: 1, name: area))
//            viewModel.verifiedAreaListEditing.value = newAreas
        }
    }
    
}


// MARK: - Delegate

extension LocalVerificationEditViewController: LocalVerificationEditViewDelegate {
    
    func didTapAreaDeleteButton(_ verifiedArea: VerifiedAreaModel) {
//        let onSuccessDeleting = viewModel.postDeleteVerifiedArea(area: verifiedArea)
        
        viewModel.postDeleteVerifiedArea(verifiedArea) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                self.localVerificationEditView.removeVerifiedArea(verifiedArea: verifiedArea)
            case .failure(let error):
                self.presentDeleteErrorAlert(message: error.localizedDescription)
            }
        }
    }
    
    // TODO: 삭제 (임시 코드임)
    private func presentDeleteErrorAlert(message: String) {
        let alert = UIAlertController(title: "삭제 실패", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        self.present(alert, animated: true)
    }
    
}
