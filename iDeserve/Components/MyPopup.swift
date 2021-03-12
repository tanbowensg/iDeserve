//
//  Popup.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/10/6.
//

import SwiftUI

struct MyPopup<Content: View>: View {
    @Binding var isVisible: Bool
    var content: Content
    var alignment: Alignment = .bottom
    var background: Color? = .white

    var body: some View {
        ZStack(alignment: alignment) {
            if isVisible {
            Color.black.opacity(0.3)
                .onTapGesture {
                    isVisible.toggle()
                }

            content
                .padding(.bottom, alignment == .bottom ? BOTTOM_SAFE_AREA_HEIGHT : 0)
                .background(background)
//                    .background(Color.white.shadow(color: Color.g60, radius: 5))
        }
//            .transition(
//                AnyTransition.asymmetric(
//                    insertion: .move(edge: .bottom),
//                    removal: .move(edge: .bottom)
//                ).animation(.spring())
//            )
        }
        .edgesIgnoringSafeArea(.vertical)
    }
}
