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

    @State var offsetX: CGFloat = 0
    
    //    左右的背景颜色
    let leftSlotBg = Color.brandGreen
    let rightSlotBg = Color.red
    
    var iconSize: CGFloat {
        CGFloat(height / 3)
    }
    
    var slotWidth: CGFloat {
        CGFloat(height)
    }
    
    var threshold: CGFloat {
        CGFloat(slotWidth / 3)
    }
    
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
        return -self.slotWidth + offsetX
    }
    
    var rightSlotOffset: CGFloat {
        return self.slotWidth + offsetX
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
            .frame(width: iconSize, height: iconSize)
            .multilineTextAlignment(.trailing)
            .padding(.trailing, threshold / 3)
            .frame(width: slotWidth, height: CGFloat(height))
            .foregroundColor(.g0)
            .background(leftSlotBg)
            .animation(Animation.default)
            .onTapGesture {
                onLeftSwipe?()
                offsetX = 0
            }
    }
    
    var rightSlot: some View {
        Image(systemName: "trash")
            .resizable()
            .frame(width: iconSize, height: iconSize)
            .multilineTextAlignment(.leading)
            .padding(.leading, threshold / 3)
            .frame(width: slotWidth, height: CGFloat(height))
            .foregroundColor(.g0)
            .background(rightSlotBg)
            .animation(Animation.default)
            .onTapGesture {
                onRightSwipe?()
                offsetX = 0
            }
    }
    
    var gesture: some Gesture {
        DragGesture()
            .onChanged { value in
                var newOffsetX = Int(value.translation.width)
                //                若没传相应的回调，就相当于禁用
                if onLeftSwipe == nil {
                    newOffsetX = min(0, newOffsetX)
                }
                if onRightSwipe == nil {
                    newOffsetX = max(0, newOffsetX)
                }
                self.offsetX = min(slotWidth, max(-slotWidth, CGFloat(newOffsetX)))
            }
            .onEnded { value in
                if self.offsetX > self.threshold {
                    offsetX = slotWidth
                } else if -self.offsetX > self.threshold {
                    offsetX = -slotWidth
                } else {
                    self.offsetX = .zero
                }
            }
    }
    
    var body: some View {
        ZStack(alignment: alignment) {
            customContent
                .offset(x: offsetX)
                .animation(Animation.default, value: offsetX)
            offsetX > 0 ? leftSlot.offset(x: leftSlotOffset) : nil
            offsetX < 0 ? rightSlot.offset(x: rightSlotOffset) : nil
        }
        .gesture(gesture)
        
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.onScroll)){ _ in
            //            这里是为了避免scrollView滚动的时候，ondrag的onended不触发，结果卡在那里
            offsetX = 0
        }
    }
}

//struct SwipeWrapper_Previews: PreviewProvider {
//    static var previews: some View {
//        let content =
//            HStack {
//                Text("Hello, World!")
//                Spacer()
//            }
//                .frame(height: 100)
//                .background(Color.yellow)
//
//        SwipeWrapper(content: content, height: 100)
//    }
//}
