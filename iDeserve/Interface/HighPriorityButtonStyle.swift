//
//  HighPriorityButtonStyle.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/1/4.
//

import SwiftUI
import Foundation

//https://stackoverflow.com/questions/59401573/swiftui-button-inside-a-navigationlink

struct HighPriorityButtonStyle: PrimitiveButtonStyle {
    func makeBody(configuration: PrimitiveButtonStyle.Configuration) -> some View {
        MyButton(configuration: configuration)
    }
    
    private struct MyButton: View {
        @State var pressed = false
        let configuration: PrimitiveButtonStyle.Configuration
        
        var body: some View {
            let gesture = DragGesture(minimumDistance: 0)
                .onChanged { _ in self.pressed = true }
                .onEnded { value in
                    self.pressed = false
                    if value.translation.width < 10 && value.translation.height < 10 {
                        self.configuration.trigger()
                    }
                }
            
            return configuration.label
                .scaleEffect(self.pressed ? 0.8 : 1.0)
                .highPriorityGesture(gesture)
                .animation(.linear(duration: 0.1), value: self.pressed)
        }
    }
}
