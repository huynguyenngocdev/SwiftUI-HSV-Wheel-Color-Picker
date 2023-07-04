//
//  ColorPicker.swift
//  HSV Wheel Color Picker
//
//  Created by Huy_NGUYEN on 04/07/2023.
//

import SwiftUI

struct PickerConfig {
    let minimumValue: CGFloat
    let maximumValue: CGFloat
    let totalValue: CGFloat
    let knobRadius: CGFloat
    let radius: CGFloat
    let lineWidth: CGFloat
}

enum HSVProperties {
    case hue
    case saturation
}

struct ColorPicker: View {
    @State private var angleValue: CGFloat = 0.0
    
    /// The RGB colour. Is a binding as it can change and the view will update when it does.
    @State private var rgbColour: RGB = RGB(r: 0, g: 1, b: 1)
    
    /// The hue value of the colour wheel
    @Binding private var hue: CGFloat
    
    /// The brightness/value of the colour wheel
    @Binding private var brightness: CGFloat
    
    /// The saturation of the colour wheel
    @Binding private var saturation: CGFloat
    
    /// The alpha of the colour wheel
    @Binding private var alpha: CGFloat
    
    let config: PickerConfig
    let controlType: HSVProperties
    
    init(radius: CGFloat = 125.0,
         knobRadius: CGFloat = 15.0,
         lineWidth: CGFloat = 10.0,
         rgbColour: RGB = RGB(r: 0, g: 1, b: 1),
         hue: Binding<CGFloat> = .constant(0),
         brightness: Binding<CGFloat> = .constant(1.0),
         saturation: Binding<CGFloat> = .constant(1.0),
         alpha: Binding<CGFloat> = .constant(1.0),
         controlType: HSVProperties
    ) {
        self.rgbColour = RGB(r: rgbColour.r,
                             g: rgbColour.g,
                             b: rgbColour.b)
        
        _hue = hue
        _brightness = brightness
        _saturation = saturation
        _alpha = alpha
        
        self.config = PickerConfig(minimumValue: 0.0,
                                   maximumValue: controlType == .hue ? 270.0 : 0.75,
                                   totalValue: controlType == .hue ? 360.0 : 1.0,
                                   knobRadius: knobRadius,
                                   radius: radius,
                                   lineWidth: lineWidth)
        
        self.controlType = controlType
        
        setUp()
    }
    
    public var body: some View {
        ZStack {
            if controlType == .hue {
                hueControllerView
            } else {
                saturationControllerView
            }
            
            ///Knob
            Circle()
                .fill(Color.white)
                .frame(width: config.lineWidth * 2,
                       height: config.lineWidth * 2)
                .offset(y: -config.radius)
                .rotationEffect(Angle.degrees(Double(angleValue)))
                .gesture(DragGesture(minimumDistance: 0.0)
                    .onChanged({ value in
                        change(location: value.location)
                    }))
        }.rotationEffect(.degrees(-135))
    }
    
    var hueControllerView: some View {
        //Create colors
        let colours: [Color] = {
            let hue = Array(0...270)
            return hue.map {
                Color(UIColor(hue: CGFloat($0) / 270,
                              saturation: saturation,
                              brightness: brightness,
                              alpha: alpha))
            }
        }()
        
        return Circle()
            .trim(from: 0, to: 0.75)
            .stroke(AngularGradient(gradient: Gradient(colors: colours),
                                    center: UnitPoint(x: 0.5, y: 0.5)),
                    style: StrokeStyle(
                        lineWidth: config.lineWidth,
                        lineCap: .round,
                        lineJoin: .round)
            )
            .frame(width: config.radius * 2,
                   height: config.radius * 2)
            .rotationEffect(.degrees(-90))
    }
    
    var saturationControllerView: some View {
        //Create colors
        let colours: [Color] = [
            Color(UIColor(hue: hue / 360,
                          saturation: 0.0,
                          brightness: brightness,
                          alpha: alpha)),
            Color(UIColor(hue: hue / 360,
                          saturation: 1.0,
                          brightness: brightness,
                          alpha: alpha))
        ]
        
        return Circle()
            .trim(from: 0, to: 0.75)
            .stroke(LinearGradient(colors: colours,
                                   startPoint: .topLeading,
                                   endPoint: .bottomTrailing),
                    style: StrokeStyle(
                        lineWidth: config.lineWidth,
                        lineCap: .round,
                        lineJoin: .round)
            )
            .frame(width: config.radius * 2,
                   height: config.radius * 2)
            .rotationEffect(.degrees(-90))
    }
}

// MARK: Handle logic
extension ColorPicker {
    private func change(location: CGPoint) {
        // creating vector from location point
        let vector = CGVector(dx: location.x, dy: location.y)
        
        // geting angle in radian need to subtract the knob radius and padding from the dy and dx
        let angle = atan2(vector.dy - (config.knobRadius + 10), vector.dx - (config.knobRadius + 10)) + .pi/2.0
        
        // convert angle range from (-pi to pi) to (0 to 2pi)
        let fixedAngle = angle < 0.0 ? angle + 2.0 * .pi : angle
        // convert angle value to temperature value
        let value = fixedAngle / (2.0 * .pi) * config.totalValue
        
        if value >= config.minimumValue && value <= config.maximumValue {
            if controlType == .hue {
                hue = value
            } else {
                saturation = 1 - (value * 4 / 3)
            }
            angleValue = fixedAngle * 180 / .pi // converting to degree
        }
    }
    
    private func setUp() {
        DispatchQueue.main.async {
            //Set up color for line circle
            self.rgbColour = HSV(h: self.rgbColour.hsv.h,
                                 s: self.rgbColour.hsv.s,
                                 v: self.brightness).rgb
        }
    }
}

struct ColorPicker_Previews: PreviewProvider {
    static var previews: some View {
        ColorPicker(controlType: .hue)
    }
}

