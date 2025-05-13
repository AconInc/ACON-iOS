//
//  MenuImageSlideViewController.swift
//  ACON-iOS
//
//  Created by 김유림 on 5/14/25.
//

import UIKit

class MenuImageSlideViewController: BaseViewController {

    // MARK: - Properties

    let imageURLs: [String]

    private let layout = UICollectionViewFlowLayout()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

    private let leftButton = UIButton()
    private let rightButton = UIButton()

    private let imageWidth: CGFloat = 230 * ScreenUtils.widthRatio
    private let imageHeight: CGFloat = 325 * ScreenUtils.heightRatio

    init(_ imageURLs: [String]) {
        self.imageURLs = imageURLs

        super.init(nibName: nil, bundle: nil)
    }

    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - Life Cycles

    override func viewDidLoad() {
        super.viewDidLoad()

        setHierarchy()
        setLayout()
        setStyle()
        setDelegate()
    }

    override func setHierarchy() {
        super.setHierarchy()

        view.addSubviews(collectionView, leftButton, rightButton)
    }

    override func setLayout() {
        super.setLayout()

        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        leftButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
            $0.size.equalTo(36)
        }

        rightButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
            $0.size.equalTo(36)
        }
    }

    override func setStyle() {
        super.setStyle()

        view.backgroundColor = .dimDefault

        layout.do {
            $0.scrollDirection = .horizontal
            $0.itemSize = .init(width: ScreenUtils.width, height: ScreenUtils.height)
            $0.minimumLineSpacing = 0
        }

        collectionView.do {
            $0.backgroundColor = .clear
            $0.isPagingEnabled = true
        }

        leftButton.do {
            $0.setImage(.icLeft, for: .normal)
        }

        rightButton.do {
            $0.setImage(.icForward, for: .normal)
        }
    }

    private func setDelegate() {
        collectionView.dataSource = self
        collectionView.register(MenuCollectionViewCell.self, forCellWithReuseIdentifier: MenuCollectionViewCell.cellIdentifier)
    }

}


// MARK: - CollectionViewDelegate

extension MenuImageSlideViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imageURLs.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = collectionView.dequeueReusableCell(withReuseIdentifier: MenuCollectionViewCell.cellIdentifier, for: indexPath) as? MenuCollectionViewCell else { return UICollectionViewCell() }
        item.setImage(imageURL: imageURLs[indexPath.item], isPinchable: true)
        item.onBackgroundTapped = { [weak self] in
            self?.dismiss(animated: true)
        }
        return item
    }
 
}
