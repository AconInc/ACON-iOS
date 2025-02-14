//
//  SettingViewModel.swift
//  ACON-iOS
//
//  Created by 이수민 on 2/13/25.
//

class SettingViewModel {
    
    var isLatestVersion: Bool = false
        
    func checkAppVersion(completion: @escaping () -> Void) {
        AppVersionManager.checkVersion { [weak self] isLatest in
            self?.isLatestVersion = isLatest
            completion()
        }
    }
    
}
