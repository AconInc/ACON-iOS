//
//  DayOfMonthType.swift
//  ACON-iOS
//
//  Created by 김유림 on 2/9/25.
//

import Foundation

enum DayOfMonthType: Int, CaseIterable {
    
    case january = 1, february, march, april, may, june, july, august, september, october, november, december
    
    /// 월별 기본 일 수 (윤년 고려 X)
    var defaultDays: Int {
        switch self {
        case .january, .march, .may, .july, .august, .october, .december:
            return 31
        case .april, .june, .september, .november:
            return 30
        case .february:
            return 28 // NOTE: 기본 28일 (윤년 계산은 별도 처리)
        }
    }
    
    /// 윤년을 고려한 해당 월의 최대 일 수 반환
    func days(in year: Int) -> Int {
        if self == .february && isLeapYear(year) {
            return 29
        }
        return defaultDays
    }
    
    // NOTE:  윤년 판단 함수
    private func isLeapYear(_ year: Int) -> Bool {
        return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)
    }
    
}
