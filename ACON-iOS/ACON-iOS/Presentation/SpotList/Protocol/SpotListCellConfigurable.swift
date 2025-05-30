//
//  SpotListCellConfigurable.swift
//  ACON-iOS
//
//  Created by 김유림 on 5/29/25.
//

import Foundation

protocol SpotListCellConfigurable {

    func bind(spot: SpotModel)
    func showLoginCell(_ show: Bool)

}
