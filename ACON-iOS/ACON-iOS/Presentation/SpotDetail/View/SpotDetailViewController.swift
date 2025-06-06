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

    init(_ spotID: Int64, _ tagList: [SpotTagType]) {
        self.viewModel = SpotDetailViewModel(spotID, tagList)

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
        self.setMoreButton()
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
                self?.spotDetailView.makeSignatureMenuSection(data.signatureMenuList)
                self?.spotDetailView.collectionView.reloadData()
            } else {
                self?.showDefaultAlert(title: "장소 정보 로드 실패", message: "장소 정보 로드에 실패했습니다.")
            }
#if DEBUG
            self?.spotDetailView.collectionView.reloadData() // TODO: 삭제하고 다른 UI 설정
#endif
        }
    }

}


// MARK: - @objc methods

private extension SpotDetailViewController {

    @objc
    func tappedFindCourseButton() {
        AmplitudeManager.shared.trackEventWithProperties(AmplitudeLiterals.EventName.mainMenu, properties: ["click_detail_navigation?": true])

        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.do { [weak self] in
            guard let self = self,
                  let spot = viewModel.spotDetail.value else { return }
            $0.addAction(UIAlertAction(title: StringLiterals.Map.naverMap, style: .default, handler: { _ in
                MapRedirectManager.shared.redirect(
                    to: MapRedirectModel(name: spot.name, latitude: spot.latitude, longitude: spot.longitude),
                    using: .naver)
                self.viewModel.postGuidedSpot()
            }))
            $0.addAction(UIAlertAction(title: StringLiterals.Map.appleMap, style: .default, handler: { _ in
                MapRedirectManager.shared.redirect(
                    to: MapRedirectModel(name: spot.name, latitude: spot.latitude, longitude: spot.longitude),
                    using: .apple)
                self.viewModel.postGuidedSpot()
            }))
            $0.addAction(UIAlertAction(title: StringLiterals.Alert.cancel, style: .cancel, handler: nil))
        }
        present(alertController, animated: true)
    }

    @objc
    func tappedMenuButton() {
        let vc = MenuImageSlideViewController(viewModel.menuImageURLs)
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }

}


// MARK: - CollectionView DataSource

extension SpotDetailViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.spotDetail.value?.imageURLs.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = collectionView.dequeueReusableCell(withReuseIdentifier: SpotDetailImageCollectionViewCell.cellIdentifier, for: indexPath) as? SpotDetailImageCollectionViewCell else { return UICollectionViewCell() }
        if let imageURLs = viewModel.spotDetail.value?.imageURLs {
            item.setImage(imageURL: imageURLs[indexPath.item])
        }
        return item
    }

}


// MARK: - CollectionView Delegate

extension SpotDetailViewController: UICollectionViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        spotDetailView.updatePageControl()
    }

}
