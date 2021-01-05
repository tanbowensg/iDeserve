//
//  CalendarLayout.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/1/4.
//

import SwiftUI

struct CalendarLayout: View {
    var dayStats: [DayStat]
    var onTapDate: ((_ date: Date) -> Void)?
    
    @State var highlightDate: Date? = nil

    var columns: [GridItem] {
        let array = Array(1...7)
        return array.map { _ in GridItem(.fixed(40), spacing: 0) }
    }

    var body: some View {
        return VStack {
            LazyVGrid(
                columns: columns,
                alignment: .center,
                spacing: 0
            ) {
                Text("日")
                Text("一")
                Text("二")
                Text("三")
                Text("四")
                Text("五")
                Text("六")
            }
            LazyVGrid(
                columns: columns,
                alignment: .center,
                spacing: 0
            ) {
                ForEach(dayStats, id: \.date) { ds in
                    CalendarGrid(
                        dayStat: ds,
                        size: 40,
                        isHighlight: highlightDate == nil ? false : Calendar.current.isDate(ds.date, inSameDayAs: highlightDate!)
                    )
                        .onTapGesture {
                            if let _onTapDate = onTapDate {
                                highlightDate = ds.date
                                _onTapDate(ds.date)
                            }
                        }
                }
            }
            .frame(width: 280.0)
        }
    }
}

struct CalendarLayout_Previews: PreviewProvider {
    @State var chosenDate: Date?

    static var previews: some View {
        CalendarLayout(dayStats: [])
    }
}
