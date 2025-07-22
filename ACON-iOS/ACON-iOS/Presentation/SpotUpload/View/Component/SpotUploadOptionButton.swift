//
//  SpotUploadOptionButton.swift
//  ACON-iOS
//
//  Created by 김유림 on 7/19/25.
//

import UIKit

// TODO: ACButton.glassmorphismView가 업데이트 안 되는 문제 해결
final class SpotUploadOptionButton: ACButton {

    // MARK: - Properties

    var onStateChanged: ((Bool) -> Void)?

    var isButtonSelected: Bool = false {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                
                updateGlassButtonState(state: isButtonSelected ? .selected : .default)
                checkImageView.tintColor  = isButtonSelected ? .acWhite : .gray700
                isButtonSelected ? applyGlassBorder() : glassBorder.removeFromSuperview()
            }
        }
    }


    // MARK: - UI Properties

    private let checkImageView = UIImageView()
    private var glassBorder = GlassmorphismView(.buttonGlassSelected)
    private let glassBorderAttributes = GlassBorderAttributes(width: 1,
                                                              cornerRadius: 10,
                                                              glassmorphismType: .buttonGlassSelected)


    // MARK: - init

    init(title: String) {
        super.init(style: GlassConfigButton(glassmorphismType: .buttonGlassDefault, buttonType: .both_10_t4R, titleAlignment: .leading), title: title)

        setHierarchy()
        setLayout()
        setStyle()
    }


    // MARK: - UI Setting Methods

    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setHierarchy() {
        self.addSubview(checkImageView)
    }

    private func setLayout() {
        checkImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(14)
            $0.verticalEdges.equalToSuperview().inset(12)
        }
    }

    private func setStyle() {
        checkImageView.do {
            $0.image = .icCheckmark
            $0.contentMode = .scaleAspectFit
            $0.tintColor = isSelected ? .acWhite : .gray700
        }
    }

}


// MARK: - Helper

private extension SpotUploadOptionButton {

    // MARK: - GlassBorder

    func applyGlassBorder() {
        guard bounds.width > 0 && bounds.height > 0 else { return }

        glassBorder.removeFromSuperview()
        self.layer.borderWidth = 0

        let outerPath = UIBezierPath(roundedRect: bounds, cornerRadius: glassBorderAttributes.cornerRadius)
        let innerRect = bounds.insetBy(dx: glassBorderAttributes.width, dy: glassBorderAttributes.width)
        let innerPath = UIBezierPath(roundedRect: innerRect, cornerRadius: max(0, glassBorderAttributes.cornerRadius - glassBorderAttributes.width/2))
        outerPath.append(innerPath.reversing())

        glassBorder = GlassmorphismView(.buttonGlassSelected)

        self.addSubview(glassBorder)

        glassBorder.isUserInteractionEnabled = false

        glassBorder.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        let maskLayer = CAShapeLayer()
        maskLayer.path = outerPath.cgPath
        maskLayer.fillRule = .evenOdd
        
        let maskView = UIView(frame: bounds)
        maskView.layer.addSublayer(maskLayer)
        glassBorder.mask = maskView
    }

}
