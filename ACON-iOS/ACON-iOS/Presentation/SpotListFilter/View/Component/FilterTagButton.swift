//
//  FilterTagButton.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/14/25.
//

import UIKit

class FilterTagButton: ACButton {

    var isTagged: Bool = false {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                updateGlassButtonState(state: isTagged ? .selected : .default)
            }
        }
    }

    init() {
        super.init(style: GlassConfigButton(glassmorphismType: .buttonGlassDefault, buttonType: .full_19_b1R))

        DispatchQueue.main.async {
            self.updateGlassButtonState(state: .default)
        }

        self.addTarget(self, action: #selector(toggleSelf), for: .touchUpInside)
        self.addTarget(self, action: #selector(touchDownSelf), for: .touchDown)
        self.addTarget(self, action: #selector(touchUpOutsideSelf), for: .touchUpOutside)
        self.addTarget(self, action: #selector(touchCancelSelf), for: .touchCancel)
    }

    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    func toggleSelf(_ sender: UIButton) {
        isTagged.toggle()
    }

    @objc
    func touchDownSelf(_ sender: UIButton) {
        updateGlassButtonState(state: .pressed)
    }
    
    @objc
    func touchUpOutsideSelf(_ sender: UIButton) {
        updateGlassButtonState(state: .default)
    }

    @objc
    func touchCancelSelf(_ sender: UIButton) {
        updateGlassButtonState(state: .default)
    }

}
