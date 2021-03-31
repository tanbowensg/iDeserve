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
    var onTapDate: ((_ date: Date) -> Void)?
    var onMonthChange: (_ nextYear: Int, _ nextMonth: Int) -> Void
    
    @State var offsetX: CGFloat = 0
    var threshold: CGFloat = 140
    let animationDuration = 0.3

//    已经达到了出发操作的阈值
    var isReachThreshold: Bool {
        return abs(offsetX) >= threshold
    }
    
    func setOffsetX(_ value: CGFloat) -> Void {
        withAnimation(.easeInOut(duration: animationDuration)) {
            offsetX = value
        }
    }

    var gesture: some Gesture {
//        这里有些地方需要动画，有些不需要，注意区别
        DragGesture(minimumDistance: 1)
            .onChanged { value in
                setOffsetX(value.translation.width)
            }
            .onEnded { value in
                if offsetX > threshold {
                    setOffsetX(CalendarWidth + CalendarGridHorizontalSpacing)
                    let (prevYear, prevMonth) = getPrevMonth(year: currentYear, month: currentMonth)
                    DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
//                      此处是swipe动画结束后重置月份，这里应该在幕后完成，不要有动画
                        withAnimation(.none) {
                            onMonthChange(prevYear, prevMonth)
                            offsetX = .zero
                        }
                    }
                } else if -offsetX > threshold {
                    setOffsetX(-CalendarWidth - CalendarGridHorizontalSpacing)
                    let (nextYear, nextMonth) = getNextMonth(year: currentYear, month: currentMonth)
                    DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
                        withAnimation(.none) {
                            onMonthChange(nextYear, nextMonth)
                            offsetX = .zero
                        }
                    }
                } else {
                    setOffsetX(.zero)
                }
            }
    }

    var body: some View {
        let (_, prevMonth) = getPrevMonth(year: currentYear, month: currentMonth)
        let (_, nextMonth) = getNextMonth(year: currentYear, month: currentMonth)
//        套上scrollView可以实现y轴上overflow hidden的效果
        return
            HStack(alignment: .top, spacing: CalendarGridHorizontalSpacing) {
                CalendarLayout(dayStats: prevDayStats, currentMonth: prevMonth, onTapDate: onTapDate)
                    .id(prevMonth)
                CalendarLayout(dayStats: dayStats, currentMonth: currentMonth, onTapDate: onTapDate)
                    .id(currentMonth)
                CalendarLayout(dayStats: nextDayStats, currentMonth: nextMonth, onTapDate: onTapDate)
                    .id(nextMonth)
            }
            .frame(width: CalendarWidth, height: getCalendarHeight(dayStats.count), alignment: .top)
            .offset(x: offsetX, y: 0)
            .gesture(gesture)
            .clipped()
    }
}
