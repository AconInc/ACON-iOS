//
//  CustomSlider.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/17/25.

import UIKit

protocol SliderViewDelegate: AnyObject {
    func sliderView(_ sender: CustomSlider, changedValue value: Int)
}

final class CustomSlider: BaseView {
    
    // MARK: - Basic Properties
    
    weak var delegate: SliderViewDelegate?
    
    override var intrinsicContentSize: CGSize {
        return .init(width: .zero, height: thumbSize)
    }
    
    lazy var value: Int = 0 {
        didSet {
            delegate?.sliderView(self, changedValue: value)
        }
    }
    
    
    //MARK: - UI Properties
    
    private let trackView = UIView()
    
    private let fillTrackView = UIView()
    
    private lazy var thumbView = WideTouchView()
    
    private var indicatorLabels: [UILabel] = [] // 라벨
    
    
    // MARK: - UI helping Properties
    
    private var indicators: [String]
    
    private var startIndex: Int
    
    private var touchBeganPosX: CGFloat?
    
    private var didLayoutSubViews: Bool = false // NOTE: 1번만 실행되도록
    
    private lazy var slicedPosX: CGFloat = 0 // layoutSubviews 단계에서 값 지정
    
    private let barHeight: CGFloat = 10
    
    private let thumbSize: CGFloat = 22
    
    private let labelWidth: CGFloat = 50
    
    
    // MARK: - LifeCycle
    
    init(indicators: [String], startIndex: Int) {
        self.indicators = indicators
        self.startIndex = startIndex
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setHierarchy() {
        self.addSubviews(
            trackView,
            fillTrackView,
            thumbView
        )
    }
    
    override func setLayout() {
        trackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(thumbSize / 2)
            $0.top.equalToSuperview()
            $0.height.equalTo(barHeight)
        }
        
        fillTrackView.snp.makeConstraints {
            $0.left.equalTo(trackView)
            $0.top.bottom.equalTo(trackView)
            $0.width.equalTo(0) // TODO: 레이아웃 노란경고 해결
        }
        
        thumbView.snp.makeConstraints {
            $0.centerY.equalTo(trackView)
            $0.left.equalTo(trackView)
            $0.size.equalTo(thumbSize)
        }
    }
    
    override func setStyle() {
        self.backgroundColor = .clear
        
        trackView.do {
            $0.backgroundColor = .gray8
            $0.layer.cornerRadius = barHeight / 2
        }
        
        fillTrackView.do {
            $0.backgroundColor = .mainOrg50
            $0.layer.cornerRadius = barHeight / 2
        }
        
        thumbView.do {
            $0.backgroundColor = .acWhite
            $0.isUserInteractionEnabled = true
            $0.layer.shadowColor = UIColor.gray.cgColor
            $0.layer.shadowOffset = .init(width: 0, height: 2)
            $0.layer.shadowRadius = 4
            $0.layer.shadowOpacity = 0.1
            
            addGestureRegocnizer()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateStyle()
    }
    
}


// MARK: - Late UI Settings

private extension CustomSlider {
    
    func updateStyle() {
        if !didLayoutSubViews {
            setIndicators()
            
            thumbView.layer.cornerRadius = thumbView.frame.width / 2
            
            // TODO: 그림자 수정
            thumbView.layer.shadowPath = UIBezierPath(
                roundedRect: thumbView.bounds,
                cornerRadius: thumbView.layer.cornerRadius
            ).cgPath
            
            resetThumbPosition()
        }
    }
    
}


// MARK: - Public Methods

extension CustomSlider {
    
    /// 슬라이더 초기 위치로 이동
    func resetThumbPosition(animated: Bool = true) {
        guard startIndex >= 0,
              startIndex < indicators.count
        else {
            print("‼️ 슬라이더 초기화 파라미터 값 수정 필요‼️ startIndex 구간: 0 - \(indicators.count - 1) 사이")
            return
        }
        
        let targetPosX = slicedPosX * CGFloat(startIndex) - (thumbSize / 2)
        
        // NOTE: thumb 이동
        if animated {
            UIView.animate(withDuration: 0.3, animations: {
                self.updateThumbPosition(to: targetPosX)
                self.layoutIfNeeded()
            })
        } else {
            self.updateThumbPosition(to: targetPosX)
        }
        
        // NOTE: value 업데이트
        self.value = startIndex
    }
    
}


// MARK: - Helpers

private extension CustomSlider {
    
    func setIndicators() {
        self.slicedPosX = trackView.frame.width / CGFloat(indicators.count - 1)
        
        for (i, text) in indicators.enumerated() {
            let alignment: NSTextAlignment = {
                if i == 0 { return .left }
                else if i == indicators.count - 1 { return .right }
                else { return .center }
            }()
            
            let posX = slicedPosX * CGFloat(i)
            
            let label = makeIndicatorLabel(text, alignment: alignment)
            
            addSubview(label)
            
            if i == 0 {
                label.snp.makeConstraints {
                    $0.leading.equalTo(trackView).offset(-thumbSize / 2)
                }
            } else if i == indicators.count - 1 {
                label.snp.makeConstraints {
                    $0.trailing.equalTo(trackView).offset(thumbSize / 2)
                }
            } else {
                label.snp.makeConstraints {
                    $0.centerX.equalTo(trackView.snp.left).offset(posX)
                }
            }
            
            label.snp.makeConstraints {
                $0.top.equalTo(trackView).offset(20)
                $0.width.equalTo(labelWidth)
                $0.bottom.equalToSuperview()
            }
        }
        
        didLayoutSubViews.toggle()
    }
    
    func makeIndicatorLabel(_ text: String, alignment: NSTextAlignment) -> UILabel {
        let label = UILabel().then {
            $0.setLabel(text: text, style: .c1, color: .gray4, alignment: alignment)
        }
        return label
    }
    
    func addGestureRegocnizer() {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        thumbView.addGestureRecognizer(gesture)
    }
    
    // NOTE: 슬라이더 포인터 위치 업데이트
    func updateThumbPosition(to position: CGFloat) {
        thumbView.snp.updateConstraints {
            $0.left.equalTo(trackView).offset(position)
        }

        fillTrackView.snp.updateConstraints {
            $0.width.equalTo(position + (thumbSize / 2))
        }
    }
    
}


//MARK: - @objc functions

extension CustomSlider {
    
    @objc
    func handlePan(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: thumbView)
        
        if recognizer.state == .began {
            // 팬 제스쳐가 시작된 x좌표 저장
            touchBeganPosX = thumbView.frame.minX
        }
        
        if recognizer.state == .changed {
            guard let startX = self.touchBeganPosX else { return }
            
            var offSet = startX + translation.x // 시작지점 + 제스쳐 거리 = 현재 제스쳐 좌표
            if offSet < 0 || offSet > trackView.frame.width { return } // 제스쳐가 trackView의 범위를 벗어나는 경우 무시
            let slicedPosX = trackView.frame.width / CGFloat(indicators.count - 1) // maxValue를 기준으로 trackView를 n등분
            
            // value = 반올림(현재 제스쳐 좌표 / 1단위의 크기) -> 슬라이더의 값이 변할 때마다 똑똑 끊기는 효과를 주기 위해
            let newValue = round(offSet / slicedPosX)
            offSet = slicedPosX * newValue - (thumbSize / 2)
            
            thumbView.snp.updateConstraints {
                $0.left.equalTo(trackView).offset(offSet)
            }
            
            fillTrackView.snp.updateConstraints {
                $0.width.equalTo(offSet)
            }
            
            value = Int(newValue)
        }
    }
    
}
