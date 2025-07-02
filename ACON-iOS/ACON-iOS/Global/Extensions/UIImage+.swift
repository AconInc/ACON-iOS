//
//  UIImage+.swift
//  ACON-iOS
//
//  Created by 김유림 on 5/4/25.
//

import UIKit

extension UIImage {

    /// 이미지의 크기를 지정한 사이즈로 리사이징합니다.
    func resize(to targetSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }

}


// MARK: - 색상 추출

extension UIImage {

    /// 이미지의 가장자리에서 가장 많이 사용되는 색상을 추출합니다.
    func mostFrequentBorderColor(
        width: CGFloat = SpotListItemSizeType.itemMaxWidth.value,
        height: CGFloat = SpotListItemSizeType.itemMaxHeight.value,
        scaleFactor: CGFloat = 0.3,
        sampleDensity: Int = 10
    ) -> UIColor? {
        guard let cgImage = self.cgImage else { return nil }

        let scaledWidth = Int(width * scaleFactor)
        let scaledHeight = Int(height * scaleFactor)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * scaledWidth
        let bitsPerComponent = 8

        var pixelData = [UInt8](repeating: 0, count: scaledWidth * scaledHeight * bytesPerPixel)

        guard let context = CGContext(
            data: &pixelData,
            width: scaledWidth,
            height: scaledHeight,
            bitsPerComponent: bitsPerComponent,
            bytesPerRow: bytesPerRow,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) else { return nil }

        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: scaledWidth, height: scaledHeight))

        var colorCounts: [Int: Int] = [:]

        let stepX = max(1, scaledWidth / sampleDensity)
        for x in stride(from: 0, to: scaledWidth, by: stepX) {
            addPixelColor(x: x, y: 0, width: scaledWidth, height: scaledHeight, pixelData: pixelData, colorCounts: &colorCounts)
            addPixelColor(x: x, y: scaledHeight - 1, width: scaledWidth, height: scaledHeight, pixelData: pixelData, colorCounts: &colorCounts)
        }

        let stepY = max(1, scaledHeight / sampleDensity)
        for y in stride(from: 0, to: scaledHeight, by: stepY) {
            addPixelColor(x: 0, y: y, width: scaledWidth, height: scaledHeight, pixelData: pixelData, colorCounts: &colorCounts)
            addPixelColor(x: scaledWidth - 1, y: y, width: scaledWidth, height: scaledHeight, pixelData: pixelData, colorCounts: &colorCounts)
        }

        return getMostFrequentColor(from: colorCounts)
    }

    private func addPixelColor(
        x: Int,
        y: Int,
        width: Int,
        height: Int,
        pixelData: [UInt8],
        colorCounts: inout [Int: Int]
    ) {
        guard x >= 0, x < width, y >= 0, y < height else { return }

        let index = (y * width + x) * 4
        guard index + 3 < pixelData.count else { return }

        let r = pixelData[index] >> 3
        let g = pixelData[index + 1] >> 3
        let b = pixelData[index + 2] >> 3

        let colorKey = (Int(r) << 10) | (Int(g) << 5) | Int(b)
        colorCounts[colorKey, default: 0] += 1
    }

    private func getMostFrequentColor(from colorCounts: [Int: Int]) -> UIColor? {
        guard let (colorKey, _) = colorCounts.max(by: { $0.value < $1.value }) else { return nil }

        let r = CGFloat((colorKey >> 10) & 0x1F) / 31.0
        let g = CGFloat((colorKey >> 5) & 0x1F) / 31.0
        let b = CGFloat(colorKey & 0x1F) / 31.0

        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }

}
