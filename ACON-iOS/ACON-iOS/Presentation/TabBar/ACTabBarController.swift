//
//  TabBarController.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/11/25.
//

import UIKit

import Then

class ACTabBarController: UITabBarController {
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        configureTabBarAppearance()
        setNavViewControllers()
    }
    
}


// MARK: - TabBar Setting Methods

extension ACTabBarController {
    
    private func configureTabBarAppearance() {
        let appearance = UITabBarAppearance()
        
        appearance.do {
            $0.configureWithOpaqueBackground()
            $0.backgroundColor = .clear
            
            $0.stackedLayoutAppearance.normal.iconColor = .acWhite
            $0.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.acWhite]
            $0.stackedLayoutAppearance.selected.iconColor = .acWhite
            $0.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.acWhite]
        }
        
        tabBar.frame.size.height = ScreenUtils.heightRatio * 76
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        
        // 🍇 TODO: 글모 Type 확인
        let glassView = GlassmorphismView(.bottomSheetGlass)
        tabBar.addSubview(glassView)
        glassView.snp.makeConstraints {
            $0.edges.equalTo(tabBar)
        }
    }
    
    private func setNavViewControllers() {
        let navVCs = ACTabBarItemType.allCases.map {
            return setUpTabBarItem(title: $0.itemTitle,
                                   normalItemImage: $0.normalItemImage,
                                   selectedItemImage: $0.selectedItemImage,
                                   viewController: $0.viewController)
        }
        
        setViewControllers(navVCs, animated: false)
    }
    
    private func setUpTabBarItem(title: String,
                                 normalItemImage: UIImage,
                                 selectedItemImage: UIImage,
                                 viewController: UIViewController)
    -> UIViewController {
        
        let navViewController = UINavigationController(
            rootViewController: viewController
        )
        
        let tabBarTitleAttributes: [NSAttributedString.Key : Any] = title.attributedString(.c1SB, .gray50)
            .attributes(
                at: 0,
                effectiveRange: nil
            )
        
        navViewController.tabBarItem = UITabBarItem(
            title: title,
            image: normalItemImage,
            selectedImage: selectedItemImage
        ).then {
            $0.setTitleTextAttributes(tabBarTitleAttributes, for: .normal)
            $0.setTitleTextAttributes(tabBarTitleAttributes, for: .selected)
        }
        
        return navViewController
    }
    
}


// MARK: - UITabBarControllerDelegate

extension ACTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let viewControllers = viewControllers else { return true }
        guard let index = viewControllers.firstIndex(of: viewController) else { return true }
        AmplitudeManager.shared.trackEventWithProperties(AmplitudeLiterals.EventName.placeUpload, properties: ["click_upload?": true])
        if index == ACTabBarItemType.allCases.firstIndex(of: .upload) {
            // TODO: - 리젝 사유 : 다른 탭에서 모달 뜸
            guard AuthManager.shared.hasToken else {
                presentLoginModal(AmplitudeLiterals.EventName.placeUpload)
                return false
            }
            let uploadVC = SpotSearchViewController()
            uploadVC.modalPresentationStyle = .fullScreen
            present(uploadVC, animated: true)
            return false
        }
        return true
    }
    
}
