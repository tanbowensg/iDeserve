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
    var onLeftSwipe: (() -> Void)?
    var onRightSwipe: (() -> Void)?

    @State var offsetX = 0

    let slotWidth: Int = 300
    let threshold: Int = 100
    
//    左右的背景颜色
    let leftSlotBg = Color.hospitalGreen
    let rightSlotBg = Color.red
    
    var alignment: Alignment {
        if (offsetX <= 0) {
            return .trailing
        } else {
            return .leading
        }
    }
    
//    已经达到了出发操作的阈值
    var isReachThreshold: Bool {
        return abs(offsetX) >= threshold
    }

    var leftSlotOffset: CGFloat {
        return CGFloat(-self.slotWidth + Int(offsetX))
    }
    
    var rightSlotOffset: CGFloat {
        return CGFloat(self.slotWidth + Int(offsetX))
    }

    var contentOffset: CGFloat {
        return CGFloat(offsetX)
    }
    
    var customContent: some View {
        content
    }
    
    var background: some View {
        return offsetX > 0 ? leftSlotBg : rightSlotBg
    }

    var leftSlot: some View {
        Image(systemName: "checkmark")
            .resizable()
            .frame(width: 20, height: 20)
            .scaleEffect(isReachThreshold ? 1.5 : 1)
            .multilineTextAlignment(.trailing)
            .padding(.leading, CGFloat(slotWidth) - 30.0 - 40)
            .padding(.trailing, 30.0)
            .frame(width: CGFloat(self.slotWidth), height: CGFloat(self.height))
            .foregroundColor(.g0)
            .background(leftSlotBg)
            .animation(Animation.spring())
    }
    
    var rightSlot: some View {
        Image(systemName: "trash")
            .resizable()
            .frame(width: 20, height: 20)
            .scaleEffect(isReachThreshold ? 1.5 : 1)
            .multilineTextAlignment(.leading)
            .padding(.trailing, CGFloat(slotWidth) - 30.0 - 40)
            .padding(.leading, 30.0)
            .frame(width: CGFloat(self.slotWidth), height: CGFloat(self.height))
            .foregroundColor(.g0)
            .background(rightSlotBg)
            .animation(Animation.spring())
    }

    var gesture: some Gesture {
        DragGesture()
            .onChanged { value in
//                缓存 isReachThreshold 最近一次状态
                let lastIsReachThreshold = isReachThreshold
                var newOffsetX = Int(value.translation.width)
//                若没传相应的回调，就相当于禁用
                if onLeftSwipe == nil {
                    newOffsetX = min(0, newOffsetX)
                }
                if onRightSwipe == nil {
                    newOffsetX = max(0, newOffsetX)
                }
                self.offsetX = newOffsetX
//                如果两次状态不一致，就震动
                if isReachThreshold != lastIsReachThreshold {
                    viberate()
                }
            }
            .onEnded { value in
                if self.offsetX > self.threshold {
                    self.onLeftSwipe?()
                } else if -self.offsetX > self.threshold {
                    self.onRightSwipe?()
                }
                self.offsetX = .zero
            }
    }

    var body: some View {
        ZStack(alignment: alignment) {
            customContent
                .animation(Animation.spring())
                .offset(x: contentOffset)
            offsetX > 0 ? leftSlot.offset(x: leftSlotOffset) : nil
            offsetX < 0 ? rightSlot.offset(x: rightSlotOffset) : nil
        }
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
