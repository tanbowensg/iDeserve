//
//  RecordPage.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/10/19.
//

import SwiftUI
import CoreData

struct RecordPage: View {
    @EnvironmentObject var gs: GlobalStore
    @FetchRequest(fetchRequest: recordRequest) var records: FetchedResults<Record>
    
    @State var chosenDate: Date? = nil
    @State var currentMonth: Int = Calendar.current.dateComponents([.month], from: Date()).month!
    @State var currentYear: Int = Calendar.current.dateComponents([.year], from: Date()).year!

    static var recordRequest: NSFetchRequest<Record> {
        let request: NSFetchRequest<Record> = Record.fetchRequest()
        request.sortDescriptors = []
        return request
    }

    var dayStats: [DayStat] {
        let startDay = startDateOfMonth(year: currentYear, month: currentMonth)
        let lastDay = endDateOfMonth(year: currentYear, month: currentMonth)
        
        return reduceRecords(
            records: records.map{return $0},
            from: startDay,
            to: lastDay
        )
    }
    
    var prevMonthDayStats: [DayStat] {
        let (prevYear, prevMonth) = getPrevMonth(year: currentYear, month: currentMonth)
        let startDay = startDateOfMonth(year: prevYear, month: prevMonth)
        let lastDay = endDateOfMonth(year: prevYear, month: prevMonth)
        
        return reduceRecords(
            records: records.map{return $0},
            from: startDay,
            to: lastDay
        )
    }
    
    var nextMonthDayStats: [DayStat] {
        let (nextYear, nextMonth) = getNextMonth(year: currentYear, month: currentMonth)
        let startDay = startDateOfMonth(year: nextYear, month: nextMonth)
        let lastDay = endDateOfMonth(year: nextYear, month: nextMonth)
        
        return reduceRecords(
            records: records.map{return $0},
            from: startDay,
            to: lastDay
        )
    }

    var chosenDateRecords: [Record] {
        if let _chosenDate = chosenDate {
            return records.filter { Calendar.current.isDate($0.date!, inSameDayAs: _chosenDate) }
        }

        return []
    }
    
    var monthTitle: some View {
        Text("\(String(currentYear))年\(currentMonth)月")
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0.0) {
                AppHeader(points: gs.pointsStore.points, title: "历史记录")
                monthTitle
                CalendarSwiper(
                    dayStats: dayStats,
                    prevDayStats: prevMonthDayStats,
                    nextDayStats: nextMonthDayStats,
                    currentYear: currentYear,
                    currentMonth: currentMonth,
                    gridSize: Int(geometry.size.width / 7),
                    onTapDate: { chosenDate = $0 },
                    onMonthChange: {
                        currentYear = $0
                        currentMonth = $1
                    }
                )
                    .frame(height: 20 + CGFloat(Int(geometry.size.width / 7)) * CGFloat((dayStats.count / 7)))
                .border(Color.red)
                RecordList(records: chosenDateRecords)
                    .border(Color.blue)
            }
                .animation(.easeInOut, value: currentMonth)
                .navigationBarHidden(true)
        }
    }

    func deleteRecord (at offsets: IndexSet) {
        for index in offsets {
            let record = chosenDateRecords[index]
            gs.moc.delete(record)
        }
    }
}

struct RecordPage_Previews: PreviewProvider {
    static var previews: some View {
        RecordPage()
            .environment(\.managedObjectContext, CoreDataContainer.shared.context)
    }
}
