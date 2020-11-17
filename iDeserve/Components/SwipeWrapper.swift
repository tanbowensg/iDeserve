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
    @State var offset = CGSize.zero
    
    let actionWidth: Int = 100
    
    var slotOffset: CGFloat {
        return CGFloat(-self.actionWidth + Int(offset.width))
    }
    
    var contentOffset: CGFloat {
        return CGFloat(offset.width)
    }
    
    var customContent: some View {
        content
            .animation(.spring())
    }
    
    var leftAction: some View {
        Button(action: {
            print("哈哈哈")
        }) {
            Text("搞定")
        }
            .padding(.horizontal, 30.0)
            .frame(width: CGFloat(self.actionWidth), height: CGFloat(self.height))
            .foregroundColor(.g0)
            .background( Color.completeColor)
            .animation(.spring())
    }
    
    var gesture: some Gesture {
        DragGesture()
            .onChanged { value in
                self.offset = value.translation
            }
            .onEnded { value in
                self.offset = .zero
            }
    }

    var body: some View {
        ZStack(alignment: .leading) {
            leftAction
                .offset(x: slotOffset)
            customContent
                .offset(x: contentOffset)
        }
            .background(Color.completeColor)
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
