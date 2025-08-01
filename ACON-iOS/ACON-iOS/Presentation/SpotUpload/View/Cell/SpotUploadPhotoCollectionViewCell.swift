//
//  SpotUploadPhotoCollectionViewCell.swift
//  ACON-iOS
//
//  Created by 김유림 on 8/1/25.
//

import UIKit

// MARK: - Delegate Protocol

protocol SpotUploadPhotoCellDelegate: AnyObject {

    func deletePhoto(for indexPath: IndexPath)
    
    func addPhoto()

}


// MARK: - Cell

class SpotUploadPhotoCollectionViewCell: BaseCollectionViewCell {

    // MARK: - UI Properties

    private var glassBgView = GlassmorphismView(.buttonGlassDisabled)

    private var plusImageView = UIImageView()

    private var photoImageView = UIImageView()

    private var deleteButton = UIButton()


    // MARK: - Properties

    var indexPath: IndexPath?

    var delegate: SpotUploadPhotoCellDelegate?


    // MARK: - init

    override init(frame: CGRect) {
        super.init(frame: frame)

        addTarget()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - prepareForReuse

    override func prepareForReuse() {
        super.prepareForReuse()

        indexPath = nil
        setHiddenForReuse()
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
            $0.size.equalTo(24)
        }
    }

    override func setStyle() {
        self.do {
            $0.backgroundColor = .clear
        }

        glassBgView.do {
            $0.clipsToBounds = true
            $0.isUserInteractionEnabled = true
            $0.layer.cornerRadius = SpotUploadSizeType.Photo.cornerRadius.value
        }

        plusImageView.do {
            $0.image = .icPlus
            $0.contentMode = .scaleAspectFit
        }

        photoImageView.do {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = SpotUploadSizeType.Photo.cornerRadius.value
        }

        deleteButton.setImage(.icDelete, for: .normal)
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
        guard let indexPath else { return }
        delegate?.deletePhoto(for: indexPath)
    }

    @objc
    func tappedPlus() {
        delegate?.addPhoto()
    }

}


// MARK: - Internal Methods

extension SpotUploadPhotoCollectionViewCell {

    func setPhoto(_ image: UIImage, for indexPath: IndexPath) {
        photoImageView.image = image
        self.indexPath = indexPath
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
