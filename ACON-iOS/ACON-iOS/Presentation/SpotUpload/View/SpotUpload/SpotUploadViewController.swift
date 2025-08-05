//
//  SpotUploadViewController.swift
//  ACON-iOS
//
//  Created by 김유림 on 7/16/25.
//

import UIKit

final class SpotUploadViewController: BaseNavViewController {

    // MARK: - Properties

    let viewModel = SpotUploadViewModel()

    lazy var pages: [UIViewController] = [searchVC, spotTypeVC, restaurantFeatureVC, menuVC, valueRatingVC, photoVC]

    private var currentIndex: Int = 0


    // MARK: - UI Properties

    private var pageVC = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .vertical)

    // NOTE: 글래스모피즘 깜빡임 이슈로 일반 버튼으로 구현
    let previousButton = UIButton()
    let nextButton = UIButton()

    // NOTE: inquiry pages
    lazy var searchVC = SpotUploadSearchViewController(viewModel)
    lazy var spotTypeVC = SpotTypeSelectionViewController(viewModel)
    lazy var restaurantFeatureVC = RestaurantFeatureSelectionViewController(viewModel)
    lazy var cafeFeatureVC = CafeFeatureSelectionViewController(viewModel)
    lazy var menuVC = MenuRecommendationViewController(viewModel)
    lazy var valueRatingVC = ValueRatingViewController(viewModel)
    lazy var photoVC = SpotUploadPhotoViewController(viewModel)


    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        addTarget()
        bindViewModel()
        setDelegate()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)

        self.tabBarController?.tabBar.isHidden = true
    }


    // MARK: - UI Setting

    override func setHierarchy() {
        super.setHierarchy()
        
        self.addChild(pageVC)

        self.contentView.addSubviews(previousButton, nextButton, pageVC.view)

        pageVC.didMove(toParent: self)
    }

    override func setLayout() {
        super.setLayout()
        
        previousButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(ScreenUtils.horizontalInset)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(44)
            $0.width.equalTo(120 * ScreenUtils.widthRatio)
        }
        
        nextButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-ScreenUtils.horizontalInset)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(44)
            $0.width.equalTo(200 * ScreenUtils.widthRatio)
        }

        pageVC.view.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(nextButton.snp.top).offset(-10)
        }
    }

    override func setStyle() {
        super.setStyle()

        setXButton(#selector(navigateToTabBar))
        
        self.setCenterTitleLabelStyle(title: StringLiterals.SpotUpload.spotUpload)

        pageVC.setViewControllers([pages[0]], direction: .forward, animated: false, completion: nil)

        let glassDefaultColor = UIColor(red: 0.255, green: 0.255, blue: 0.255, alpha: 1)
        previousButton.do {
            $0.setAttributedTitle(text:  StringLiterals.SpotUpload.goPrevious, style: .b1SB)
            $0.setAttributedTitle(text:  StringLiterals.SpotUpload.goPrevious, style: .b1SB, color: .gray500, for: .disabled)
            $0.layer.borderColor = glassDefaultColor.cgColor
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = 22
        }

        nextButton.do {
            $0.setAttributedTitle(text: StringLiterals.SpotUpload.next, style: .b1SB)
            $0.setAttributedTitle(text:  StringLiterals.SpotUpload.next, style: .b1SB, color: .gray500, for: .disabled)
            $0.backgroundColor = glassDefaultColor
            $0.layer.cornerRadius = 22
        }
    }

    private func setDelegate() {
        photoVC.delegate = self
    }

    private func addTarget() {
        previousButton.addTarget(self,
                                 action: #selector(goToPreviousPage),
                                 for: .touchUpInside)

        nextButton.addTarget(self,
                             action: #selector(goToNextPage),
                             for: .touchUpInside)
    }

}


// MARK: - bindViewModel

private extension SpotUploadViewController {

    func bindViewModel() {
        viewModel.isPreviousButtonEnabled.bind { [weak self] isEnabled in
            guard let isEnabled else { return }
            self?.previousButton.isEnabled = isEnabled
            self?.viewModel.isPreviousButtonEnabled.value = nil
        }

        viewModel.isNextButtonEnabled.bind { [weak self] isEnabled in
            guard let isEnabled else { return }
            self?.nextButton.isEnabled = isEnabled
            self?.viewModel.isNextButtonEnabled.value = nil
        }
    }

}


// MARK: - @objc functions

private extension SpotUploadViewController {

    @objc func navigateToTabBar() {
        NavigationUtils.navigateToTabBar()
    }

    @objc func goToPreviousPage() {
        guard currentIndex > 0 else { return }
        currentIndex -= 1
        pageVC.setViewControllers([pages[currentIndex]], direction: .reverse, animated: true, completion: nil)
    }

    @objc func goToNextPage() {
        let lastIndex = pages.count - 1

        if currentIndex == 1 { // NOTE: spot type 선택
            setSpotFeaturePage()
        }

        if currentIndex < lastIndex {
            currentIndex += 1
            pageVC.setViewControllers([pages[currentIndex]], direction: .forward, animated: true, completion: nil)
        } else if currentIndex == lastIndex {
            let successVC = SpotUploadSuccessViewController()
            self.navigationController?.pushViewController(successVC, animated: true)
        }
    }

}


// MARK: - SpotUploadPhotoViewControllerDelegate

extension SpotUploadViewController: SpotUploadPhotoViewControllerDelegate {

    func pushAlbumTableVC() {
        let vm = AlbumViewModel(.spotUpload)
        vm.maxPhotoCount = 10 - viewModel.photos.count

        let albumVC = AlbumTableViewController(vm)

        self.navigationController?.pushViewController(albumVC, animated: true)
    }

}


// MARK: - Helper

private extension SpotUploadViewController {

    func setSpotFeaturePage() {
        pages.remove(at: 2)
        pages.insert(viewModel.spotType == .restaurant ? restaurantFeatureVC : cafeFeatureVC, at: 2)
    }

}
