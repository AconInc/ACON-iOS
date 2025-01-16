//
//  CustomSlider.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/17/25.
//

import UIKit

class CustomSlider: BaseView {
    
    // MARK: - Properties
    
    private var stepTexts: [String]
    private lazy var steps: [CGFloat] = divideHundred(by: stepTexts.count)
    
    private let trackView = UIView()  // 슬라이더 배경
    private let fillView = UIView()  // 채워지는 부분
    private let thumbView = UIView() // 손잡이
    private var labels: [UILabel] = [] // 라벨
    private let labelStackView = UIStackView()
    
    private var currentValue: CGFloat = 0 // 현재 값
    
    
    // MARK: - Initializer
    
    init(range: [String]) {
        super.init(frame: .zero)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setHierarchy() {
        self.addSubviews(trackView,
                         fillView,
                         thumbView,
                         labelStackView)
    }
    
    override func setLayout() {
        super.setLayout()
        
        // 레이아웃 설정
        trackView.snp.makeConstraints {
            $0.height.equalTo(10)
            $0.top.equalToSuperview().offset(6)
            $0.horizontalEdges.equalToSuperview().inset(7)
        }
        
        fillView.snp.makeConstraints {
            $0.leading.verticalEdges.equalTo(trackView)
            $0.width.equalTo(0)
        }
        
        // 손잡이 위치 초기화
        let thumbSize: CGFloat = 22
        let thumbX = positionForValue(currentValue)
        
        thumbView.snp.makeConstraints {
            $0.size.equalTo(thumbSize)
            $0.leading.equalToSuperview().offset(thumbX - thumbSize / 2)
            $0.centerY.equalTo(trackView)
        }
        
        // 라벨 위치 설정
        labelStackView.snp.makeConstraints {
            $0.top.equalTo(trackView.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    override func setStyle() {
        // 배경 뷰 설정
        trackView.do {
            $0.backgroundColor = .gray8
            $0.layer.cornerRadius = 8
        }
        
        // 채워지는 뷰 설정
        fillView.do {
            $0.backgroundColor = .mainOrg50
            $0.layer.cornerRadius = 8
        }
        
        // 손잡이 설정
        thumbView.do {
            $0.backgroundColor = .acWhite
            $0.layer.cornerRadius = 11
            $0.layer.shadowColor = UIColor.acBlack.cgColor
            $0.layer.shadowOpacity = 0.1
            $0.layer.shadowOffset = CGSize(width: 0, height: 2)
        }
        
        // 라벨 생성
        for value in stepTexts {
            let label = UILabel()
            label.setLabel(
                text: value,
                style: .c1,
                color: .gray4
            )
            labels.append(label)
            labelStackView.addArrangedSubview(label)
        }
        
        // 제스처 추가
        let panGesture = UIPanGestureRecognizer(
            target: self,
            action: #selector(handlePan(_:)))
        thumbView.addGestureRecognizer(panGesture)
    }
    
}


// MARK: - @objc function

private extension CustomSlider {
    
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        let thumbCenterX = thumbView.center.x + translation.x
        let clampedX = max(trackView.frame.minX, min(thumbCenterX, trackView.frame.maxX))
        
        // 현재 값 계산
        let percentage = (clampedX - trackView.frame.minX) / trackView.frame.width
        let nearestValue = nearestSnapValue(percentage * 100)
        currentValue = nearestValue
        
        // 레이아웃 업데이트
        gesture.setTranslation(.zero, in: self)
        setNeedsLayout()
    }
    
}


// MARK: - Helper
private extension CustomSlider {
    
    func divideHundred(by number: Int) -> [CGFloat] {
        guard number > 0 else { return [] }
        
        let step = 100 / number
        return (0...number).map { CGFloat($0 * step) }
    }
    
    private func positionForValue(_ value: CGFloat) -> CGFloat {
        let percentage = value / 100
        return trackView.frame.minX + percentage * trackView.frame.width
    }
    
    private func nearestSnapValue(_ value: CGFloat) -> CGFloat {
        return values.min(by: { abs($0 - value) < abs($1 - value) }) ?? 0
    }
    
}
