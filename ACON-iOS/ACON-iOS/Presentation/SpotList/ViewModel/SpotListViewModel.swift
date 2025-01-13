//
//  SpotListViewModel.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/13/25.
//

import Foundation

class SpotListViewModel {
    
    // MARK: - Properties
    
    var isFirstPage: ObservablePattern<Bool> = ObservablePattern(true)
    
    private var givenSpotList: ObservablePattern<[Spot]> = ObservablePattern(Spots.dummy)
    
    var firstSpotList: [Spot] = []
    var secondSpotList: [Spot] = []
    
    
    // MARK: - Methods
    
    init() {
        givenSpotList.bind { [weak self] spotList in
            guard let self = self,
                  let spotList = spotList else { return }
            
            splitSpotList(spotList)
        }
    }
    
    // TODO: 서버와 논의 후 변경 예정
    private func splitSpotList(_ spotList: [Spot]) {
        firstSpotList = Array(spotList.prefix(2))
        secondSpotList = Array(spotList.dropFirst(2))
    }
    
}
