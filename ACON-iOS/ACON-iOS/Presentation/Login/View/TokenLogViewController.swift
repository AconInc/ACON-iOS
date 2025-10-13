//
//  TokenLogViewController.swift
//  ACON-iOS
//
//  Created by 김유림 on 10/11/25.
//

import UIKit

final class TokenLogViewController: BaseViewController {

    // MARK: - UI Properties

    private let textView = UITextView()
    private let clearButton = UIButton(type: .system)


    // MARK: - Life Cycles

    override func viewDidLoad() {
        super.viewDidLoad()

        addTarget()
        loadLogs()
    }

    // MARK: - UI Settings

    override func setHierarchy() {
        super.setHierarchy()

        view.addSubviews(clearButton, textView)
    }

    override func setLayout() {
        super.setLayout()

        clearButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.trailing.equalToSuperview().inset(ScreenUtils.horizontalInset)
        }

        textView.snp.makeConstraints {
            $0.top.equalTo(clearButton.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(12)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    override func setStyle() {
        super.setStyle()

        textView.do {
            $0.isEditable = false
            $0.font = .monospacedSystemFont(ofSize: 13, weight: .regular)
        }

        clearButton.setTitle("Clear Logs", for: .normal)
    }

    private func addTarget() {
        clearButton.addTarget(self, action: #selector(clearLogs), for: .touchUpInside)
    }

    @objc private func clearLogs() {
        TokenLogger.shared.clearLogs()
        loadLogs()
    }


    // MARK: - Helper

    private func loadLogs() {
        let logs = TokenLogger.shared.loadLogs().reversed()
        textView.text = logs.joined(separator: "\n\n")
    }

}
