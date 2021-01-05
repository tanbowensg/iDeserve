//
//  CalendarLayout.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/1/4.
//

import SwiftUI

struct CalendarLayout: View {
    var dayStats: [DayStat]

    var columns: [GridItem] {
        let array = Array(1...7)
        return array.map { _ in GridItem(.fixed(40), spacing: 0) }
    }

    var body: some View {
        return ScrollView {
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
                    CalendarGrid(dayStat: ds, size: 40)
                }
            }
            .frame(width: 280.0)
        }
    }
}

struct CalendarLayout_Previews: PreviewProvider {
    static var previews: some View {
        CalendarLayout(dayStats: [])
    }
}
