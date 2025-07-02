//
//  ProfileModel.swift
//  ACON-iOS
//
//  Created by 김유림 on 2/8/25.
//

import UIKit

struct UserInfoModel: Equatable {
    
    var profileImage: String
    
    var nickname: String
    
    var birthDate: String?
    
    var savedSpotList: [SavedSpotModel]
    
}

struct SavedSpotModel: Equatable {
    
    let id: Int64
    
    var name: String
    
    var image: String?
    
}


struct UserInfoEditModel {
    
    var profileImage: String?
    
    var nickname: String
    
    var birthDate: String?
    
}


struct VerifiedAreaModel: Equatable {
    
    let id: Int64
    
    var name: String
    
}
