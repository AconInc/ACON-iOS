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
    
    let topInsetView: UIView = UIView()
    
    var navigationBarView: UIView = UIView()
    
    var contentView: UIView = UIView()
    
    private var leftButton: UIButton = UIButton()
    
    private var rightButton: UIButton = UIButton()
    
    var titleLabel = UILabel()
    
    var secondTitleLabel: UILabel = UILabel()
    
    
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
                                           rightButton,
                                           titleLabel,
                                           secondTitleLabel)
    }
    
    func setLayout() {
        topInsetView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        navigationBarView.snp.makeConstraints {
            $0.top.equalTo(topInsetView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(ScreenUtils.height*56/780)
        }
        
        contentView.snp.makeConstraints {
            $0.top.equalTo(navigationBarView.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        leftButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(ScreenUtils.width*20/380)
        }
        
        rightButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(ScreenUtils.width*20/380)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(ScreenUtils.width*20/360)
        }
        
        secondTitleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(ScreenUtils.width*52/360)
        }
        
    }
    
    func setStyle() {
        self.view.backgroundColor = .gray9
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        [leftButton,
         rightButton,
         titleLabel,
         secondTitleLabel].forEach { $0.isHidden = true }
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


// MARK: - NavigationBar Button Custom Methods

extension BaseNavViewController {
    
    // MARK: - 뒤로가기 버튼
    
    func setBackButton() {
        setButtonStyle(button: leftButton, image: .leftArrow)
        setButtonAction(button: leftButton, target: self, action: #selector(backButtonTapped))
    }
    
    @objc
    func backButtonTapped() {
        navigationController?.popViewController(animated: false)
    }
    
    
    // MARK: - 건너뛰기 버튼
    
    func setSkipButton() {
        rightButton.do {
            $0.setAttributedTitle(text: "건너뛰기", style: .b2)
            setButtonAction(button: rightButton, target: self, action: #selector(skipButtonTapped))
        }
    }
    
    @objc
    func skipButtonTapped() {
        //TODO: - 추후 mainVC 메인 장소탐색 뷰컨으로 변경
        let mainVC = ViewController()
        navigationController?.pushViewController(mainVC, animated: false)
    }

}
