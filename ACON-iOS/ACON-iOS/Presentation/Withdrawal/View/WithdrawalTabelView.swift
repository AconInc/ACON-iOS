//
//  WithdrawalTabelView.swift
//  ACON-iOS
//
//  Created by Jaehyun Ahn on 2/17/25.
//

import UIKit

import SnapKit
import Then
  
    final class WithdrawalCollectionView: UICollectionView {
        
        var selectedSpotType: String = " " {
            didSet {
                reloadData()
                print(selectedSpotType)
                onSelectionChanged?(selectedSpotType)
            }
        }
        
        var onSelectionChanged: ((String) -> Void)?
        
        init() {
            super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
            setStyle()
            setDelegate()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func setStyle() {
            backgroundColor = .clear
            showsVerticalScrollIndicator = false
        }
        
        private func setDelegate() {
            delegate = self
            dataSource = self
            register(
                WithdrawalCollectionViewCell.self,
                forCellWithReuseIdentifier: BaseCollectionViewCell.cellIdentifier
            )
        }
        
    }

    extension WithdrawalCollectionView: UICollectionViewDelegateFlowLayout {
        
        func collectionView(
            _ collectionView: UICollectionView,
            layout collectionViewLayout: UICollectionViewLayout,
            sizeForItemAt indexPath: IndexPath
        ) -> CGSize {
            let itemWidth = ScreenUtils.width
            return CGSize(width: itemWidth, height: 24)
        }
        
        func collectionView(
            _ collectionView: UICollectionView,
            layout collectionViewLayout: UICollectionViewLayout,
            minimumLineSpacingForSectionAt section: Int
        ) -> CGFloat {
            return 20
        }
        
        func collectionView(
            _ collectionView: UICollectionView,
            layout collectionViewLayout: UICollectionViewLayout,
            minimumInteritemSpacingForSectionAt section: Int
        ) -> CGFloat {
            return 20
        }
        
        func collectionView(
            _ collectionView: UICollectionView,
            layout collectionViewLayout: UICollectionViewLayout,
            insetForSectionAt section: Int
        ) -> UIEdgeInsets {
            let horizontalInset = ScreenUtils.width * 16 / 360
            let verticalInset = ScreenUtils.width * 33 / 780
            return UIEdgeInsets(
                top: verticalInset,
                left: horizontalInset,
                bottom: 0,
                right: horizontalInset
            )
        }
        
    }

    extension WithdrawalCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
        
        func collectionView(
            _ collectionView: UICollectionView,
            numberOfItemsInSection section: Int
        ) -> Int {
            return WithdrawalType.allCases.count
        }
        
        func collectionView(
            _ collectionView: UICollectionView,
            cellForItemAt indexPath: IndexPath
        ) -> UICollectionViewCell {
            guard let cell = dequeueReusableCell(
                withReuseIdentifier: BaseCollectionViewCell.cellIdentifier,
                for: indexPath
            ) as? WithdrawalCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            let option = WithdrawalType.allCases[indexPath.row]
            let isSelected = selectedSpotType == option.mappedValue
            cell.checkConfigure(name: option.name, isSelected: isSelected)
            return cell
        }
        
        func collectionView(
            _ collectionView: UICollectionView,
            didSelectItemAt indexPath: IndexPath
        ) {
            let selectedOption = WithdrawalType.allCases[indexPath.row]
            
            if selectedSpotType == selectedOption.mappedValue {
                selectedSpotType = ""
            } else {
                selectedSpotType = selectedOption.mappedValue
            }
        }
        
    }
//
//import UIKit
//import SnapKit
//import Then
//
//final class WithdrawalTableView: UITableView {
//    
//    var selectedSpotType: String = " " {
//        didSet {
//            reloadData()
//            print(selectedSpotType)
//            onSelectionChanged?(selectedSpotType)
//        }
//    }
//    
//    var onSelectionChanged: ((String) -> Void)?
//    
//    init() {
//        super.init(frame: .zero, style: .plain)
//        setStyle()
//        setDelegate()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func setStyle() {
//        backgroundColor = .clear
//        separatorStyle = .none // 구분선 제거 (필요시 .singleLine 등으로 변경 가능)
//        showsVerticalScrollIndicator = false
//    }
//    
//    private func setDelegate() {
//        delegate = self
//        dataSource = self
//        register(WithdrawalTableViewCell.self, forCellReuseIdentifier: WithdrawalTableViewCell.cellIdentifier)
//    }
//}
//
//extension WithdrawalTableView: UITableViewDelegate, UITableViewDataSource {
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return WithdrawalType.allCases.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = dequeueReusableCell(
//            withIdentifier: WithdrawalTableViewCell.cellIdentifier,
//            for: indexPath
//        ) as? WithdrawalTableViewCell else {
//            return UITableViewCell()
//        }
//        
//        let option = WithdrawalType.allCases[indexPath.row]
//        let isSelected = selectedSpotType == option.mappedValue
//        cell.configure(name: option.name, isSelected: isSelected)
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 50 // 셀의 높이 설정
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let selectedOption = WithdrawalType.allCases[indexPath.row]
//        
//        if selectedSpotType == selectedOption.mappedValue {
//            selectedSpotType = ""
//        } else {
//            selectedSpotType = selectedOption.mappedValue
//        }
//    }
//}
