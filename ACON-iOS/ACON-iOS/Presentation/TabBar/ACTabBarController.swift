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
        
        configureTabBarAppearance()
        setNavViewControllers()
    }
    
}


// MARK: - TabBar Setting Methods

extension ACTabBarController {
    
    private func configureTabBarAppearance() {
        let appearance = UITabBarAppearance()
        
        appearance.do {
            $0.backgroundColor = .glaB30
            $0.stackedLayoutAppearance.normal.iconColor = .acWhite
            $0.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.acWhite]
            $0.stackedLayoutAppearance.selected.iconColor = .acWhite
            $0.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.acWhite]
        }
        
        tabBar.frame.size.height = ScreenUtils.height * 76/780
        tabBar.scrollEdgeAppearance = appearance
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
        
        let tabBarTitleAttributes: [NSAttributedString.Key : Any] = title.ACStyle(.b4)
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
