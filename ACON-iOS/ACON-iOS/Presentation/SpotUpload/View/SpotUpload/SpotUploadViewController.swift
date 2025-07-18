//
//  SpotUploadViewController.swift
//  ACON-iOS
//
//  Created by 김유림 on 7/16/25.
//

import UIKit

final class SpotUploadViewController: BaseNavViewController {

    // MARK: - Properties

    private let viewModel = SpotUploadViewModel()

    lazy var pages: [UIViewController] = [SpotUploadSearchViewController(viewModel), SpotTypeSelectionViewController(viewModel)]

    private var currentIndex: Int = 0


    // MARK: - UI Properties

    private var pageVC = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .vertical)

    private let spotUploadView = SpotUploadView()


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
        viewModel.isPreviousButtonEnabled.bind { [weak self] isEnabled in
            guard let isEnabled else { return }
            self?.spotUploadView.previousButton.updateGlassButtonState(state: isEnabled ? .default : .disabled)
            self?.viewModel.isPreviousButtonEnabled.value = nil
        }

        viewModel.isNextButtonEnabled.bind { [weak self] isEnabled in
            guard let isEnabled else { return }
            self?.spotUploadView.nextButton.updateGlassButtonState(state: isEnabled ? .default : .disabled)
            self?.viewModel.isNextButtonEnabled.value = nil
        }
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
