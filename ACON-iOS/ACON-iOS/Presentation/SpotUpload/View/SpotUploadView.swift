//
//  SpotUploadView.swift
//  ACON-iOS
//
//  Created by 김유림 on 7/16/25.
//

import UIKit

final class SpotUploadView: BaseView {

    // MARK: - UI Properties

    let previousButton = ACButton(style: GlassConfigButton(glassmorphismType: .buttonGlassDefault, buttonType: .line_22_b1SB),
                                  title: StringLiterals.SpotUpload.goPrevious)

    let nextButton = ACButton(style: GlassConfigButton(glassmorphismType: .buttonGlassDefault, buttonType: .full_22_b1SB),
                              title: StringLiterals.SpotUpload.next)


    // MARK: - Lifecycle

    override func setHierarchy() {
        super.setHierarchy()

        self.addSubviews(previousButton,
                         nextButton)
    }

    override func setLayout() {
        super.setLayout()

        previousButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(ScreenUtils.horizontalInset)
            $0.bottom.equalTo(self.safeAreaLayoutGuide)
            $0.height.equalTo(44)
            $0.width.equalTo(120 * ScreenUtils.widthRatio)
        }
        
        nextButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-ScreenUtils.horizontalInset)
            $0.bottom.equalTo(self.safeAreaLayoutGuide)
            $0.height.equalTo(44)
            $0.width.equalTo(200 * ScreenUtils.widthRatio)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        previousButton.refreshButtonBlurEffect(.buttonGlassDefault)
        nextButton.refreshButtonBlurEffect(.buttonGlassDefault)
    }

}
