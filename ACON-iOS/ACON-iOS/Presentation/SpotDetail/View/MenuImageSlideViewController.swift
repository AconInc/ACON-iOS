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

    private var hasUpdatedArrowButtons = false

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

        setDelegate()
        addTarget()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if !hasUpdatedArrowButtons {
            updateArrowButtonsVisibility()
            hasUpdatedArrowButtons = true
        }
    }


    // MARK: - UI setting methods

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
        collectionView.delegate = self

        collectionView.register(MenuCollectionViewCell.self, forCellWithReuseIdentifier: MenuCollectionViewCell.cellIdentifier)
    }

    private func addTarget() {
        leftButton.addTarget(self, action: #selector(tappedLeftButton), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(tappedRightButton), for: .touchUpInside)
    }

}


// MARK: - @objc functions

private extension MenuImageSlideViewController {

    @objc func tappedLeftButton() {
        scrollCollectionView(by: -1)
    }

    @objc func tappedRightButton() {
        scrollCollectionView(by: 1)
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

        item.onZooming = { [weak self] isZooming in
            if isZooming {
                self?.hideArrowButtons()
            } else {
                self?.updateArrowButtonsVisibility()
            }
        }

        item.onBackgroundTapped = { [weak self] in
            self?.dismiss(animated: true)
        }

        return item
    }
 
}

extension MenuImageSlideViewController: UICollectionViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateArrowButtonsVisibility()
    }

}


// MARK: - Helper

private extension MenuImageSlideViewController {

    func scrollCollectionView(by offset: Int) {
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)

        if let indexPath = collectionView.indexPathForItem(at: visiblePoint) {
            var newIndex = indexPath.item + offset
            newIndex = max(0, min(imageURLs.count - 1, newIndex))

            collectionView.scrollToItem(at: IndexPath(item: newIndex, section: 0),
                                        at: .centeredHorizontally,
                                        animated: true)
        }

    }

    func updateArrowButtonsVisibility() {
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        guard let indexPath = collectionView.indexPathForItem(at: visiblePoint) else { return }

        let currentIndex = indexPath.item
        leftButton.isHidden = currentIndex == 0
        rightButton.isHidden = currentIndex == imageURLs.count - 1
    }

    func hideArrowButtons() {
        [leftButton, rightButton].forEach { $0.isHidden = true }
    }

}
