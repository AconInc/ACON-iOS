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
    
    var glassmorphismNavBarView: GlassmorphismView = GlassmorphismView(.gradientGlass)
    
    var topInsetView: UIView = UIView()
    
    var navigationBarView: UIView = UIView()
    
    var contentView: UIView = UIView()
    
    var leftButton: UIButton = UIButton()
    
    var rightButton: UIButton = UIButton()
    
    var titleLabel = UILabel()
    
    var secondTitleLabel: UILabel = UILabel()
    
    var centerTitleLabel: UILabel = UILabel()
    
    let glassMorphismView = GlassmorphismView(.gradientGlass)
    
    var backCompletion: (() -> Void)?
    
    var skipCompletion: (() -> Void)?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setHierarchy()
        setLayout()
        setStyle()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
            $0.leading.equalToSuperview().inset(ScreenUtils.horizontalInset)
        }
        
        rightButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(ScreenUtils.horizontalInset)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(ScreenUtils.horizontalInset)
        }
        
        secondTitleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(ScreenUtils.widthRatio*52)
            $0.trailing.equalToSuperview().inset(ScreenUtils.horizontalInset)
        }
        
        centerTitleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
    }
    
    func setStyle() {
        self.view.backgroundColor = .gray900
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
                            fontStyle: ACFontType = .t4SB,
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
                                  fontStyle: ACFontType = .t4SB,
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
                                  fontStyle: ACFontType = .t4SB,
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
    
    func setGlassMorphism() {
        self.view.insertSubview(glassMorphismView,
                                aboveSubview: contentView)
        [topInsetView, navigationBarView].forEach {
            $0.backgroundColor = .clear
        }
        glassMorphismView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(ScreenUtils.safeAreaTopHeight + ScreenUtils.navViewHeight)
        }
        self.view.layoutIfNeeded()
        glassMorphismView.setGradient()
    }
    
}


// MARK: - NavigationBar Button Custom Methods

extension BaseNavViewController {
    
    // MARK: - 뒤로가기 버튼
    
    func setBackButton(completion: (() -> Void)? = nil) {
        setButtonStyle(button: leftButton, image: .icLeft)
        setButtonAction(button: leftButton, target: self, action: #selector(backButtonTapped))
        self.backCompletion = completion
    }
    
    @objc
    func backButtonTapped() {
        backCompletion?()
        if let navigationController = navigationController {
            navigationController.popViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
        self.backCompletion = nil
    }
    
    
    // MARK: - 건너뛰기 버튼
    func setSkipButton(completion: (() -> Void)? = NavigationUtils.navigateToTabBar) {
        rightButton.do {
            $0.isHidden = false
            $0.setAttributedTitle(text: "건너뛰기", style: .t4SB)
            setButtonAction(button: rightButton,
                            target: self,
                            action: #selector(skipButtonTapped))
        }
        self.skipCompletion = completion
    }

    @objc
    func skipButtonTapped() {
        skipCompletion?()
    }
    
    
    // MARK: - 설정 버튼
    
    func setSettingButton() {
        setButtonStyle(button: rightButton, image: .icSetting)
        setButtonAction(button: rightButton,
                        target: self,
                        action: #selector(settingButtonTapped))
    }
    
    @objc
    func settingButtonTapped() {
        let vc = ProfileSettingViewController()
        navigationController?.pushViewController(vc, animated: false)
    }
    
    
    // MARK: - 다음 버튼
    
    func setNextButton() {
        rightButton.do {
            $0.isHidden = false
            $0.configuration?.baseBackgroundColor = .clear
            $0.setAttributedTitle(text: StringLiterals.Upload.next,
                                  style: .t4SB,
                                  color: .labelAction,
                                  for: .normal)
            $0.setAttributedTitle(text: StringLiterals.Upload.next,
                                  style: .t4SB,
                                  color: .gray300,
                                  for: .disabled)
        }
    }
    
    
    // MARK: - 선택 버튼
    
    func setSelectButton() {
        rightButton.do {
            $0.isHidden = false
            $0.configuration?.baseBackgroundColor = .clear
            $0.setAttributedTitle(text: StringLiterals.Album.choose,
                                  style: .t4SB,
                                  color: .labelAction,
                                  for: .normal)
            $0.setAttributedTitle(text: StringLiterals.Album.choose,
                                  style: .t4SB,
                                  color: .gray300,
                                  for: .disabled)
        }
    }

    
    // MARK: - 완료 버튼
    
    func setDoneButton() {
        rightButton.do {
            $0.isHidden = false
            $0.configuration?.baseBackgroundColor = .clear
            $0.setAttributedTitle(text: StringLiterals.Album.done,
                                  style: .t4SB,
                                  color: .labelAction,
                                  for: .normal)
            $0.setAttributedTitle(text: StringLiterals.Album.done,
                                  style: .t4SB,
                                  color: .gray300,
                                  for: .disabled)
        }
    }
    
    
    // MARK: - 더보기 버튼
    
    func setMoreButton() {
        setButtonStyle(button: rightButton, image: .icEllipsis)
        setButtonAction(button: rightButton,
                        target: self,
                        action: #selector(tappedMoreButton))
    }
    
    @objc
    private func tappedMoreButton() {
        let vc = SpotDetailMoreViewController()
        vc.setSheetLayout(detent: .short)
        self.present(vc, animated: true)
    }
    
    
    // MARK: - X 버튼
    
    func setXButton(_ action: Selector? = nil) {
        setButtonStyle(button: leftButton, image: .icXmark)
        guard let action else {
            setButtonAction(button: leftButton,
                            target: self,
                            action: #selector(xButtonTapped))
            return
        }
        setButtonAction(button: leftButton,
                        target: self,
                        action: action)
    }
    
    @objc
    func xButtonTapped() {
        self.dismiss(animated: true)
    }
    
}


// MARK: - popGestrue

extension BaseNavViewController: UIGestureRecognizerDelegate {
    
    func setPopGesture() {
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let navigationController = self.navigationController else { return false }
        return navigationController.viewControllers.count > 1
    }

    // NOTE: - 다른 제스처와의 동시 인식 허용
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                          shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}
