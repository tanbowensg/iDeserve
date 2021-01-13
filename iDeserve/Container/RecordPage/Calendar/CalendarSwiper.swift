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
    var threshold: Int = 140

//    已经达到了出发操作的阈值
    var isReachThreshold: Bool {
        return abs(offsetX) >= threshold
    }

    var gesture: some Gesture {
        DragGesture(minimumDistance: 1)
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
                if offsetX > threshold {
                    offsetX = gridSize * 7
                    let (prevYear, prevMonth) = getPrevMonth(year: currentYear, month: currentMonth)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        onMonthChange(prevYear, prevMonth)
                        offsetX = .zero
                    }
                } else if -offsetX > threshold {
                    offsetX = -gridSize * 7
                    let (nextYear, nextMonth) = getNextMonth(year: currentYear, month: currentMonth)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        onMonthChange(nextYear, nextMonth)
                        offsetX = .zero
                    }
                } else {
                    offsetX = .zero
                }
            }
    }

    var body: some View {
        let (_, prevMonth) = getPrevMonth(year: currentYear, month: currentMonth)
        let (_, nextMonth) = getNextMonth(year: currentYear, month: currentMonth)
//        套上scrollView可以实现y轴上overflow hidden的效果
        return
            HStack(alignment: .top, spacing: 0.0) {
                CalendarLayout(dayStats: prevDayStats, currentMonth: prevMonth, gridSize: gridSize, onTapDate: onTapDate)
                    .id(prevMonth)
                CalendarLayout(dayStats: dayStats, currentMonth: currentMonth, gridSize: gridSize, onTapDate: onTapDate)
                    .id(currentMonth)
                CalendarLayout(dayStats: nextDayStats, currentMonth: nextMonth, gridSize: gridSize, onTapDate: onTapDate)
                    .id(nextMonth)
            }
            .frame(width: CGFloat(gridSize * 7), height: 20 + CGFloat(gridSize * dayStats.count / 7), alignment: .top)
            .offset(x: CGFloat(offsetX), y: 0)
            .gesture(gesture)
            .animation(.easeInOut(duration: 0.3), value: offsetX)
    }
}
