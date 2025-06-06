//
//  PatchProfileRequest.swift
//  ACON-iOS
//
//  Created by 김유림 on 2/19/25.
//

import Foundation

struct PatchProfileRequest: Encodable {

    let profileImage: String?

    let nickname: String

    let birthDate: String?

    enum CodingKeys: CodingKey {
        case profileImage, nickname, birthDate
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.profileImage, forKey: .profileImage)
        try container.encode(self.nickname, forKey: .nickname)
        try container.encodeIfPresent(self.birthDate, forKey: .birthDate)
    }

}
