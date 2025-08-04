//
//  TabBarController.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/11/25.
//

import UIKit

import Then

class ACTabBarController: UITabBarController {
    
    // MARK: - Properties
    
    private var glassView: GlassmorphismView?
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        configureTabBarAppearance()
        setNavViewControllers()
        addNotification()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}


// MARK: - TabBar Setting Methods

private extension ACTabBarController {
    
    func configureTabBarAppearance() {
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

        let glassView = GlassmorphismView(.gradientGlass)
        self.glassView = glassView
        
        tabBar.addSubview(glassView)
        glassView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(tabBar)
            $0.height.equalTo(21 + ScreenUtils.heightRatio * 76)
        }
        
        self.view.layoutIfNeeded()
        glassView.setGradient(topColor: .gray900.withAlphaComponent(0.1), bottomColor: .gray900.withAlphaComponent(1))
    }
    
    func setNavViewControllers() {
        let navVCs = ACTabBarItemType.allCases.map {
            return setUpTabBarItem(title: $0.itemTitle,
                                   normalItemImage: $0.normalItemImage,
                                   selectedItemImage: $0.selectedItemImage,
                                   viewController: $0.viewController)
        }
        
        setViewControllers(navVCs, animated: false)
    }
    
    func setUpTabBarItem(title: String,
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

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let viewControllers = viewControllers,
              let index = viewControllers.firstIndex(of: viewController),
              index == ACTabBarItemType.allCases.firstIndex(of: .spotList),
              let nav = viewController as? UINavigationController,
              let spotListVC = nav.viewControllers.first as? SpotListViewController else {
            return
        }

        spotListVC.goToTop()
    }

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let viewControllers = viewControllers else { return true }
        guard let index = viewControllers.firstIndex(of: viewController) else { return true }
        if index == ACTabBarItemType.allCases.firstIndex(of: .upload) {
            // TODO: - 리젝 사유 : 다른 탭에서 모달 뜸
            guard AuthManager.shared.hasToken else {
                presentLoginModal("click_upload_guest?")
                return false
            }
            let uploadVC = SpotSearchViewController()
            let navController = UINavigationController(rootViewController: uploadVC)
            navController.modalPresentationStyle = .fullScreen
            present(navController, animated: true)
            
            return false
        }
        return true
    }

}


// MARK: - 글모 재렌더링

private extension ACTabBarController {
    
    func addNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appWillEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }
    
    @objc
    func appWillEnterForeground() {
        glassView?.refreshBlurEffect()
    }
    
}
