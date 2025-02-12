//
//  ProfileModel.swift
//  ACON-iOS
//
//  Created by 김유림 on 2/8/25.
//

import UIKit

struct UserInfoModel {
    
    var profileImageURL: String
    
    var nickname: String
    
    var birthDate: String?
    
    var verifiedAreaList: [VerifiedAreaModel]
    
    var possessingAcorns: Int
    
}


struct VerifiedAreaModel: Equatable {
    
    let id: Int
    
    var name: String
    
}

struct SettingCellModel: Equatable {
    
    let image: UIImage?
    
    let title: String
    
}
