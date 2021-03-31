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
    var gridSize: Int
    var onTapDate: ((_ date: Date) -> Void)?
    
    @State var highlightDate: Date? = nil

    var columns: [GridItem] {
        let array = Array(1...7)
        return array.map { _ in GridItem(.fixed(CGFloat(gridSize)), spacing: 0) }
    }

    var body: some View {
        VStack(spacing: 0.0) {
            LazyVGrid(
                columns: columns,
                alignment: .center,
                spacing: 0
            ) {
                ForEach(["日", "一", "二", "三", "四", "五", "六"], id: \.self) {text in
                    Text(text)
                        .foregroundColor(Color.subtitle)
                        .font(.footnoteSmCustom)
                        .fontWeight(.bold)
                        .frame(width: CGFloat(gridSize), height: CGFloat(gridSize))
                }
            }

            LazyVGrid(
                columns: columns,
                alignment: .center,
                spacing: 0
            ) {
                ForEach(dayStats, id: \.date) { ds in
                    CalendarGrid(
                        dayStat: ds,
                        size: Int(gridSize),
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
        CalendarLayout(dayStats: [DayStat(date: Date(), income: 0, outcome: 0)], currentMonth: 1, gridSize: 55)
    }
}
