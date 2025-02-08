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
    
    var topInsetView: UIView = UIView()
    
    var navigationBarView: UIView = UIView()
    
    var contentView: UIView = UIView()
    
    var leftButton: UIButton = UIButton()
    
    var rightButton: UIButton = UIButton()
    
    var titleLabel = UILabel()
    
    var secondTitleLabel: UILabel = UILabel()
    
    var centerTitleLabel: UILabel = UILabel()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setHierarchy()
        setLayout()
        setStyle()
    }
    
    func setHierarchy() {
        self.view.addSubviews(contentView,
                              topInsetView,
                              navigationBarView)
        
        self.navigationBarView.addSubviews(leftButton,
                                           rightButton,
                                           titleLabel,
                                           secondTitleLabel,
                                           centerTitleLabel)
    }
    
    func setLayout() {
        topInsetView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        navigationBarView.snp.makeConstraints {
            $0.top.equalTo(topInsetView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(ScreenUtils.heightRatio*56)
        }
        
        contentView.snp.makeConstraints {
            $0.top.equalTo(navigationBarView.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        leftButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(ScreenUtils.widthRatio*20)
        }
        
        rightButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(ScreenUtils.widthRatio*20)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(ScreenUtils.widthRatio*20)
        }
        
        secondTitleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(ScreenUtils.widthRatio*52)
        }
        
        centerTitleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
    }
    
    func setStyle() {
        self.view.backgroundColor = .gray9
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        [leftButton,
         rightButton,
         titleLabel,
         secondTitleLabel,
         centerTitleLabel].forEach { $0.isHidden = true }
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
    
    func setTitleLabelStyle(title: String,
                            fontStyle: ACFontStyleType = .t2,
                            color: UIColor = .acWhite,
                            alignment: NSTextAlignment = .left) {
        titleLabel.do {
            $0.isHidden = false
            $0.setLabel(text: title,
                        style: fontStyle,
                        color: color)
            $0.textAlignment = alignment
        }
    }
    
    func setSecondTitleLabelStyle(title: String,
                            fontStyle: ACFontStyleType = .t2,
                            color: UIColor = .acWhite,
                            alignment: NSTextAlignment = .left) {
        secondTitleLabel.do {
            $0.isHidden = false
            $0.setLabel(text: title,
                        style: fontStyle,
                        color: color)
            $0.textAlignment = alignment
        }
    }
    
    func setCenterTitleLabelStyle(title: String,
                            fontStyle: ACFontStyleType = .t2,
                            color: UIColor = .acWhite,
                            alignment: NSTextAlignment = .center) {
        centerTitleLabel.do {
            $0.isHidden = false
            $0.setLabel(text: title,
                        style: fontStyle,
                        color: color)
            $0.textAlignment = alignment
        }
    }
    
//    func applyGlassmorphismToNav(color: UIColor = .glaB30) {
//        let glassView = GlassmorphismView()
//        glassView.setGlassColor(color)
//        
//        view.insertSubview(glassView, aboveSubview: contentView)
//        
//        glassView.snp.makeConstraints {
//            $0.top.equalTo(topInsetView)
//            $0.bottom.horizontalEdges.equalTo(navigationBarView)
//        }
//        
//        [topInsetView, navigationBarView].forEach {
//            $0.backgroundColor = .clear
//        }
//        
//    }
    
    
    
}


// MARK: - NavigationBar Button Custom Methods

extension BaseNavViewController {
    
    // MARK: - 뒤로가기 버튼
    
    func setBackButton() {
        setButtonStyle(button: leftButton, image: .leftArrow)
        setButtonAction(button: leftButton, target: self, action: #selector(backButtonTapped))
    }
    
    @objc
    func backButtonTapped() {
        if let navigationController = navigationController {
            navigationController.popViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
    }
    
    
    // MARK: - 건너뛰기 버튼
    
    func setSkipButton() {
        rightButton.do {
            $0.isHidden = false
            $0.setAttributedTitle(text: "건너뛰기", style: .b2)
            setButtonAction(button: rightButton, target: self, action: #selector(skipButtonTapped))
        }
    }
    
    @objc
    func skipButtonTapped() {
        let vc = ACTabBarController()
        navigationController?.pushViewController(vc, animated: false)
    }
    
    
    // MARK: - 다음 버튼
    
    func setNextButton() {
        rightButton.do {
            $0.isHidden = false
            $0.configuration?.baseBackgroundColor = .clear
            $0.setAttributedTitle(text: StringLiterals.Upload.next,
                                   style: .b2,
                                  color: .acWhite,
                                  for: .normal)
            $0.setAttributedTitle(text: StringLiterals.Upload.next,
                                   style: .b2,
                                  color: .gray5,
                                  for: .disabled)
        }
    }
    

    // MARK: - X 버튼
    
    func setXButton() {
        setButtonStyle(button: leftButton, image: .icX)
    }
    
}
