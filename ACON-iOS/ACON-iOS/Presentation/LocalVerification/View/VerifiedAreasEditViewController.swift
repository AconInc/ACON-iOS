//
//  LocalVerificationEditViewController.swift
//  ACON-iOS
//
//  Created by 김유림 on 2/17/25.
//

import UIKit

class VerifiedAreasEditViewController: BaseNavViewController {
    
    // MARK: - Properties (View, ViewModels)
    
    private let verifiedAreasEditView = VerifiedAreasEditView()
    
    private let viewModel = LocalVerificationEditViewModel()
    
    private var localVerificationVMAdding = LocalVerificationViewModel(flowType: .adding)
    
    private var localVerificationVMSwitching = LocalVerificationViewModel(flowType: .switching)
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTarget()
        setDelegate()
        bindViewModel()
        viewModel.getVerifiedAreaList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)

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
        self.setSecondTitleLabelStyle(title: StringLiterals.LocalVerification.locateOnMap)
    }
    
    private func addTarget() {
        verifiedAreasEditView.verifiedAreaAddButton.addTarget(
            self,
            action: #selector(tappedVerifiedAreaAddButton),
            for: .touchUpInside
        )
    }
    
    private func setDelegate() {
        verifiedAreasEditView.delegate = self
    }
    
}


// MARK: - Bindings

private extension VerifiedAreasEditViewController {
    
    func bindViewModel(){
        viewModel.onGetVerifiedAreaListSuccess.bind { [weak self] onSuccess in
            guard let self = self,
                  let onSuccess = onSuccess else { return }
            
            print("🥑onGetVerifiedAreaListSuccess: \(onSuccess)")
            
            verifiedAreasEditView.removeAllVerifiedAreas()
            
            if onSuccess && viewModel.isAppendingVerifiedAreaList == false {
                viewModel.isAppendingVerifiedAreaList = true
                 
                for area in viewModel.verifiedAreaList {
                    verifiedAreasEditView.addVerifiedArea(area)
                }
                
                viewModel.isAppendingVerifiedAreaList = false
            }
            
        }
        
        viewModel.onDeleteVerifiedAreaSuccess.bind { [weak self] onSuccess in
            guard let self = self,
                  let onSuccess = onSuccess else { return }
            
            if onSuccess,
               let area = viewModel.deletingVerifiedArea,
               let index = viewModel.verifiedAreaList.firstIndex(of: area) {
                viewModel.verifiedAreaList.remove(at: index)
                verifiedAreasEditView.removeVerifiedArea(verifiedArea: area)
            }
        }
        
        
        // MARK: - 추가버튼 눌러서 성공한 경우
        
        localVerificationVMAdding.verifiedArea.bind { [weak self] area in
            guard let self = self,
                  let newVerifiedArea = area else { return }
            let isExistingArea = viewModel.verifiedAreaList.contains(newVerifiedArea)
            print("🥑isExistingArea: \(isExistingArea)")
            
            // NOTE: 새로 인증한 동네와 기존 동네가 동일할 경우 -> 추가 액션 없이 popVC
            
            // NOTE: 새로 인증한 동네와 기존 동네가 다른 경우 -> 새 동네 append
            if !isExistingArea {
                viewModel.verifiedAreaList.append(newVerifiedArea)
                verifiedAreasEditView.addVerifiedArea(newVerifiedArea)
            }
            
        }
        
        
        // MARK: - 1개 남은 동네를 바꾸는 경우
        localVerificationVMSwitching.verifiedArea.bind { [weak self] area in
            guard let self = self,
                  let newVerifiedArea = area else { return }
            let isExistingArea = viewModel.verifiedAreaList.contains(newVerifiedArea)
            
            // NOTE: 새로 인증한 동네와 기존 동네가 동일할 경우 -> 추가 액션 없이 popVC
            // NOTE: 새로 인증한 동네와 기존 동네가 다른 경우 -> 기존 동네 DELETE, 새 동네 append
            if !isExistingArea {
                viewModel.postDeleteVerifiedArea(viewModel.verifiedAreaList[0])
                viewModel.verifiedAreaList.append(newVerifiedArea)
                verifiedAreasEditView.addVerifiedArea(newVerifiedArea)
            }
        }
        
        // NOTE: 새 동네 인증에 실패한 경우
        // NOTE: 네트워크 에러 등 알럿 띄워야할 것 같음
    }
    
}


// MARK: - Delegate

extension VerifiedAreasEditViewController: VerifiedAreasEditViewDelegate {
    
    func didTapAreaDeleteButton(_ verifiedArea: VerifiedAreaModel) {
        print("🥑before delete verifiedAreaList: \(viewModel.verifiedAreaList)")
        
        // NOTE: 동네가 1개 남은 상황에서 삭제버튼 누른 경우 -> Alert -> 동네인증
        if viewModel.verifiedAreaList.count == 1 {
            AlertHandler.shared.showWillYouChangeVerifiedAreaAlert(from: self) { [weak self] in
                guard let self = self else { return }
//                localVerificationVMSwitching = LocalVerificationViewModel(flowType: .switching) // NOTE: 뷰모델 초기화
                let vc = LocalVerificationViewController(viewModel: localVerificationVMSwitching)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        // NOTE: 동네가 여러개 남은 상황에서 삭제버튼 누른 경우 -> Alert -> 삭제
        else {
            AlertHandler.shared.showWillYouDeleteVerifiedAreaAlert(
                from: self,
                areaName: verifiedArea.name) { [weak self] in
                guard let self = self else { return }
                    
                viewModel.postDeleteVerifiedArea(verifiedArea)
            }
        }
    }
    
}


// MARK: - @objc functions

private extension VerifiedAreasEditViewController {
    
    @objc
    func tappedVerifiedAreaAddButton() {
        localVerificationVMAdding = LocalVerificationViewModel(flowType: .adding) // NOTE: 뷰모델 초기화
        let vc = LocalVerificationViewController(viewModel: localVerificationVMAdding)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
