//
//  SpotDetailViewController.swift
//  ACON-iOS
//
//  Created by 김유림 on 5/13/25.
//

import UIKit

class SpotDetailViewController: BaseNavViewController {

    // MARK: - UI Properties

    private let spotDetailView = SpotDetailView()


    // MARK: - Properties

    private let viewModel: SpotDetailViewModel

    private var startTime: Date?

    private var timer: Timer?


    // MARK: - LifeCycle

    init(_ spotID: Int64) {
        self.viewModel = SpotDetailViewModel(spotID: spotID)

        super.init(nibName: nil, bundle: nil)
    }

    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setDelegate()
        registerCell()
        addTarget()
        bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)

        self.tabBarController?.tabBar.isHidden = true

        viewModel.getSpotDetail()
        viewModel.getSpotMenu()
        startTime = Date()
    }

    override func viewWillDisappear(_ animated: Bool) {
        timer?.invalidate()
        timer = nil

        if let startTime = startTime {
            let timeInterval = Date().timeIntervalSince(startTime)
            AmplitudeManager.shared.trackEventWithProperties(AmplitudeLiterals.EventName.mainMenu, properties: ["place_detail_duration": timeInterval])
        }
    }

    override func setHierarchy() {
        super.setHierarchy()
        
        view.insertSubview(spotDetailView, at: 1) // NOTE: interaction이 가능하도록 contentView 위에 삽입
    }

    override func setLayout() {
        super.setLayout()

        spotDetailView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func setStyle() {
        super.setStyle()

        self.setBackButton(completion: backCompletion)
    }

    private func setDelegate() {
        spotDetailView.collectionView.dataSource = self
        spotDetailView.collectionView.delegate = self
    }

    private func registerCell() {
        spotDetailView.collectionView.register(SpotDetailImageCollectionViewCell.self, forCellWithReuseIdentifier: SpotDetailImageCollectionViewCell.cellIdentifier)
    }

    private func addTarget() {
        spotDetailView.findCourseButton.addTarget(self,
                                                  action: #selector(tappedFindCourseButton),
                                                  for: .touchUpInside)

        let menuTapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedMenuButton))
        spotDetailView.menuButton.addGestureRecognizer(menuTapGesture)

        let moreTapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedMoreButton))
        spotDetailView.moreButton.addGestureRecognizer(moreTapGesture)
    }

}
 

// MARK: - bindViewModel

private extension SpotDetailViewController {

    func bindViewModel() {
        self.viewModel.onSuccessGetSpotDetail.bind { [weak self] onSuccess in
            guard let onSuccess,
                  let data = self?.viewModel.spotDetail.value else { return }
            if onSuccess {
                self?.spotDetailView.bindData(data)
            } else {
                self?.showDefaultAlert(title: "장소 정보 로드 실패", message: "장소 정보 로드에 실패했습니다.")
            }
        }

        self.viewModel.onSuccessGetSpotMenu.bind { [weak self] onSuccess in
            guard let onSuccess else { return }
            if onSuccess {
                self?.spotDetailView.makeMainMenuSection(self?.viewModel.spotMenu.value ?? [])
            } else {
                self?.showDefaultAlert(title: "장소 메뉴 로드 실패", message: "장소 메뉴 로드에 실패했습니다.")
            }
        }
    }

}


// MARK: - @objc methods

private extension SpotDetailViewController {

    @objc
    func tappedFindCourseButton() {
        viewModel.postGuidedSpot()
        AmplitudeManager.shared.trackEventWithProperties(AmplitudeLiterals.EventName.mainMenu, properties: ["click_detail_navigation?": true])

        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.do {
            $0.addAction(UIAlertAction(title: "네이버 지도", style: .default, handler: { _ in
                self.viewModel.redirectToNaverMap()
            }))
            $0.addAction(UIAlertAction(title: "Apple 지도", style: .default, handler: { _ in
                self.viewModel.redirectToAppleMap()
            }))
            $0.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        }
        present(alertController, animated: true)
    }

    @objc
    func tappedMenuButton() {
        let vc = MenuImageSlideViewController(viewModel.menuImageURLs)
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }

    @objc
    func tappedMoreButton() {
        let vc = SpotDetailMoreViewController()
        vc.setSheetLayout(detent: .short)
        self.present(vc, animated: true)
    }

}


// MARK: - CollectionView DataSource

extension SpotDetailViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.imageURLs.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = collectionView.dequeueReusableCell(withReuseIdentifier: SpotDetailImageCollectionViewCell.cellIdentifier, for: indexPath) as? SpotDetailImageCollectionViewCell else { return UICollectionViewCell() }
        item.setImage(imageURL: viewModel.imageURLs[indexPath.item])
        return item
    }

}


// MARK: - CollectionView Delegate

extension SpotDetailViewController: UICollectionViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        spotDetailView.updatePageControl()
    }

}
