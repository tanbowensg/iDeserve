//
//  CustomScrollView.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/12/3.
//

import SwiftUI

private struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct CustomScrollView<Content: View>: View {
    @EnvironmentObject var gs: GlobalStore
    let showsIndicators: Bool
    let onOffsetChange: (CGFloat) -> Void
    let content: Content

    init(
        showsIndicators: Bool = true,
        onOffsetChange: @escaping (CGFloat) -> Void = { _ in },
        @ViewBuilder content: () -> Content
    ) {
        self.showsIndicators = showsIndicators
        self.onOffsetChange = onOffsetChange
        self.content = content()
    }
    
    var body: some View {
        ScrollView(.vertical ,showsIndicators: showsIndicators) {
            GeometryReader { geometry in
                Color.clear.preference(
                    key: ScrollOffsetPreferenceKey.self,
                    value: geometry.frame(in: .named("scrollView")).minY
                )
                .onPreferenceChange(ScrollOffsetPreferenceKey.self, perform: {v in
                    NotificationCenter.default.post(name: NSNotification.onScroll, object: nil)
                    onOffsetChange(v)
                })
            }.frame(width: 0, height: 0)
            content
        }
        .coordinateSpace(name: "scrollView")
    }
}

struct CustomScrollView_Previews: PreviewProvider {
    static var previews: some View {
        CustomScrollView(
            showsIndicators: false,
            onOffsetChange: { print($0) }
        ) {
            ForEach(0..<100) { i in
                Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.")
            }
        }
    }
}
