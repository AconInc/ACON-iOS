//
//  PutImageToPresignedURLRequest.swift
//  ACON-iOS
//
//  Created by 이수민 on 2/19/25.
//

import UIKit

struct PutImageToPresignedURLRequest: Encodable {

    let presignedURL: String

    let imageData: Data

    let fileName: String

}
