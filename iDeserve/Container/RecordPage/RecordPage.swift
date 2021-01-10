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
    
    var chosenDateRecords: [Record] {
        if let _chosenDate = chosenDate {
            return records.filter { Calendar.current.isDate($0.date!, inSameDayAs: _chosenDate) }
        }

        return []
    }
    
    var monthTitle: some View {
        Text("\(String(currentYear))年\(currentMonth)月")
    }
    
    var recordList: some View {
        return List {
            ForEach (chosenDateRecords) { record in
                HStack {
                    Text(record.name ?? "未知")
                    Spacer()
                    Text(dateToString(record.date!))
                    Spacer()
                    Text(String(record.value))
                }
            }
            .onDelete(perform: deleteRecord)
        }

    }

    var body: some View {
        VStack {
            AppHeader(points: gs.pointsStore.points, title: "历史记录")
            monthTitle
            CalendarLayout(dayStats: dayStats, currentMonth: currentMonth, onTapDate: { chosenDate = $0 })
                .gesture(dragGesture)
            recordList
        }
        .navigationBarHidden(true)
    }
    
    var dragGesture: some Gesture {
        DragGesture(minimumDistance: 10, coordinateSpace: .local)
            .onEnded { value in
                print(value.translation)
                
                if value.translation.width < 0 && value.translation.height > -30 && value.translation.height < 30 {
//                    左滑
                    addMonth()
                }
                else if value.translation.width > 0 && value.translation.height > -30 && value.translation.height < 30 {
//                    右滑
                    minusMonth()
                }
            }
    }
    
    func minusMonth () {
        currentMonth -= 1
        if currentMonth == 0 {
            currentYear -= 1
            currentMonth = 12
        }
    }
    
    func addMonth () {
        currentMonth += 1
        if currentMonth > 12 {
            currentYear += 1
            currentMonth = 1
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
