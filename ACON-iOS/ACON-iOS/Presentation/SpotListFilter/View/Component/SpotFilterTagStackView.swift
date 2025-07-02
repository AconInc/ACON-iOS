//
//  SpotFilterTagStackView.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/16/25.
//

import UIKit

class SpotFilterTagStackView: UIStackView {

    // MARK: - Properties

    var tags: [FilterTagButton] = []


    // MARK: - LifeCycles

    override init(frame: CGRect) {
        super.init(frame: frame)

        setStyle()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setStyle() {
        self.axis = .horizontal
        self.spacing = 8
    }

}


// MARK: - Internal Methods

extension SpotFilterTagStackView {

    func addTagButtons(titles: [String]) {
        for title in titles {
            let button = FilterTagButton()
            button.updateButtonTitle(title)
            self.addArrangedSubview(button)
            self.tags.append(button)
        }
        
        addEmptyView()
    }

}


// MARK: - Helper

private extension SpotFilterTagStackView {

    func addEmptyView() {
        self.addArrangedSubview(PriorityLowEmptyView())
    }

}
