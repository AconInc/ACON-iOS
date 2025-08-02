//
//  SpotUploadPhotoCollectionViewCell.swift
//  ACON-iOS
//
//  Created by 김유림 on 8/1/25.
//

import UIKit

// MARK: - Delegate Protocol

protocol SpotUploadPhotoCellDelegate: AnyObject {

    func deletePhoto(for cell: UICollectionViewCell)
    
    func addPhoto()

}


// MARK: - Cell

class SpotUploadPhotoCollectionViewCell: BaseCollectionViewCell {

    // MARK: - UI Properties

    private let glassBgView = GlassmorphismView(.buttonGlassDisabled)

    private let plusImageView = UIImageView()

    private let photoImageView = UIImageView()

    private let deleteButton = ACButton(style: GlassButton(glassmorphismType: .buttonGlassDefault, buttonType: .full_22_b1SB))


    // MARK: - Properties

    var delegate: SpotUploadPhotoCellDelegate?


    // MARK: - init

    override init(frame: CGRect) {
        super.init(frame: frame)

        addTarget()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - Life Cycles

    override func prepareForReuse() {
        super.prepareForReuse()

        setHiddenForReuse()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        glassBgView.refreshBlurEffect()
        deleteButton.refreshButtonBlurEffect(.buttonGlassDefault)
    }


    // MARK: - UI Settings

    override func setHierarchy() {
        super.setHierarchy()

        contentView.addSubviews(glassBgView, plusImageView, photoImageView, deleteButton)
    }

    override func setLayout() {
        super.setLayout()

        [glassBgView, photoImageView].forEach {
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }

        plusImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(24)
        }

        deleteButton.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview().inset(16)
            $0.size.equalTo(44)
        }
    }

    override func setStyle() {
        self.do {
            $0.backgroundColor = .clear
        }

        glassBgView.do {
            $0.clipsToBounds = true
            $0.isUserInteractionEnabled = true
            $0.layer.cornerRadius = 10 * ScreenUtils.widthRatio
        }

        plusImageView.do {
            $0.image = .icPlus
            $0.contentMode = .scaleAspectFit
        }

        photoImageView.do {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 10 * ScreenUtils.widthRatio
        }

        deleteButton.setImage(.icDelete, for: .normal)
        deleteButton.do {
            $0.setImage(.icDelete, for: .normal)
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.acWhite.withAlphaComponent(0.3).cgColor
        }
    }

    private func addTarget() {
        deleteButton.addTarget(self, action: #selector(tappedDeleteButton), for: .touchUpInside)
        glassBgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedPlus)))
    }

}


// MARK: - @objc functions

private extension SpotUploadPhotoCollectionViewCell {

    @objc
    func tappedDeleteButton() {
        delegate?.deletePhoto(for: self)
    }

    @objc
    func tappedPlus() {
        delegate?.addPhoto()
    }

}


// MARK: - Internal Methods

extension SpotUploadPhotoCollectionViewCell {

    func setPhoto(_ image: UIImage) {
        photoImageView.image = image
        setHiddenForPhoto()
    }

    func setAddView() {
        setHiddenForAdd()
    }
}


// MARK: - Helper

private extension SpotUploadPhotoCollectionViewCell {

    func setHiddenForReuse() {
        glassBgView.isHidden = false
        [photoImageView, deleteButton, plusImageView].forEach { $0.isHidden = true }
    }

    func setHiddenForPhoto() {
        [glassBgView, plusImageView].forEach { $0.isHidden = true }
        [photoImageView, deleteButton].forEach { $0.isHidden = false }
    }

    func setHiddenForAdd() {
        [glassBgView, plusImageView].forEach { $0.isHidden = false }
        [photoImageView, deleteButton].forEach { $0.isHidden = true }
    }

}
