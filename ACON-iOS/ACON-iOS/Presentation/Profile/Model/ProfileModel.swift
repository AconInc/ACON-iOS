//
//  ProfileModel.swift
//  ACON-iOS
//
//  Created by 김유림 on 2/8/25.
//

import Foundation

struct UserInfoModel {
    
    var profileImageURL: String
    
    var nickname: String
    
    var birthDate: String?
    
    var verifiedAreaList: [VerifiedAreaModel]
    
    var possessingAcorns: Int
    
}

struct UserInfoEditModel {
    
    var profileImageURL: String
    
    var nickname: String
    
    var birthDate: String?
    
    var verifiedAreaList: [VerifiedAreaModel]
    
}


struct VerifiedAreaModel: Equatable {
    
    let id: Int
    
    var name: String
    
}
