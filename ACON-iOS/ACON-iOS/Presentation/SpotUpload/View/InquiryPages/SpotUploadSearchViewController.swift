//
//  SpotUploadSearchViewController.swift
//  ACON-iOS
//
//  Created by 김유림 on 7/16/25.
//

import UIKit

class SpotUploadSearchViewController: BaseUploadInquiryViewController {

    // MARK: - UI Properties

    private let textField = ACTextField(icon: .icSearch,
                                        borderWidth: 0,
                                        cornerRadius: 10,
                                        backgroundGlassType: .textfieldGlass)


    // MARK: - Properties

    override var contentViews: [UIView] {
        [textField]
    }

    override var canGoPrevious: Bool { false }

    override var canGoNext: Bool {
        guard let spotName = viewModel.spotName else { return false }
        return !spotName.isEmpty
    }


    // MARK: - init

    init(_ viewModel: SpotUploadViewModel) {
        super.init(viewModel: viewModel,
                   requirement: .required,
                   title: StringLiterals.SpotUpload.SearchThePlaceToRegister)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        bindObservable()
    }


    // MARK: - UI Setting

    override func setLayout() {
        super.setLayout()

        let sizeType = SpotUploadSizeType.TextField.self
        textField.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(sizeType.horizontalInset)
            $0.height.equalTo(sizeType.height)
        }
    }

    override func setStyle() {
        super.setStyle()

        self.hideKeyboard()

        if let spotName = viewModel.spotName,
           !spotName.isEmpty{
            textField.text = spotName
        }
    }

}


// MARK: - bindings

private extension SpotUploadSearchViewController {

    func bindObservable() {
        textField.observableText.bind { [weak self] text in
            guard let text else { return }
            self?.viewModel.spotName = text
            self?.updatePagingButtonStates()
        }
    }

}
