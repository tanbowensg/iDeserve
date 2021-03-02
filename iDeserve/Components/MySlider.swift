//
//  MySlider.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/3/2.
//

import SwiftUI
import Sliders

struct MySlider: View {
    @Binding var value: Int
    var range: ClosedRange<Int>

    var body: some View {
        VStack(spacing: 2.0) {
            ValueSlider(value: $value, in: range, step: 1)
                .valueSliderStyle(
                    HorizontalValueSliderStyle(
                        track: Color.hospitalGreen.frame(height: 4).cornerRadius(2),
                        thumbSize: CGSize(width: 10, height: 10),
                        thumbInteractiveSize: CGSize(width: 10, height: 10)
                    )
                )
            Text(String(value)).font(.avenirBlack12)
        }
    }
}

struct SliderPreviewWrapper: View {
    @State var value = 1
    
    var body: some View {
        MySlider(value: $value, range: 1...10)
    }
}

struct MySlider_Previews: PreviewProvider {
    static var previews: some View {
        SliderPreviewWrapper()
    }
}
