//
//  BaseNavViewController.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/7/25.
//

import UIKit

import SnapKit
import Then

class BaseNavViewController: UIViewController {
    
    // MARK: - UI Properties
    
    let topInsetView = UIView()
    
    var navigationBarView = UIView()
    
    var contentView = UIView()
    
    private var leftButton = UIButton()
    
    private var secondLeftButton = UIButton()
    
    private var rightButton = UIButton()
    
    private var secondRightButton = UIButton()
    
    var titleLabel = UILabel()
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setHierarchy()
        setLayout()
        setStyle()
    }
    
    func setHierarchy() {
        self.view.addSubviews(topInsetView,
                              navigationBarView,
                              contentView)
        
        self.navigationBarView.addSubviews(leftButton,
                                           secondLeftButton,
                                           rightButton,
                                           secondRightButton,
                                           titleLabel)
    }
    
    func setLayout() {
        topInsetView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        navigationBarView.snp.makeConstraints {
            $0.top.equalTo(topInsetView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(ScreenUtils.height*48/724)
        }
        
        contentView.snp.makeConstraints {
            $0.top.equalTo(navigationBarView.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        leftButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(ScreenUtils.width*5/375)
        }
        
        secondLeftButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(ScreenUtils.width*45/375)
        }
        
        rightButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(ScreenUtils.width*6/375)
        }
        
        secondRightButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(ScreenUtils.width*40/375)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }
    
    func setStyle() {
        self.view.backgroundColor = .gray9
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        [leftButton,
         secondLeftButton,
         rightButton,
         secondRightButton,
         titleLabel].forEach { $0.isHidden = true }
    }
    
}


// MARK: - NavigationBar Custom Methods

extension BaseNavViewController {
    
    func setBackgroundColor(color: UIColor) {
        topInsetView.do {
            $0.backgroundColor = color
        }
        navigationBarView.do {
            $0.backgroundColor = color
        }
    }
    
    func setButtonStyle(button: UIButton, image: UIImage?) {
        button.do {
            $0.isHidden = false
            $0.setImage(image, for: .normal)
        }
    }
    
    func setButtonAction(button: UIButton, target: Any, action: Selector) {
        button.addTarget(target, action: action, for: .touchUpInside)
    }
    
    func setTitleLabelStyle(title: String?, alignment: NSTextAlignment) {
        titleLabel.do {
            $0.isHidden = false
            $0.text = title
            $0.font = .systemFont(ofSize: 10, weight: .medium)
            $0.textColor = .acWhite
            $0.textAlignment = alignment
        }
    }
    
}

// MARK: - NavigationBar Button Custom Methods -> 추후 변경 및 수정 에정

extension BaseNavViewController {
    
    func setBackButton() {
        setButtonStyle(button: leftButton, image: .strokedCheckmark)
        setButtonAction(button: leftButton, target: self, action: #selector(backButtonTapped))
    }
    
    @objc
    func backButtonTapped() {
        navigationController?.popViewController(animated: false)
    }
    
}
