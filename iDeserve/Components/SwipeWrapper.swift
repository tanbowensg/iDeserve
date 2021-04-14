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
        CGFloat(300)
    }
    
    var threshold: CGFloat {
        CGFloat(80)
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
            .scaleEffect(isReachThreshold ? 1.5 : 1)
            .multilineTextAlignment(.trailing)
            .padding(.leading, slotWidth - threshold / 3 - iconSize)
            .padding(.trailing, threshold / 3)
            .frame(width: slotWidth, height: CGFloat(height))
            .foregroundColor(.g0)
            .background(leftSlotBg)
            .animation(Animation.spring())
    }
    
    var rightSlot: some View {
        Image(systemName: "trash")
            .resizable()
            .frame(width: iconSize, height: iconSize)
            .scaleEffect(isReachThreshold ? 1.5 : 1)
            .multilineTextAlignment(.leading)
            .padding(.trailing, slotWidth - threshold / 3 - iconSize)
            .padding(.leading, threshold / 3)
            .frame(width: slotWidth, height: CGFloat(height))
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
                self.offsetX = CGFloat(newOffsetX)
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
                .offset(x: offsetX)
                .animation(Animation.spring(), value: offsetX)
            offsetX > 0 ? leftSlot.offset(x: leftSlotOffset) : nil
            offsetX < 0 ? rightSlot.offset(x: rightSlotOffset) : nil
        }
        .gesture(gesture)
        
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.onScroll)){ _ in
            //            这里是为了避免scrollView滚动的时候，ondrag的onended不触发，结果卡在那里
            print("滚动了")
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
