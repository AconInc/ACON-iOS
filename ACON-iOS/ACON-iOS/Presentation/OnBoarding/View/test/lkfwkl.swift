//
//  lkfwkl.swift
//  ACON-iOS
//
//  Created by Jaehyun Ahn on 1/20/25.
//

import Foundation
import UIKit

class ParentViewController: UIViewController {
    
    // MARK: - UI Components
    private let bottomButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("상위 뷰 하단 버튼", for: .normal)
        button.backgroundColor = .systemRed
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let childViewController = LongCollectionViewController()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupChildViewController()
        setupLayout()
    }
    
    private func setupChildViewController() {
        // Child ViewController 추가
        addChild(childViewController)
        childViewController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(childViewController.view)
        childViewController.didMove(toParent: self)
    }
    
    private func setupLayout() {
        // 하단 버튼 추가
        view.addSubview(bottomButton)
        NSLayoutConstraint.activate([
            bottomButton.heightAnchor.constraint(equalToConstant: 50),
            bottomButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            bottomButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            bottomButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
        
        // Child ViewController의 뷰 레이아웃 설정
        NSLayoutConstraint.activate([
            childViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            childViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            childViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            childViewController.view.bottomAnchor.constraint(equalTo: bottomButton.topAnchor, constant: -16)
        ])
    }
}

import SwiftUI

// ParentViewController를 SwiftUI에서 Preview로 사용할 수 있도록 래핑
struct ParentViewControllerPreview: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        return ParentViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // 업데이트가 필요하면 여기서 처리 가능
    }
}

// SwiftUI PreviewProvider
struct ParentViewController_Preview: PreviewProvider {
    static var previews: some View {
        ParentViewControllerPreview()
            .edgesIgnoringSafeArea(.all) // 전체 화면에 걸쳐서 표시
    }
}
