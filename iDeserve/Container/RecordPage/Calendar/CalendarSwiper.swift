//
//  CalendarSwiper.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/1/12.
//

import SwiftUI

struct CalendarSwiper: View {
    var dayStats: [DayStat]
    var prevDayStats: [DayStat]
    var nextDayStats: [DayStat]
    var currentYear: Int
    var currentMonth: Int
    var gridSize: Int
    var onTapDate: ((_ date: Date) -> Void)?
    var onMonthChange: (_ nextYear: Int, _ nextMonth: Int) -> Void
    
    @State var offsetX = 0
    let threshold: Int = 100

//    已经达到了出发操作的阈值
    var isReachThreshold: Bool {
        return abs(offsetX) >= threshold
    }

    var gesture: some Gesture {
        DragGesture(minimumDistance: 3)
            .onChanged { value in
//                缓存 isReachThreshold 最近一次状态
                let lastIsReachThreshold = isReachThreshold
                let newOffsetX = Int(value.translation.width)
                self.offsetX = newOffsetX
//                如果两次状态不一致，就震动
                if isReachThreshold != lastIsReachThreshold {
                    viberate()
                }
            }
            .onEnded { value in
                if self.offsetX > self.threshold {
                    print("上个月")
//                        offsetX = -gridSize * 7
                    let (prevYear, prevMonth) = getPrevMonth(year: currentYear, month: currentMonth)
                    onMonthChange(prevYear, prevMonth)
                } else if -self.offsetX > self.threshold {
                    print("下个月")
                    let (nextYear, nextMonth) = getNextMonth(year: currentYear, month: currentMonth)
                    onMonthChange(nextYear, nextMonth)
//                    offsetX = gridSize * 7
                }
                self.offsetX = .zero
            }
    }

    var body: some View {
        let (_, prevMonth) = getPrevMonth(year: currentYear, month: currentMonth)
        let (_, nextMonth) = getNextMonth(year: currentYear, month: currentMonth)
//        套上scrollView可以实现y轴上overflow hidden的效果
        return ScrollView(/*@START_MENU_TOKEN@*/.vertical/*@END_MENU_TOKEN@*/, showsIndicators: false) {
            HStack(alignment: .top, spacing: 0.0) {
                CalendarLayout(dayStats: prevDayStats, currentMonth: prevMonth, gridSize: gridSize, onTapDate: onTapDate)
                CalendarLayout(dayStats: dayStats, currentMonth: currentMonth, gridSize: gridSize, onTapDate: onTapDate)
                CalendarLayout(dayStats: nextDayStats, currentMonth: nextMonth, gridSize: gridSize, onTapDate: onTapDate)
            }
//            .frame(width: CGFloat(gridSize * 7))
            .offset(x: CGFloat(offsetX))
            .gesture(gesture)
            .animation(.easeInOut, value: offsetX)
        }
        .frame(width: CGFloat(gridSize * 7))
        .onAppear {
               UIScrollView.appearance().bounces = false
        }
        .onDisappear {
            UIScrollView.appearance().bounces = true
        }
        .shadow(color: .g10, radius: 10, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
    }
}
