//
//  ACService.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/20/25.
//

import Foundation

final class ACService {
    
    // MARK: - 싱글톤 패턴 사용
    
    static let shared = ACService()
    
    private init() {}
    
    lazy var testService: TestService = TestService()
    
//    lazy var authService: AuthService = AuthService()
    
    lazy var localVerificationService: LocalVerificationService = LocalVerificationService()
    
}
