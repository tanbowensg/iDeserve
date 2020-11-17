//
//  SwipeWrapper.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/11/17.
//

import SwiftUI

struct SwipeWrapper<Content: View>: View {
    var content: Content
    var height: Int
    var onRelease: (() -> Void)?

    @State var offsetX = 0
    
    let slotWidth: Int = 100
    
    var slotOffset: CGFloat {
        return CGFloat(-self.slotWidth + Int(offsetX))
    }
    
    var contentOffset: CGFloat {
        return CGFloat(offsetX)
    }
    
    var customContent: some View {
        content
            .animation(.default)
    }
    
    var leftAction: some View {
        Button(action: {
            print("哈哈哈")
        }) {
            Text("搞定")
        }
            .padding(.horizontal, 30.0)
            .frame(width: CGFloat(self.slotWidth), height: CGFloat(self.height))
            .foregroundColor(.g0)
            .background( Color.completeColor)
            .animation(.default)
    }
    
    var gesture: some Gesture {
        DragGesture()
            .onChanged { value in
                self.offsetX = max(0, Int(value.translation.width))
            }
            .onEnded { value in
                if self.offsetX > self.slotWidth {
                    self.onRelease?()
                }
                self.offsetX = .zero
            }
    }

    var body: some View {
        ZStack(alignment: .leading) {
            leftAction
                .offset(x: slotOffset)
            customContent
                .offset(x: contentOffset)
        }
//        这是为了方式在删除元素的时候出现背景色
            .background(offsetX != 0 ? Color.completeColor : nil)
            .gesture(gesture)
    }
}

struct SwipeWrapper_Previews: PreviewProvider {
    static var previews: some View {
        let content =
            HStack {
                Text("Hello, World!")
                Spacer()
            }
                .frame(height: 100)
                .background(Color.yellow)

        SwipeWrapper(content: content, height: 100)
    }
}
