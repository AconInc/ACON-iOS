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
    
    var selectedSpotType: String = "" {
        didSet {
            reloadData()
            onSelectionChanged?(selectedSpotType)
        }
    }
    
    var onSelectionChanged: ((String) -> Void)?
    
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
    
}

extension WithdrawalTableView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WithdrawalType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = dequeueReusableCell(
            withIdentifier: WithdrawalTableViewCell.cellIdentifier,
            for: indexPath
        ) as? WithdrawalTableViewCell else {
            return UITableViewCell()
        }
        
        let option = WithdrawalType.allCases[indexPath.row]
        let isSelected = selectedSpotType == option.mappedValue
        cell.checkConfigure(name: option.name, isSelected: isSelected)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedOption = WithdrawalType.allCases[indexPath.row]
        
        if selectedSpotType == selectedOption.mappedValue {
            selectedSpotType = ""
        } else {
            selectedSpotType = selectedOption.mappedValue
        }
        viewModel?.updateSelectedOption(selectedSpotType)
    }
    
}
