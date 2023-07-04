//
//  BrightnessSlider.swift
//  HSV Wheel Color Picker
//
//  Created by Huy_NGUYEN on 04/07/2023.
//

import SwiftUI

struct BrightnessSlider: View {
    @Binding var value: CGFloat
    @State var lastCoordinateValue: CGFloat = 0.0
    
    var range: ClosedRange<Double>
    var thumbColor: Color = .yellow
    
    public var body: some View {
        GeometryReader { gr in
            let thumbSize = 32.0
            let radius = 32.0
            let minValue = gr.size.width * 0.015 - 20
            let maxValue = (gr.size.width * 0.98) - thumbSize + 22
            
            let scaleFactor = (maxValue - minValue) / (range.upperBound - range.lowerBound)
            let lower = range.lowerBound
            let sliderVal = (self.value - lower) * scaleFactor + minValue
            
            ZStack {
                /// Line
                Rectangle()
                    .foregroundColor(.white.opacity(0.2))
                    .frame(width: gr.size.width, height: 2)
                    .clipShape(RoundedRectangle(cornerRadius: radius))
                HStack {
                    Rectangle()
                        .foregroundColor(.white)
                        .frame(width: abs(sliderVal + 16), height: 2)
                    Spacer()
                }
                .clipShape(RoundedRectangle(cornerRadius: radius))
                /// Thumb
                HStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: thumbSize, height: thumbSize)
                        .offset(x: sliderVal)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { v in
                                    if (abs(v.translation.width) < 0.1) {
                                        self.lastCoordinateValue = sliderVal
                                    }
                                    if v.translation.width > 0 {
                                        let nextCoordinateValue = min(maxValue, self.lastCoordinateValue + v.translation.width)
                                        self.value = ((nextCoordinateValue - minValue) / scaleFactor)  + lower
                                    } else {
                                        let nextCoordinateValue = max(minValue, self.lastCoordinateValue + v.translation.width)
                                        self.value = ((nextCoordinateValue - minValue) / scaleFactor) + lower
                                    }
                                }
                        )
                    Spacer()
                }
            }
        }
    }
}
