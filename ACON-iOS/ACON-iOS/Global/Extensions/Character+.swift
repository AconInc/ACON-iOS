//
//  Character+.swift
//  ACON-iOS
//
//  Created by 김유림 on 4/27/25.
//

import Foundation

extension Character {

    var isKorean: Bool {
        let koreanRanges = [
            0xAC00...0xD7A3,  // Hangul Syllables
            0x1100...0x11FF,  // Hangul Jamo
            0x3130...0x318F   // Hangul Compatibility Jamo
        ]

        guard let unicodeScalar = self.unicodeScalars.first else {
            print("❌ Character+ unicodeScalar failed")
            return false
        }

        return koreanRanges.contains { range in
            range.contains(Int(unicodeScalar.value))
        }
    }

}
