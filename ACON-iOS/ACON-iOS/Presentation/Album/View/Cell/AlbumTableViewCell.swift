//
//  AlbumTableViewCell.swift
//  ACON-iOS
//
//  Created by 이수민 on 2/16/25.
//

import UIKit
import Photos

import UIKit

class AlbumTableViewCell: UITableViewCell {
    
    // MARK: - UI Properties
    
    private let thumbnailImageView: UIImageView = UIImageView()
    
    private let titleLabel: UILabel = UILabel()
    
    private let countLabel: UILabel = UILabel()
    
    
    // MARK: - Properties
    
    private let albumViewModel = AlbumViewModel()
    
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setHierarchy()
        setLayout()
        setStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        self.selectionStyle = .none
    }
    
    func setHierarchy() {
        self.contentView.addSubviews(thumbnailImageView,
                                     titleLabel,
                                     countLabel)
    }
    
    func setLayout() {
        thumbnailImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(64)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().inset(96)
        }
        
        countLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().inset(96)
        }
    }
    
    func setStyle() {
        self.backgroundColor = .gray900
        
        thumbnailImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 6
        }
    }
    
}


// MARK: - configure cell

extension AlbumTableViewCell {
    
    func configure(_ albumInfo: AlbumModel) {
        titleLabel.do {
            $0.setLabel(text: albumInfo.title,
                        style: .t4R,
                        color: .acWhite)
        }
        countLabel.do {
            if albumInfo.count >= 0 {
                $0.setLabel(text: "\(albumInfo.count)",
                            style: .b1R,
                            color: .gray500)
            }
        }
        thumbnailImageView.image = albumInfo.thumbnailImage
    }
    
}
