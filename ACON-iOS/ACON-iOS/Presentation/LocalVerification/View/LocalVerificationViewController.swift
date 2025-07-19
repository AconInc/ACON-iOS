//
//  LocalVerificationViewController.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/15/25.
//

import UIKit

class LocalVerificationViewController: BaseNavViewController {
    
    // MARK: - UI Properties
    
    private let localVerificationView = LocalVerificationView()
    
    private let localVerificationViewModel: LocalVerificationViewModel
    
    
    // MARK: - LifeCycle
    
    init(viewModel: LocalVerificationViewModel) {
        self.localVerificationViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTarget()
        bindViewModel()
        self.setSkipButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)

        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.contentView.addSubview(localVerificationView)
    }
    
    override func setLayout() {
        super.setLayout()

        localVerificationView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func addTarget() {
        localVerificationView.nextButton.addTarget(self,
                                  action: #selector(nextButtonTapped),
                                  for: .touchUpInside)
    }

}


// MARK: - bindViewModel

private extension LocalVerificationViewController {
    
    func bindViewModel() {
        localVerificationViewModel.isLocationChecked.bind { [weak self] isChecked in
            guard let self = self,
                  let isChecked else { return }
            if isChecked {
                if localVerificationViewModel.isLocationKorea {
                    pushToLocalMapVC()
                } else {
                    self.showDefaultAlert(title: "알림", message: "현재 지역인증이 불가능한 지역에 있어요", okText: "홈으로 이동", completion: {
                        NavigationUtils.navigateToTabBar()})
                }
            } else {
                self.showDefaultAlert(title: "위치 확인 실패", message: "위치를 확인할 수 없습니다.")
            }
            localVerificationViewModel.isLocationChecked.value = nil
        }
    }
    
}
    
    
// MARK: - @objc functions

private extension LocalVerificationViewController {
    
    @objc
    func nextButtonTapped() {
        localVerificationViewModel.checkLocation()
    }
    
}


// MARK: - Navigation Logic

extension LocalVerificationViewController {

    func pushToLocalMapVC() {
        let vc = LocalMapViewController(viewModel: localVerificationViewModel)
        navigationController?.pushViewController(vc, animated: false)
    }
    
}
