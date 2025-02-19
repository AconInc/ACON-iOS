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
    
    lazy var authService: AuthService = AuthService()
    
    lazy var spotDetailService: SpotDetailService = SpotDetailService()
    
    lazy var localVerificationService: LocalVerificationService = LocalVerificationService()

    lazy var uploadService: UploadService = UploadService()
    
    lazy var onboardingService: OnboardingService = OnboardingService()
    
    lazy var spotListService = SpotListService()
    
    lazy var profileService = ProfileService()
    
    lazy var imageService = ImageService()
    
    lazy var withdrawalService = WithdrawalService()

}
