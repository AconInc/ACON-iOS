//
//  FilterTagButton.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/14/25.
//

import UIKit

class FilterTagButton: ACButton {

    var isTagged: Bool = false

    init() {
        super.init(style: GlassConfigButton(glassmorphismType: .buttonGlassDefault, buttonType: .full_19_b1R))

        updateGlassButtonState(state: .default)

        self.addTarget(self, action: #selector(toggleSelf), for: .touchUpInside)
        self.addTarget(self, action: #selector(touchDownSelf), for: .touchDown)
    }

    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    func toggleSelf(_ sender: UIButton) {
        isTagged.toggle()
        updateGlassButtonState(state: isTagged ? .selected : .default)
    }

    @objc
    func touchDownSelf(_ sender: UIButton) {
        updateGlassButtonState(state: .pressed)
    }

}
