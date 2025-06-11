//
//  SpotListViewModel.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/13/25.
//

import CoreLocation
import UIKit

class SpotListViewModel: Serviceable {
    
    // MARK: - Properties

    var onSuccessPostSpotList: ObservablePattern<Bool> = ObservablePattern(nil)

    var onFinishRefreshingSpotList: ObservablePattern<Bool> = ObservablePattern(nil)

    var errorType: SpotListErrorType? = nil

    var spotList = SpotListModel()
    
    var userCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    private var lastNetworkLocation: CLLocation?
    
    private let locationDistanceThreshold: Double = 1300
    
    private var userLocation: CLLocation = CLLocation(latitude: 0, longitude: 0)

    private var periodicLocationCheckTimer: Timer?
    
    var needToShowToast: ObservablePattern<Bool> = ObservablePattern(nil)

    // TODO: 삭제
    private var restaurantDummy: [SpotModel] = [
        SpotModel(id: 1, imageURL: nil, name: "이미지없는 식당", acornCount: 50, tagList: [.new, .local, .top(number: 1)], eta: 1, latitude: 35.785834, longitude: 128.25),
        SpotModel(id: 2, imageURL: "wrongAddress", name: "이미지에러", acornCount: 50, tagList: [.top(number: 2)], eta: 1, latitude: 35.785834, longitude: 128.25),
        SpotModel(id: 2, imageURL: "https://cdn.kmecnews.co.kr/news/photo/202311/32217_20955_828.jpg", name: "도토리 완전 많은 뷔페", acornCount: 102938, tagList: [.local, .top(number: 3)], eta: 6, latitude: 35.785834, longitude: 128.25),
        SpotModel(id: 3, imageURL: "https://images.immediate.co.uk/production/volatile/sites/30/2022/03/Pancake-grazing-board-bc15106.jpg?quality=90&resize=556,505", name: "팬케익맛집", acornCount: 938, tagList: [.top(number: 4)], eta: 13, latitude: 35.785834, longitude: 128.25),
        SpotModel(id: 4, imageURL: "https://natashaskitchen.com/wp-content/uploads/2020/03/Pan-Seared-Steak-4.jpg", name: "영웅스테이크", acornCount: 102938, tagList: [.local, .top(number: 5)], eta: 14, latitude: 35.785834, longitude: 128.25),
        SpotModel(id: 5, imageURL: "https://i.namu.wiki/i/oFHlYDjoEh8f-cc3lNK9jAemRkbXxNGwUg7XiW5LGS6DF1P2x8GCeNQxbQhVIwtUS1u53YPw-uoyqpmLtrGNJA.webp", name: "아콘삼겹살", acornCount: 1000, tagList: [.new], eta: 6, latitude: 35.785834, longitude: 128.25),
        SpotModel(id: 6, imageURL: "https://i.namu.wiki/i/dgjXU86ae29hDSCza-L0GZlFt3T9lRx1Ug9cKtqWSzMzs7Cd0CN2SzyLFEJcHVFviKcxAlIwxcllT9s2sck0RA.jpg", name: "아콘비빔밥", acornCount: 3, tagList: [], eta: 6, latitude: 35.785834, longitude: 128.25),
        SpotModel(id: 6, imageURL: "https://img.freepik.com/free-photo/cheesy-tokbokki-korean-traditional-food-black-board-background-lunch-dish_1150-42988.jpg?semt=ais_hybrid&w=740", name: "아콘떡볶이", acornCount: 3, tagList: [], eta: 6, latitude: 35.785834, longitude: 128.25),
        SpotModel(id: 6, imageURL: "https://lh3.googleusercontent.com/proxy/YPQ8wdYuCbfGjedd-TDueWJ3_bnly8lynR3LsrVdSy6BltN3ERoMyzizuUOifkJfbYgaTheo2n8pfacz9jPKCIRrHtrRo9TnBYpGwb2zflw", name: "아콘돈까스이름완전기이이이이이이이이이이이일어", acornCount: 3, tagList: [], eta: 6, latitude: 35.785834, longitude: 128.25),
        SpotModel(id: 6, imageURL: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSbCQpNp_DERSX-HITj7_CIsqSqic4Mg1Z6GQ&s", name: "아콘떡국", acornCount: 3, tagList: [], eta: 6, latitude: 35.785834, longitude: 128.25),
        SpotModel(id: 6, imageURL: "https://sm.ign.com/ign_kr/game/k/kirby-and-/kirby-and-the-forgotten-land_pk1v.jpg", name: "팟팅커비~!~!~!", acornCount: 3, tagList: [], eta: 6, latitude: 35.785834, longitude: 128.25)
    ]


    // MARK: - Filter

    var spotType: SpotType = .restaurant

    var filterList: [SpotFilterModel] = []


    // MARK: - Methods

    func updateLocationAndPostSpotList() {
        // 위치 권한 확인 및 업데이트 시작
        ACLocationManager.shared.addDelegate(self)
        ACLocationManager.shared.checkUserDeviceLocationServiceAuthorization()
    }
    
    func resetConditions() {
        filterList.removeAll()
    }
    
}


// MARK: - Networking

extension SpotListViewModel {

    func postSpotList() {
        let filterListDTO = filterList.map { filter in
            return SpotFilterDTO(category: filter.category.serverKey,
                                       optionList: filter.optionList)
        }
        
        let requestBody = PostSpotListRequest(
            latitude: userCoordinate.latitude,
            longitude: userCoordinate.longitude,
            condition: SpotConditionDTO(
                spotType: spotType.serverKey,
                filterList: filterList.isEmpty ? nil : filterListDTO
            )
        )
        
        self.spotList = SpotListModel(
            transportMode: self.spotType == .restaurant ? .walking : .biking,
            spotList: self.restaurantDummy
        )
        self.onSuccessPostSpotList.value = true

        // TODO: - 주석 해제 (실제 로직)
        // self.lastNetworkLocation = userLocation
        // TODO: - 삭제 (테스트용)
        self.lastNetworkLocation = CLLocation(latitude: 37.0, longitude: 127.00)
        
        return

//        ACService.shared.spotListService.postSpotList(requestBody: requestBody) { [weak self] response in
//            switch response {
//            case .success(let data):
//                let spotList: SpotListModel = SpotListModel(from: data)
//
//                self?.spotList = spotList
//
//                if spotList.spotList.isEmpty { self?.errorType = .emptyList }
//                self?.onSuccessPostSpotList.value = true
//
//            case .reIssueJWT:
//                self?.handleReissue { [weak self] in
//                    self?.postSpotList()
//                }
//
//            case .requestErr(let error):
//                print("🥑post spotList requestErr: \(error)")
//                if error.code == 40405 {
//                    self?.errorType = .unsupportedRegion
//                } else {
//                    self?.errorType = .serverRequestFail // TODO: 에러 뷰 또는 Alert 띄우기
//                }
//                self?.onSuccessPostSpotList.value = false
//
//            default:
//                print("🥑Failed To Post")
//// #if DEBUG
//                // TODO: 삭제
//                self?.spotList = SpotListModel(
//                    transportMode: self?.spotType == .restaurant ? .walking : .biking,
//                    spotList: self?.restaurantDummy ?? []
//                )
//                self?.onSuccessPostSpotList.value = true
//                return
//// #endif
//                // TODO: 주석 해제
////                self?.onSuccessPostSpotList.value = false
////                return
//            }
//        }
    }

    func postGuidedSpot(spotID: Int64) {
        ACService.shared.spotDetailService.postGuidedSpot(spotID: spotID){ [weak self] response in
            switch response {
            case .success:
                return
            case .reIssueJWT:
                self?.handleReissue { [weak self] in
                    self?.postGuidedSpot(spotID: spotID)
                }
            default:
                print("VM - Failed To postGuidedSpot")
                return
            }
        }
    }

}


// MARK: - ACLocationManagerDelegate

extension SpotListViewModel: ACLocationManagerDelegate {
    
    func locationManager(_ manager: ACLocationManager, didUpdateLocation location: CLLocation) {
        ACLocationManager.shared.removeDelegate(self)
        userLocation = location
        userCoordinate = location.coordinate
        postSpotList()
    }

}


// MARK: - 주기적 위치 체크

extension SpotListViewModel {
    
    func startPeriodicLocationCheck() {
        checkLocationChange()
        stopPeriodicLocationCheck()
        
        periodicLocationCheckTimer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            checkLocationChange()
        }
    }
    
    func stopPeriodicLocationCheck() {
        periodicLocationCheckTimer?.invalidate()
        periodicLocationCheckTimer = nil
    }
    
    func checkLocationChange() {
        guard let lastLocation = lastNetworkLocation else { return }
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        let hasToast = window.subviews.contains { $0 is ACToastView }
        guard !hasToast else { return }
        
        ACLocationManager.shared.checkUserDeviceLocationServiceAuthorization()
        guard let distance = lastNetworkLocation?.distance(from: userLocation) else { return }
        print("🧇 \(distance)")
        if distance >= locationDistanceThreshold {
            print("🧇 위치 변화 감지: \(distance)m")
            needToShowToast.value = true
        }
    }
    
}
