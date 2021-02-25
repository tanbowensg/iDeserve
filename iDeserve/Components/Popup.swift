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
    var background: Color = .white

    var body: some View {
        if isVisible {
            ZStack(alignment: alignment) {
                Color.black.opacity(0.1)
                    .onTapGesture {
                        withAnimation {
                            isVisible.toggle()
                        }
                    }
                    .animation(.none)
                
                content
                    .padding(.bottom, alignment == .bottom ? BOTTOM_SAFE_AREA_HEIGHT : 0)
//                    .padding(.top, 20)
//                    .background(background)
//                    .background(Color.white.shadow(color: Color.g60, radius: 5))
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
