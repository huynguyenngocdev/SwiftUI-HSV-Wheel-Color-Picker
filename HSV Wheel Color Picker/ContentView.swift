//
//  ContentView.swift
//  HSV Wheel Color Picker
//
//  Created by Huy_NGUYEN on 03/07/2023.
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

public struct HueControlView: View {
    @State private var hue: CGFloat = 0.0
    @State private var angleValue: CGFloat = 0.0
    
    /// The RGB colour. Is a binding as it can change and the view will update when it does.
    @State private var rgbColour: RGB = RGB(r: 0, g: 1, b: 1)
    
    /// The brightness/value of the colour wheel
    @State private var brightness: CGFloat
    
    let config: PickerConfig
    let path: UIBezierPath
    let shapeLayer = CAShapeLayer()
    
    let colours: [Color] = {
        let hue = Array(0...269)
        return hue.map {
            Color(UIColor(hue: CGFloat($0) / 269,
                          saturation: 1,
                          brightness: 1,
                          alpha: 1))
        }
    }()
    
    public init(radius: CGFloat = 125.0,
                knobRadius: CGFloat = 15.0,
                lineWidth: CGFloat = 10.0,
                rgbColour: RBGModel = RBGModel(r: 0, g: 1, b: 1),
                brightness: CGFloat = 1.0
    ) {
        self.rgbColour = RGB(r: rgbColour.r,
                             g: rgbColour.g,
                             b: rgbColour.b)
        
        self.brightness = brightness
        
        self.config = PickerConfig(minimumValue: 0.0,
                                   maximumValue: 270.0,
                                   totalValue: 360.0,
                                   knobRadius: knobRadius,
                                   radius: radius,
                                   lineWidth: lineWidth
        )
        self.path = .init(ovalIn: CGRect(x: 0,
                                         y: 0,
                                         width: knobRadius * 2,
                                         height: knobRadius * 2))
        self.setUp()
    }
    
    public var body: some View {
        return ZStack {
            ZStack {
                ///Background
                Circle()
                    .frame(width: config.radius * 2,
                           height: config.radius * 2)
                    .scaleEffect(1.2)
                ///Color line
                Circle()
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
                ///Knob
                ZStack(alignment: .center) {
                    DrawingView(layer: shapeLayer)
                        .frame(width: config.knobRadius * 2,
                               height: config.knobRadius * 2)
                    Circle()
                        .fill(Color.white)
                        .frame(width: config.knobRadius * 1.2,
                               height: config.knobRadius * 1.2)
                        .opacity(0.5)
                    Circle()
                        .fill(Color.white)
                        .frame(width: config.lineWidth,
                               height: config.lineWidth)
                }
                .padding(10)
                .offset(y: -config.radius)
                .rotationEffect(Angle.degrees(Double(angleValue)))
                .gesture(DragGesture(minimumDistance: 0.0)
                    .onChanged({ value in
                        change(location: value.location)
                    }))
            }.rotationEffect(.degrees(-45))
            
            Text("\(String.init(format: "%.0f", hue))")
                .font(.system(size: 60))
                .foregroundColor(Color(UIColor(hue: CGFloat(hue/360),
                                               saturation: 1,
                                               brightness: 1,
                                               alpha: 1)))
        }
    }
}

// MARK: Handle logic
extension HueControlView {
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
            hue = value
            angleValue = fixedAngle * 180 / .pi // converting to degree
        }
    }
    
    private func setUp() {
        DispatchQueue.main.async {
            //Set up color for line circle
            self.rgbColour = HSV(h: self.rgbColour.hsv.h,
                                 s: self.rgbColour.hsv.s,
                                 v: self.brightness).rgb
            
            //set up for knob
            shapeLayer.path             = path.cgPath
            shapeLayer.fillColor        = UIColor.clear.cgColor
            shapeLayer.strokeColor      = UIColor.white.cgColor
            shapeLayer.lineWidth        = 1.5
            shapeLayer.shadowOpacity    = 0.9
            shapeLayer.shadowColor      = UIColor.white.cgColor
            shapeLayer.shadowOffset     = .zero
            shapeLayer.shadowRadius     = 5.0
            shapeLayer.shadowPath = path.cgPath.copy(strokingWithWidth: 5,
                                                     lineCap: .round,
                                                     lineJoin: .round,
                                                     miterLimit: 0)
        }
    }
}

struct DrawingView: UIViewRepresentable {
    
    let view = UIView()
    let layer: CAShapeLayer
    
    func makeUIView(context: Context) -> UIView {
        view.layer.addSublayer(layer)
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) { }
}

struct DetailControlView_Previews: PreviewProvider {
    static var previews: some View {
        HueControlView()
    }
}
