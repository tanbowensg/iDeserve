//
//  Popup.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/10/6.
//

import SwiftUI

struct Popup<Content: View>: View {
    @Binding var isVisible: Bool
    var content: Content
    var alignment: Alignment = .bottom

    var body: some View {
        if isVisible {
            ZStack(alignment: alignment) {
                Color.g10.opacity(0.001)
                    .onTapGesture {
                        withAnimation {
                            isVisible.toggle()
                        }
                    }
                content
            }
            .transition(
                AnyTransition.asymmetric(
                    insertion: .move(edge: .bottom),
                    removal: .move(edge: .bottom)
                ).animation(.spring())
            )
            .edgesIgnoringSafeArea(.vertical)
        }
    }
}
