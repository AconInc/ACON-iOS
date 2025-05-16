//
//  SpotDetailMoreViewController.swift
//  ACON-iOS
//
//  Created by 김유림 on 5/16/25.
//

import UIKit

import Then

class SpotDetailMoreViewController: BaseViewController {

    // MARK: - UI components

    private let glassMorphismView = GlassmorphismView(.bottomSheetGlass)

    private let pageTitleLabel = UILabel()

    private let infoErrorButton = UIButton()


    // MARK: - Life Cycles

    override func viewDidLoad() {
        super.viewDidLoad()

        addTarget()
    }
    
    override func setHierarchy() {
        super.setHierarchy()

        view.addSubview(glassMorphismView)

        glassMorphismView.addSubviews(pageTitleLabel, infoErrorButton)
    }

    override func setLayout() {
        super.setLayout()

        glassMorphismView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        pageTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(43)
            $0.centerX.equalToSuperview()
        }

        infoErrorButton.snp.makeConstraints {
            $0.top.equalTo(pageTitleLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(56)
        }
    }

    override func setStyle() {
        super.setStyle()

        view.backgroundColor = .clear
        
        glassMorphismView.do {
            $0.backgroundColor = .clear
            $0.setHandlerImageView()
        }

        pageTitleLabel.setLabel(text: StringLiterals.SpotDetail.seeMore, style: .t3SB)

        infoErrorButton.do {
            var config = UIButton.Configuration.plain()
            let verticalInset = 17 * ScreenUtils.heightRatio
            let horizontalInset = 16 * ScreenUtils.widthRatio

            config.contentInsets = .init(top: verticalInset, leading: horizontalInset, bottom: verticalInset, trailing: horizontalInset)
            config.image = .icExclamationMarkFill
            config.imagePadding = 12 * ScreenUtils.widthRatio

            $0.configuration = config
            $0.contentHorizontalAlignment = .leading
            $0.setAttributedTitle(text: StringLiterals.SpotDetail.reportInfoError, style: .t4SB)
        }
    }

    private func addTarget() {
        infoErrorButton.addTarget(self, action: #selector(tappedInfoErrorButton), for: .touchUpInside)
    }

}


// MARK: - @objc function

private extension SpotDetailMoreViewController {

    @objc
    func tappedInfoErrorButton() {
        let reportVC = DRWebViewController(urlString: StringLiterals.WebView.spotInfoErrorReportLink)
        self.present(reportVC, animated: true)
    }

}
