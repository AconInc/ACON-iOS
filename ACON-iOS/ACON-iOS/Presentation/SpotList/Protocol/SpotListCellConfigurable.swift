//
//  SpotListCellConfigurable.swift
//  ACON-iOS
//
//  Created by 김유림 on 5/29/25.
//

import Foundation

protocol SpotListCellConfigurable {

    func bind(spot: SpotModel)
    func setTags(tags: [SpotTagType])
    func overlayLoginLock(_ show: Bool)
    func setFindCourseDelegate(_ delegate: SpotListCellDelegate?)

}
