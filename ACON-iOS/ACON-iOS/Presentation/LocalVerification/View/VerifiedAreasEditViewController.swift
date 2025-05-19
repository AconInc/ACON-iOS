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
            } else {
                self.showDefaultAlert(title: "인증 동네 로드 실패", message: "인증 동네 로드에 실패했습니다.")
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
            } else {
                self.showDefaultAlert(title: "인증 동네 삭제 실패", message: "인증 동네 삭제에 실패했습니다.")
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
    }
    
}


// MARK: - Delegate

extension VerifiedAreasEditViewController: VerifiedAreasEditViewDelegate {
    
    func didTapAreaDeleteButton(_ verifiedArea: VerifiedAreaModel) {
        // NOTE: 동네가 1개 남은 상황에서 삭제버튼 누른 경우 -> Alert -> 동네인증
        if viewModel.verifiedAreaList.count == 1 {
            let action: () -> Void = { [weak self] in
                guard let self = self else { return }
                let vc = LocalVerificationViewController(viewModel: self.localVerificationVMSwitching)
                self.navigationController?.pushViewController(vc, animated: true)
            }
            self.presentCustomAlert(.changeVerifiedArea, rightAction: action)
        }
        // TODO: 동네 인증 후 일주일 지나면 삭제 못한다는 알럿 기획과 논의중
        else {
            viewModel.postDeleteVerifiedArea(verifiedArea)
        }
    }
    
}


// MARK: - @objc functions

private extension VerifiedAreasEditViewController {
    
    @objc
    func tappedVerifiedAreaAddButton() {
        let vc = LocalVerificationViewController(viewModel: localVerificationVMAdding)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
