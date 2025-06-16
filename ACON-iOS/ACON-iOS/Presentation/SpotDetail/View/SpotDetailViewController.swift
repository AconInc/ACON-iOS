//
//  SpotDetailViewController.swift
//  ACON-iOS
//
//  Created by 김유림 on 5/13/25.
//

import UIKit

class SpotDetailViewController: BaseNavViewController {

    // MARK: - Properties

    private let viewModel: SpotDetailViewModel

    private var topTag: SpotTagType?
    private var transportMode: TransportModeType?
    private var eta: Int?

    private var startTime: Date?

    private var timer: Timer?


    // MARK: - UI Properties

    private let spotDetailView = SpotDetailView()


    // MARK: - LifeCycle

    init(
        _ spotID: Int64,
        _ topTag: SpotTagType? = nil,
        _ transportMode: TransportModeType? = nil,
        _ eta: Int? = nil
    ) {
        self.viewModel = SpotDetailViewModel(spotID)
        self.topTag = topTag
        self.transportMode = transportMode
        self.eta = eta

        super.init(nibName: nil, bundle: nil)
    }

    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setDelegate()
        registerCell()
        setButtonAction()
        bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)

        self.tabBarController?.tabBar.isHidden = true

        viewModel.getSpotDetail()
        viewModel.getMenuboardImageList()
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


    // MARK: - UI Settings

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

    private func setButtonAction() {
        spotDetailView.findCourseButton.addTarget(self,
                                                  action: #selector(tappedFindCourseButton),
                                                  for: .touchUpInside)

        spotDetailView.menuButton.onTap = { [weak self] _ in
            guard let self = self else { return }
            let vc = MenuImageSlideViewController(viewModel)

            if viewModel.menuImageURLs.isEmpty {
                viewModel.getMenuboardImageList()
            }
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
        }

        spotDetailView.bookmarkButton.onTap = { [weak self] isSelected in
            guard let self = self else { return }
            isSelected ? viewModel.postSavedSpot() : viewModel.deleteSavedSpot()
        }

        spotDetailView.shareButton.onTap = { [weak self] _ in
            guard let self = self else { return }
            viewModel.createBranchDeepLink()
        }
    }

}


// MARK: - bindViewModel

private extension SpotDetailViewController {

    func bindViewModel() {
        self.viewModel.onSuccessGetSpotDetail.bind { [weak self] onSuccess in
            guard let onSuccess,
                  let self = self,
                  let data = viewModel.spotDetail else { return }
            if onSuccess {
                var tagList: [SpotTagType] = []
                if let topTag { tagList.append(topTag) }
                if let tags = data.tagList { tagList.append(contentsOf: tags) }
                
                spotDetailView.bindData(data)
                setTagsAndOpeningTime(tags: tagList,
                                      isOpen: data.isOpen,
                                      closingTime: data.closingTime,
                                      nextOpening: data.nextOpening)
                spotDetailView.setFindCourseButton(transportMode, eta)
                spotDetailView.makeSignatureMenuSection(data.signatureMenuList)
                spotDetailView.menuButton.isEnabled = data.hasMenuboardImage
                spotDetailView.collectionView.reloadData()
            } else {
                showDefaultAlert(title: "장소 정보 로드 실패", message: "장소 정보 로드에 실패했습니다.")
            }
            viewModel.onSuccessGetSpotDetail.value = nil
        }

        self.viewModel.onSuccessPostSavedSpot.bind { [weak self] onSuccess in
            guard let onSuccess,
                  let self = self else { return }
            spotDetailView.bookmarkButton.isSelected = onSuccess
            viewModel.onSuccessPostSavedSpot.value = nil
        }

        self.viewModel.onSuccessDeleteSavedSpot.bind { [weak self] onSuccess in
            guard let onSuccess,
                  let self = self else { return }
            spotDetailView.bookmarkButton.isSelected = !onSuccess
            viewModel.onSuccessPostSavedSpot.value = nil
        }
    }

}


// MARK: - Helper

private extension SpotDetailViewController {

    func setTagsAndOpeningTime(tags: [SpotTagType], isOpen: Bool, closingTime: String, nextOpening: String) {
        let time: String = isOpen ? closingTime : nextOpening
        let description = isOpen ? StringLiterals.SpotList.businessEnd : StringLiterals.SpotList.businessStart

        spotDetailView.setTagStackView(tags: tags)
        spotDetailView.setOpeningTimeView(isOpen: isOpen, time: time, description: description, hasTags: !tags.isEmpty)
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
                  let spot = viewModel.spotDetail else { return }
            $0.addAction(UIAlertAction(title: StringLiterals.Map.naverMap, style: .default, handler: { _ in
                MapRedirectManager.shared.redirect(
                    to: MapRedirectModel(name: spot.name, latitude: spot.latitude, longitude: spot.longitude),
                    mapType: .naver,
                    transportMode: self.transportMode ?? .publicTransit)
                self.viewModel.postGuidedSpot()
            }))
            $0.addAction(UIAlertAction(title: StringLiterals.Map.appleMap, style: .default, handler: { _ in
                MapRedirectManager.shared.redirect(
                    to: MapRedirectModel(name: spot.name, latitude: spot.latitude, longitude: spot.longitude),
                    mapType: .apple,
                    transportMode: self.transportMode ?? .publicTransit)
                self.viewModel.postGuidedSpot()
            }))
            $0.addAction(UIAlertAction(title: StringLiterals.Alert.cancel, style: .cancel, handler: nil))
        }
        present(alertController, animated: true)
    }

}


// MARK: - CollectionView DataSource

extension SpotDetailViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.spotDetail?.imageURLs?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = collectionView.dequeueReusableCell(withReuseIdentifier: SpotDetailImageCollectionViewCell.cellIdentifier, for: indexPath) as? SpotDetailImageCollectionViewCell else { return UICollectionViewCell() }
        if let imageURLs = viewModel.spotDetail?.imageURLs {
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
