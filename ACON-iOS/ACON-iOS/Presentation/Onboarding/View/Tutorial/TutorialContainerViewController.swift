//
//  TutorialContainerViewController.swift
//  ACON-iOS
//
//  Created by 김유림 on 8/21/25.
//

import UIKit

class TutorialContainerViewController: BaseViewController {

    // MARK: - Properties

    lazy var pages: [UIViewController] = [localReviewVC, onlyFiftySpotsVC, startNowVC]

    private var currentIndex: Int = 0


    // MARK: - UI Properties

    private var pageVC = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    private let pageControl = UIPageControl()

    // NOTE: tutorial pages
    lazy var localReviewVC = ReviewTutorialViewController()
    lazy var onlyFiftySpotsVC = LimitedSpotsTutorialViewController()
    lazy var startNowVC = StartNowViewController()


    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

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

        view.addSubviews(pageVC.view, pageControl)

        pageVC.didMove(toParent: self)
    }

    override func setLayout() {
        super.setLayout()

        pageVC.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        pageControl.snp.makeConstraints {
            $0.centerY.equalTo(view.safeAreaLayoutGuide.snp.top).offset(28 * ScreenUtils.heightRatio)
            $0.centerX.equalToSuperview()
        }
    }

    override func setStyle() {
        super.setStyle()

        pageVC.setViewControllers([pages[0]], direction: .forward, animated: false, completion: nil)

        pageControl.do {
            $0.numberOfPages = pages.count
            $0.currentPage = 0
            $0.pageIndicatorTintColor = .gray300
            $0.currentPageIndicatorTintColor = .acWhite
            $0.isUserInteractionEnabled = false
        }
        
    }

    private func setDelegate() {
        pageVC.dataSource = self
        pageVC.delegate = self
    }

}


// MARK: - DataSource

extension TutorialContainerViewController: UIPageViewControllerDataSource {

    // NOTE: 이전 페이지
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        guard currentIndex > 0 else { return nil }
        return pages[currentIndex - 1]
    }

    // NOTE: 다음 페이지
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        guard currentIndex < pages.count - 1 else { return nil }
        return pages[currentIndex + 1]
    }

}


// MARK: - UIPageViewControllerDelegate

extension TutorialContainerViewController: UIPageViewControllerDelegate {

    // NOTE: transition 시작될 때 pageControl 이동
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        guard let upcomingVC = pendingViewControllers.first,
              let upcomingIndex = pages.firstIndex(of: upcomingVC) else { return }

        pageControl.currentPage = upcomingIndex
    }

    // NOTE: transition 취소됐을 때 pageControl 이동
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if !completed {
            guard let currentVC = pageViewController.viewControllers?.first,
                  let currentIndex = pages.firstIndex(of: currentVC) else { return }

            pageControl.currentPage = currentIndex
        }
    }

}
