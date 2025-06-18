//
//  MenuImageSlideViewController.swift
//  ACON-iOS
//
//  Created by 김유림 on 5/14/25.
//

import UIKit

class MenuImageSlideViewController: BaseViewController {

    // MARK: - Properties

    let viewModel: SpotDetailViewModel

    private let layout = UICollectionViewFlowLayout()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

    private let xButton = UIButton()
    private let leftButton = UIButton()
    private let rightButton = UIButton()

    private let imageWidth: CGFloat = 230 * ScreenUtils.widthRatio
    private let imageHeight: CGFloat = 325 * ScreenUtils.heightRatio

    init(_ viewModel: SpotDetailViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setDelegate()
        registerCell()
        addTarget()
        bindViewModel()
    }


    // MARK: - UI setting methods

    override func setHierarchy() {
        super.setHierarchy()

        view.addSubviews(collectionView, xButton, leftButton, rightButton)
    }

    override func setLayout() {
        super.setLayout()

        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        xButton.snp.makeConstraints {
            $0.centerY.equalTo(view.safeAreaLayoutGuide.snp.top).offset(28 * ScreenUtils.heightRatio)
            $0.leading.equalTo(20 * ScreenUtils.widthRatio)
            $0.size.equalTo(24)
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
            $0.backgroundColor = .gray900
            $0.isPagingEnabled = true
            $0.showsHorizontalScrollIndicator = false
        }

        xButton.do {
            $0.setImage(.icXmark, for: .normal)
        }

        leftButton.do {
            $0.isHidden = true
            $0.setImage(.icLeft, for: .normal)
        }

        rightButton.do {
            $0.isHidden = true
            $0.setImage(.icForward, for: .normal)
        }
    }

    private func setDelegate() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    private func registerCell() {
        collectionView.register(MenuCollectionViewCell.self, forCellWithReuseIdentifier: MenuCollectionViewCell.cellIdentifier)
    }

    private func addTarget() {
        xButton.addTarget(self, action: #selector(tappedXButton), for: .touchUpInside)
        leftButton.addTarget(self, action: #selector(tappedLeftButton), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(tappedRightButton), for: .touchUpInside)
    }

    private func bindViewModel() {
        self.viewModel.onSuccessGetMenuboardImageList.bind { [weak self] onSuccess in
            guard let onSuccess,
                  let self = self else { return }

            if onSuccess {
                collectionView.reloadData()
            } else {
                // TODO: 네트워크 통신 실패 UI
                self.dismiss(animated: true)
            }

            viewModel.onSuccessGetMenuboardImageList.value = nil
        }
    }

}


// MARK: - @objc functions

private extension MenuImageSlideViewController {

    @objc func tappedXButton() {
        self.dismiss(animated: true)
    }

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
        return viewModel.menuImageURLs.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = collectionView.dequeueReusableCell(withReuseIdentifier: MenuCollectionViewCell.cellIdentifier, for: indexPath) as? MenuCollectionViewCell else { return UICollectionViewCell() }

        let imageURL = viewModel.menuImageURLs[indexPath.item]

        item.setImage(imageURL: imageURL, isPinchable: true)

        item.onZooming = { [weak self] isZooming in
            if isZooming {
                self?.hideArrowButtons()
            } else {
                self?.updateArrowButtonsVisibility()
            }
        }
        
        self.updateArrowButtonsVisibility()
        
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
            let imageURLs = viewModel.menuImageURLs
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
        let imageURLs = viewModel.menuImageURLs

        if imageURLs.count == 1 {
            hideArrowButtons()
        } else {
            leftButton.isHidden = currentIndex == 0
            rightButton.isHidden = currentIndex == imageURLs.count - 1
        }
    }

    func hideArrowButtons() {
        [leftButton, rightButton].forEach { $0.isHidden = true }
    }

}
