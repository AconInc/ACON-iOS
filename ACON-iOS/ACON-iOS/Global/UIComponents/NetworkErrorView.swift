//
//  NetworkErrorView.swift
//  ACON-iOS
//
//  Created by 이수민 on 6/17/25.
//

import UIKit

final class NetworkErrorView: GlassmorphismView {

    // MARK: - UI Properties
    
    private let backButton = UIButton()
    
    private let wifiImageView: UIImageView = UIImageView()
    
    private let titleLabel: UILabel = UILabel()
    
    private let descriptionLabel: UILabel = UILabel()

    let retryButton: UIButton = UIButton()
    
    var retryAction: (() -> Void)?
    
    
    // MARK: - Lifecycle
    
    init(_ retryAction: @escaping () -> Void) {
        super.init(.bottomSheetGlass)
        
        self.retryAction = retryAction
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.addSubviews(backButton,
                         wifiImageView,
                         titleLabel,
                         descriptionLabel,
                         retryButton)
    }
    
    override func setLayout() {
        super.setLayout()
        
        backButton.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(ScreenUtils.heightRatio*28 - 10)
            $0.leading.equalToSuperview().inset(ScreenUtils.horizontalInset)
        }
        
        wifiImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.heightRatio*259)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(48)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.heightRatio*327)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(26)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.heightRatio*365)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(20)
        }
        
        retryButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.heightRatio*445)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(90*ScreenUtils.widthRatio)
            $0.height.equalTo(36*ScreenUtils.heightRatio)
        }
        
    }
    
    override func setStyle() {
        super.setStyle()
        
        backButton.do {
            $0.setImage(.icXmark, for: .normal)
            $0.clipsToBounds = true
            $0.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        }
        
        wifiImageView.do {
            $0.image = .icExclamationMark
            $0.tintColor = .acWhite
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFit
        }
        
        titleLabel.setLabel(text: StringLiterals.Error.networkErrorOccurred,
                            style: .t3SB,
                            alignment: .center)
        
        descriptionLabel.setLabel(text: StringLiterals.Error.checkInternetAndTryAgain,
                            style: .b1R,
                            color: .gray50,
                            alignment: .center)
        
        retryButton.do {
            $0.setAttributedTitle(text: StringLiterals.Error.tryAgain,
                                  style: .b1SB,
                                  color: .labelAction)
            $0.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
        }
    }
    
}


// MARK: - 네트워크뷰 표시 로직

private extension NetworkErrorView {
    
    func hideNetworkErrorView() {
        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let window = windowScene.windows.first else { return }
            
            window.subviews.filter { $0 is NetworkErrorView }.forEach { $0.removeFromSuperview() }
        }
    }
    
    @objc
    func retryButtonTapped() {
        DispatchQueue.main.async {
            self.hideNetworkErrorView()
            self.retryAction?()
        }
    }
    
    @objc
    func backButtonTapped() {
        DispatchQueue.main.async {
            self.hideNetworkErrorView()
        }
    }
    
}
