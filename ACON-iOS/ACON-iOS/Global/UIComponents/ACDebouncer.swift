//
//  ACDebouncer.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/17/25.
//

import Foundation

final class ACDebouncer {
    
    private var timer: Timer?
    private let delay: TimeInterval
    private let queue: DispatchQueue

    init(delay: TimeInterval, queue: DispatchQueue = .main) {
        self.delay = delay
        self.queue = queue
    }

    func call(action: @escaping () -> Void) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { [weak self] _ in
            self?.queue.async {
                action()
            }
        }
    }
    
}
