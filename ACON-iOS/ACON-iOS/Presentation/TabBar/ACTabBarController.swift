//
//  TabBarController.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/11/25.
//

import UIKit

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
        appearance.backgroundColor = .glaB30
        appearance.stackedLayoutAppearance.normal.iconColor = .acBlack
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.acBlack]
        appearance.stackedLayoutAppearance.selected.iconColor = .acBlack
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.acBlack]
        
        tabBar.scrollEdgeAppearance = appearance
    }
    
    private func setNavViewControllers() {
        let navVCs = ACTabBarItem.allCases.map {
            return setUpTabBarItem(title: $0.itemTitle,
                                   normalItemImage: $0.normalItemImage,
                                   selectedItemImage: $0.selectedItemImage,
                                   viewController: $0.viewController)
        }
        
        setViewControllers(navVCs, animated: true)
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
