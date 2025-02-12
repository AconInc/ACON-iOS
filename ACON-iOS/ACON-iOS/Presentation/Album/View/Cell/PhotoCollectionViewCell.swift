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
    
    
    // MARK: - Lifecycle
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.addSubview(photoImageView)
    }
    
    override func setLayout() {
        super.setLayout()
        
        photoImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func setStyle() {
        super.setStyle()
        
        self.backgroundColor = .clear
        photoImageView.do {
            $0.backgroundColor = .gray6
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

extension PhotoCollectionViewCell {
    
    func dataBind(_ image: UIImage, _ indexRow: Int) {
        photoImageView.image = image
    }
    
}
