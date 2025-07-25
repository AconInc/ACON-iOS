//
//  WithdrawalTabelView.swift
//  ACON-iOS
//
//  Created by Jaehyun Ahn on 2/17/25.
//

import UIKit

import SnapKit
import Then

final class WithdrawalTableView: UITableView {
    
    var viewModel: WithdrawalViewModel?
    
    private let options = [
        StringLiterals.Withdrawal.optionLackOfRestaurants,
        StringLiterals.Withdrawal.optionUnsatisfiedRecommendation,
        StringLiterals.Withdrawal.optionFakeReviews,
        StringLiterals.Withdrawal.optionOthers
    ]
    
    private var selectedOption: String? {
        didSet {
            reloadData()
        }
    }
    
    init() {
        super.init(frame: .zero, style: .plain)
        
        setStyle()
        setDelegate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStyle() {
        backgroundColor = .clear
        separatorStyle = .none
        showsVerticalScrollIndicator = false
        isScrollEnabled = false
    }
    
    private func setDelegate() {
        delegate = self
        dataSource = self
        register(WithdrawalTableViewCell.self, forCellReuseIdentifier: WithdrawalTableViewCell.cellIdentifier)
    }
    
    func handleSelection(at indexPath: IndexPath) {
        let option = options[indexPath.row]
        selectedOption = option
        viewModel?.updateSelectedOption(selectedOption)
        
        (superview?.superview as? WithdrawalViewController)?.updateButtonState()
    }
    
}

extension WithdrawalTableView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 36*ScreenUtils.heightRatio
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = dequeueReusableCell(withIdentifier: WithdrawalTableViewCell.cellIdentifier, for: indexPath) as? WithdrawalTableViewCell else {
            return UITableViewCell()
        }
        
        let option = options[indexPath.row]
        let isSelected = selectedOption == option
        
        cell.checkConfigure(name: option, isSelected: isSelected)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? WithdrawalTableViewCell {
            cell.selectButtonTapped()
            self.handleSelection(at: indexPath)
        }
    }
    
}
