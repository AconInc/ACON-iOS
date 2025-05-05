//
//  FilterTagButton.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/14/25.
//

import UIKit

class FilterTagButton: UIButton {

    // MARK: - Properties

    private let glassView = GlassmorphismView()
    private let height: CGFloat = 38

    override var isSelected: Bool {
        didSet {
            configuration?.background.strokeColor = isSelected ? .acWhite : .clear
            
            // TODO: 글래스모피즘 수정
            glassView.setBlurStyle(isSelected ? .systemThinMaterialLight : .systemUltraThinMaterialLight)
        }
    }


    // MARK: - Initializiation

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setHierarchy()
        setLayout()
        setStyle()
        addTarget()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

}


// MARK: - UI Settings

private extension FilterTagButton {
    
    func setHierarchy() {
        self.addSubview(glassView)
    }
    
    func setLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(height)
        }
        
        glassView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func setStyle() {
        var config = UIButton.Configuration.bordered()
        config.baseForegroundColor = .acWhite
        config.baseBackgroundColor = .clear
        config.background.strokeWidth = 1
        config.cornerStyle = .capsule
        config.titleAlignment = .center
        config.titleLineBreakMode = .byTruncatingTail
        config.contentInsets = NSDirectionalEdgeInsets(top: 9,
                                                       leading: 12,
                                                       bottom: 9,
                                                       trailing: 12)

        self.configuration = config
        
        glassView.do {
            $0.clipsToBounds = true
            $0.isUserInteractionEnabled = false
            $0.layer.zPosition = -1 // NOTE: 버튼에 설정한 stroke를 가리지 않음
            $0.layer.cornerRadius = height / 2
        }
    }

    func addTarget() {
        self.addTarget(self, action: #selector(toggleSelf), for: .touchUpInside)
    }

}


// MARK: - @objc functions

private extension FilterTagButton {

    @objc
    func toggleSelf(_ sender: UIButton) {
        isSelected.toggle()
    }

}
