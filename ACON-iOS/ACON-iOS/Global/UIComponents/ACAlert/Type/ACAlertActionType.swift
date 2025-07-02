//
//  CustomAlertActions.swift
//  ACON-iOS
//
//  Created by 이수민 on 5/20/25.
//

import UIKit

class ACAlertActionType {
    
    // NOTE: - 알럿에 자주 사용되는 액션 클로저
    
    static let openSettings = {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString),
              UIApplication.shared.canOpenURL(settingsURL) else { return }
        UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
    }
    
}
