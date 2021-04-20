//
//  CalendarLayout.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/1/4.
//

import SwiftUI

struct CalendarLayout: View {
    var dayStats: [DayStat]
    var currentMonth: Int
    var onTapDate: ((_ date: Date) -> Void)?
    
    @State var highlightDate: Date? = nil

    var columns: [GridItem] {
        let array = Array(1...7)
        return array.map { _ in GridItem(.fixed(CalendarGridSize), spacing: CalendarGridHorizontalSpacing) }
    }

    var body: some View {
        VStack(spacing: CalendarGridVerticalSpacing) {
            LazyVGrid(
                columns: columns,
                alignment: .center,
                spacing: CalendarGridVerticalSpacing
            ) {
                ForEach(["日", "一", "二", "三", "四", "五", "六"], id: \.self) {text in
                    Text(text)
                        .foregroundColor(Color.b2)
                        .font(.footnoteCustom)
                        .fontWeight(.bold)
                        .frame(width: CalendarGridSize, height: CalendarGridSize)
                }
            }

            LazyVGrid(
                columns: columns,
                alignment: .center,
                spacing: CalendarGridVerticalSpacing
            ) {
                ForEach(dayStats, id: \.date) { ds in
                    CalendarGrid(
                        dayStat: ds,
                        isHighlight: highlightDate == nil ? false : Calendar.current.isDate(ds.date, inSameDayAs: highlightDate!),
                        isCurrentMonth: getDateMonth(ds.date) == currentMonth
                    )
                        .onTapGesture {
                            if let _onTapDate = onTapDate {
                                highlightDate = ds.date
                                _onTapDate(ds.date)
                            }
                        }
                }
            }
        }
        .background(Color.white)
        .transition(AnyTransition.scale(scale: 1))
    }
    
    func getDateMonth (_ date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date).month!
    }
}

struct CalendarLayout_Previews: PreviewProvider {
    @State var chosenDate: Date?

    static var previews: some View {
        CalendarLayout(dayStats: [DayStat(date: Date(), income: 0, outcome: 0)], currentMonth: 1)
        
    }
}
