//
//  SearchKeywordCollectionFooterView.swift
//  ACON-iOS
//
//  Created by 이수민 on 8/3/25.
//

import UIKit

class SearchKeywordCollectionFooterView: UICollectionReusableView {
    
    let addPlaceButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setButton() {
        addSubview(addPlaceButton)
        
        addPlaceButton.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
        }
        
        addPlaceButton.do {
            $0.setAttributedTitle(text: StringLiterals.Upload.addPlaceButton,
                                  style: .b1SB,
                                  color: .labelAction)
        }
    }
    
}
