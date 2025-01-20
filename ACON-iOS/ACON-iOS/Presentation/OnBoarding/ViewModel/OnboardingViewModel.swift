//
//  OnboardingViewModel.swift
//  ACON-iOS
//
//  Created by Jaehyun Ahn on 1/15/25.
//

import Foundation

final class OnboardingViewModel {
    
    var dislike: ObservablePattern<[String]> = ObservablePattern([])
    
    var favoriteCuisne: ObservablePattern<[String]> = ObservablePattern([])
    
    var favoriteSpotType: ObservablePattern<String> = ObservablePattern(nil)
    
    var favoriteSpotStyle: ObservablePattern<String> = ObservablePattern(nil)
    
    var favoriteSpotRank: ObservablePattern<[String]> = ObservablePattern([])
    
    func onbaordingNewworking() {
        
        let onboardingData = OnboardingDTO(dislikeFoodList: dislike.value ?? [""],
                                             favoriteCuisineRank: favoriteCuisne.value ?? [""],
                                             favoriteSpotType: favoriteSpotType.value ?? "",
                                             favoriteSpotStyle: favoriteSpotStyle.value ?? "",
                                             favoriteSpotRank: favoriteSpotRank.value ?? [""])
        
        print(onboardingData)
        
        // NOTE: i will change this code
        ACService.shared.onboardingService.postOnboarding(onboardingData: onboardingData) { [weak self] result in
                  guard let self = self else { return }
                  
                  // 3. 요청 결과 처리
                  switch result {
                  case .success:
                      print("🎉 성공: 온보딩 완료!")
                      // 성공 처리 로직 추가
                      self.handleOnboardingSuccess()
                      
                  case .requestErr(let errorResponse):
                      print("❌ 요청 에러: \(errorResponse.message)")
                      self.showError(message: errorResponse.message)
                      
                  case .decodedErr:
                      print("❌ 디코딩 에러")
                      self.showError(message: "서버 응답 처리 중 오류가 발생했습니다.")
                      
                  case .serverErr:
                      print("❌ 서버 에러")
                      self.showError(message: "서버 오류가 발생했습니다.")
                      
                  case .networkFail:
                      print("❌ 네트워크 실패")
                      self.showError(message: "네트워크 연결을 확인해주세요.")
                      
                  case .reIssueJWT:
                      print("❌ 토큰 재발급 필요")
                      self.handleTokenReIssue()
                  case .pathErr:
                      print("NONE")
                  }
              }
          }
          
          // 성공 처리 메서드
          private func handleOnboardingSuccess() {
              print("✅ 온보딩 성공 처리")
              // 성공 후 로직 (예: 화면 전환)
          }
          
          // 에러 메시지 표시 메서드
          private func showError(message: String) {
              print("⚠️ 에러: \(message)")
              // 사용자에게 에러를 알리는 UI 처리
          }
          
          // 토큰 재발급 처리 메서드
          private func handleTokenReIssue() {
              print("🔄 토큰 재발급 처리 중...")
              // 토큰 재발급 및 재요청 로직 추가
          }
      }
