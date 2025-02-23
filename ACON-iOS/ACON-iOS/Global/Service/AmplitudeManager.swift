//
//  AmplitudeManager.swift
//  ACON-iOS
//
//  Created by 이수민 on 2/21/25.
//

import Foundation

import AmplitudeSwift

final class AmplitudeManager {
    
    static let shared = AmplitudeManager()
    
    private var amplitude: Amplitude?
    
    private init() {}
    
    func initialize() {
        let amplitudeApiKey = Config.amplitudeKey
        let config = Configuration(apiKey: amplitudeApiKey)
        config.logLevel = .DEBUG
        amplitude = Amplitude(configuration: config)
    }
    
    func setUserID(_ userID: String) {
        amplitude?.setUserId(userId: userID)
    }
    
    func getUserID() -> String {
        guard let userID = amplitude?.getUserId() else { return "" }
        return userID
    }
    
    // NOTE: - 기존 사용자와 세션을 초기화
    func reset() {
        amplitude?.reset()
        amplitude?.setSessionId(date: Date.now)
    }
    
    // NOTE: - 프로퍼티가 있는 이벤트 트래킹
    func trackEventWithProperties(_ event: String, properties: [String: Any]) {
        let event = BaseEvent(
            callback: { (event: BaseEvent, code: Int, message: String) -> Void in
                print("eventCallback: \(event.eventType), code: \(code), message: \(message)")
            },
            eventType: event,
            eventProperties: properties)
        self.amplitude?.track(event: event)
    }
    
    // NOTE: - 유저 프로퍼티 세팅
    func setUserProperty(userProperties: [String: Any]) {
        amplitude?.identify(userProperties: userProperties)
    }
    
}
