//
//  PhotoCollectionViewCell.swift
//  ACON-iOS
//
//  Created by 이수민 on 2/12/25.
//

import UIKit

final class PhotoCollectionViewCell: BaseCollectionViewCell {

    // MARK: - UI Properties
    
    private let photoImageView: UIImageView = UIImageView()
    
    private let dimView: UIView = UIView()
    
    private let whiteView: UIView = UIView()
    
    
    // MARK: - Properties
    
    override var isSelected: Bool {
        didSet {
            dimView.alpha = isSelected ? 1 : 0
        }
    }
    
    // MARK: - Lifecycle
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.addSubviews(photoImageView, dimView)
    }
    
    override func setLayout() {
        super.setLayout()
        
        dimView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        photoImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func setStyle() {
        super.setStyle()
        
        self.backgroundColor = .clear
        self.isSelected = false
        
        dimView.do {
            $0.backgroundColor = .labelAction.withAlphaComponent(0.2)
            $0.layer.borderColor = UIColor.labelAction.cgColor
            $0.layer.borderWidth = 1
        }
        
        photoImageView.do {
            $0.backgroundColor = .gray600
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFill
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        photoImageView.image = nil
        isSelected = false
    }
}


// MARK: - bind data

extension PhotoCollectionViewCell {
    
    func dataBind(_ image: UIImage, _ indexRow: Int) {
        photoImageView.image = image
    }
    
}
