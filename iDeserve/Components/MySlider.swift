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
        ValueSlider(value: $value, in: range, step: 1)
            .valueSliderStyle(
                HorizontalValueSliderStyle(
                    track: Color.hospitalGreen.frame(height: 5).cornerRadius(3),
                    thumb: Circle().foregroundColor(.hospitalGreen),
                    thumbSize: CGSize(width: 20, height: 20),
                    thumbInteractiveSize: CGSize(width: 20, height: 20)
                )
            )
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
