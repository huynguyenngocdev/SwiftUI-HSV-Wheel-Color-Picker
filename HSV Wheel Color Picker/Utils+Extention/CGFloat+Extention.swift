//
//  CGFloat+Extention.swift
//  HSV Wheel Color Picker
//
//  Created by Huy_NGUYEN on 03/07/2023.
//

import Foundation

public extension CGFloat {
    func map(from: ClosedRange<CGFloat>, to: ClosedRange<CGFloat>) -> CGFloat {
        let result = ((self - from.lowerBound) / (from.upperBound - from.lowerBound)) * (to.upperBound - to.lowerBound) + to.lowerBound
        return result
    }
}
