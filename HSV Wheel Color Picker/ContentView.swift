//
//  ContentView.swift
//  HSV Wheel Color Picker
//
//  Created by Huy_NGUYEN on 03/07/2023.
//
import SwiftUI

struct ContentView: View {
    @State var rgbColour = RGB(r: 0, g: 1, b: 1)
    @State var hue: CGFloat = 0
    @State var brightness: CGFloat = 1.0
    @State var saturation: CGFloat = 1.0
    @State var alpha: CGFloat = 1.0
    
    var body: some View {
        VStack {
            header.padding(12)
            currentColorView
            Spacer()
            colorControllerView
            Spacer()
            brightnessControllerView
            Spacer()
        }
        .background(.gray)
    }
    
    var header: some View {
        HStack {
            Text("HSV Wheel Color Picker")
                .font(.largeTitle)
                .padding(.top, 16)
            Spacer()
        }
    }
    
    var currentColorView: some View {
        HStack(spacing: 8) {
            Spacer()
            Text("Color: ")
                .font(.title2)
            Circle()
                .fill(Color(UIColor(hue: CGFloat(hue/360),
                                    saturation: saturation,
                                    brightness: brightness,
                                    alpha: alpha)))
                .frame(width: 32, height: 32)
            Spacer()
        }
    }
    
    var colorControllerView: some View {
        VStack(spacing: 30) {
            ///Saturation Controller
            ColorPicker(radius: 96,
                        knobRadius: 18.0,
                        lineWidth: 8.0,
                        rgbColour: rgbColour,
                        hue: $hue,
                        brightness: $brightness,
                        saturation: $saturation,
                        alpha: $alpha,
                        controlType: .saturation)
            ///Hue Controller
            ColorPicker(radius: 143,
                        knobRadius: 18.0,
                        lineWidth: 10.0,
                        rgbColour: rgbColour,
                        hue: $hue,
                        brightness: $brightness,
                        saturation: $saturation,
                        alpha: $alpha,
                        controlType: .hue)
        }
    }
    var brightnessControllerView: some View {
        VStack {
            HStack {
                Text("Brightness")
                Spacer()
            }.padding(.horizontal, 12)
            HStack() {
                BrightnessSlider(value: $brightness,
                                 range: 0...1)
                .frame(height: 32)
                ZStack {
                    Image(systemName: "circle.lefthalf.filled")
                        .resizable()
                        .frame(width: 12, height: 12)
                    Image(systemName: "sun.max")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
            }.padding(.horizontal, 18)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
