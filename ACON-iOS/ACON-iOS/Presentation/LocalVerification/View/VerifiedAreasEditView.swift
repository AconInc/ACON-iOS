//
//  LocalVerificationEditView.swift
//  ACON-iOS
//
//  Created by 김유림 on 2/17/25.
//

import UIKit

protocol VerifiedAreasEditViewDelegate: AnyObject {
    
    func didTapAreaDeleteButton(_ verifiedAreaBox: VerifiedAreaModel)
    
}


class VerifiedAreasEditView: BaseView {
    
    // MARK: - Properties
    
    weak var delegate: VerifiedAreasEditViewDelegate?
    
    var verifiedAreaBoxes: [LabelBoxWithDeletableButton] = []
    

    // MARK: - Sizes
    
    private let verticalSpacing: CGFloat = 12
    
    
    // MARK: - UI Properties
    
    private let verifiedAreaTitleLabel = UILabel()
    
    let verifiedAreaAddButton = UIButton()
    
    let verifiedAreaStackView = UIStackView()
    
    

    // MARK: - Lifecycle
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.addSubviews(verifiedAreaTitleLabel,
                         verifiedAreaAddButton,
                         verifiedAreaStackView)
    }
    
    override func setLayout() {
        super.setLayout()
        
        verifiedAreaTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(32)
            $0.leading.equalToSuperview().offset(ScreenUtils.horizontalInset)
        }
        
        verifiedAreaAddButton.snp.makeConstraints {
            $0.top.equalTo(verifiedAreaTitleLabel.snp.bottom).offset(verticalSpacing)
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.horizontalInset)
            $0.height.equalTo(48)
        }
        
        verifiedAreaStackView.snp.makeConstraints {
            $0.top.equalTo(verifiedAreaAddButton.snp.bottom).offset(verticalSpacing)
            $0.leading.equalToSuperview().offset(ScreenUtils.horizontalInset)
            $0.width.equalTo((ScreenUtils.width - ScreenUtils.horizontalInset * 2) / 2)
        }
        
    }
    
    override func setStyle() {
        super.setStyle()
        
        verifiedAreaTitleLabel.setPartialText(
            fullText: StringLiterals.Profile.verifiedArea + StringLiterals.Profile.neccessaryStarWithSpace,
            textStyles: [
                (text: StringLiterals.Profile.verifiedArea, style: .h8, color: .acWhite),
                (text: StringLiterals.Profile.neccessaryStarWithSpace, style: .h8, color: .primaryDefault)
            ]
        )
        
        verifiedAreaAddButton.do {
            var config = UIButton.Configuration.plain()
            config.contentInsets = .init(top: 12, leading: 12, bottom: 12, trailing: 16)
            config.attributedTitle = AttributedString(StringLiterals.Profile.addVerifiedArea.ACStyle(.s1))
            config.image = .icAdd
            config.imagePadding = 4
            config.imagePlacement = .leading
            config.background.cornerRadius = 4
            config.background.strokeColor = .gray500
            config.background.strokeWidth = 1
            $0.configuration = config
        }
        
        verifiedAreaStackView.do {
            $0.axis = .vertical
            $0.spacing = 8
        }
    }
    
}


// MARK: - Internal Methods

extension VerifiedAreasEditView {
    
    func addVerifiedArea(_ verifiedArea: VerifiedAreaModel) {
        let name = verifiedArea.name
        let verifiedAreaBox = LabelBoxWithDeletableButton().then {
            $0.verifiedArea = verifiedArea
            $0.setLabel(name)
            $0.addDeleteAction(
                self,
                action: #selector(tappedAreaDeleteButton),
                for: .touchUpInside
            )
        }
        
        verifiedAreaBox.setLabel(name)
        verifiedAreaStackView.addArrangedSubview(verifiedAreaBox)
        verifiedAreaBoxes.append(verifiedAreaBox)
    }
    
    func removeVerifiedArea(verifiedArea: VerifiedAreaModel) {
        
        // NOTE: Button을 담고 있는 Array에서 삭제
        for (index, box) in verifiedAreaBoxes.enumerated() {
            if box.verifiedArea?.id == verifiedArea.id {
                // NOTE: View에서 삭제
                verifiedAreaStackView.removeArrangedSubview(box)
                box.removeFromSuperview()
                
                // NOTE: Array에서 삭제
                self.verifiedAreaBoxes.remove(at: index)
            }
        }
    }
    
    func removeAllVerifiedAreas() {
        for box in verifiedAreaBoxes {
            verifiedAreaStackView.removeArrangedSubview(box)
            box.removeFromSuperview()
        }
        
        self.verifiedAreaBoxes.removeAll()
    }
    
}


// MARK: - @objc function

private extension VerifiedAreasEditView {
    
    @objc
    func tappedAreaDeleteButton(_ sender: UIButton) {
        guard let box = (sender.superview)?.superview as? LabelBoxWithDeletableButton,
              let verifiedArea = box.verifiedArea else { return }
        
        delegate?.didTapAreaDeleteButton(
            VerifiedAreaModel(
                id: verifiedArea.id,
                name: verifiedArea.name
            )
        )
    }
    
}
