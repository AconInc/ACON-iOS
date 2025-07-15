//
//  SpotUploadViewController.swift
//  ACON-iOS
//
//  Created by 김유림 on 7/16/25.
//

import UIKit

final class SpotUploadViewController: BaseNavViewController {

    // MARK: - UI Properties

    private var pageVC = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .vertical)

    private let spotUploadView = SpotUploadView()


    // MARK: - Properties

    private var pages: [UIViewController] = [SpotTypeSelectionViewController(), SpotSortSelectionViewController(questionText: "2번", numberOfLines: 10)]

    private var currentIndex: Int = 0


    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        addTarget()
        bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)

        self.tabBarController?.tabBar.isHidden = true
    }


    // MARK: - UI Setting

    override func setHierarchy() {
        super.setHierarchy()

        self.contentView.addSubview(spotUploadView)
        self.addChild(pageVC)

        spotUploadView.addSubview(pageVC.view)

        pageVC.didMove(toParent: self)
    }

    override func setLayout() {
        super.setLayout()

        spotUploadView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        pageVC.view.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(spotUploadView.nextButton.snp.top).offset(-10)
        }
    }

    override func setStyle() {
        super.setStyle()

        setXButton()
        
        self.setCenterTitleLabelStyle(title: StringLiterals.SpotUpload.spotUpload)

        pageVC.setViewControllers([pages[0]], direction: .forward, animated: false, completion: nil)

        // NOTE: 내부 스와이프 막기
        for subview in pageVC.view.subviews {
            if let scrollView = subview as? UIScrollView {
                scrollView.isScrollEnabled = false
            }
        }
    }

    private func addTarget() {
        spotUploadView.previousButton.addTarget(self,
                                                action: #selector(goToPreviousPage),
                                                for: .touchUpInside)

        spotUploadView.nextButton.addTarget(self,
                                            action: #selector(goToNextPage),
                                            for: .touchUpInside)
    }

}


// MARK: - bindViewModel

private extension SpotUploadViewController {

    func bindViewModel() {
        
    }

}


// MARK: - @objc functions

private extension SpotUploadViewController {

    @objc private func goToPreviousPage() {
        guard currentIndex > 0 else { return }
        currentIndex -= 1
        pageVC.setViewControllers([pages[currentIndex]], direction: .reverse, animated: true, completion: nil)
    }

    @objc private func goToNextPage() {
        guard currentIndex < pages.count - 1 else { return }
        currentIndex += 1
        pageVC.setViewControllers([pages[currentIndex]], direction: .forward, animated: true, completion: nil)
    }

}
