//
//  LocalVerificationEditViewController.swift
//  ACON-iOS
//
//  Created by 김유림 on 2/17/25.
//

import UIKit

class LocalVerificationEditViewController: BaseNavViewController {
    
    // MARK: - UI Properties
    
    private let localVerificationEditView = LocalVerificationEditView()
    
    private let localVerificationVM = LocalVerificationViewModel(flowType: .profileEdit)
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTarget()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)

        self.tabBarController?.tabBar.isHidden = true
        
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
    
    func addTarget() {
        
    }
}


// MARK: - Bindings

private extension LocalVerificationEditViewController {
    
    func bindViewModel(){
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
