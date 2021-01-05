//
//  RecordPage.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/10/19.
//

import SwiftUI
import CoreData

struct RecordPage: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(fetchRequest: recordRequest) var records: FetchedResults<Record>
    
    @State var chosenDate: Date? = nil

    static var recordRequest: NSFetchRequest<Record> {
        let request: NSFetchRequest<Record> = Record.fetchRequest()
        request.sortDescriptors = []
        return request
   }
    
    var dayStats: [DayStat] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let from = formatter.date(from: "2020-12-01 16:15")!
        let to = Date()
        
        let reducedRecords = reduceRecords(
            records: records.map{return $0},
            from: from,
            to: to
        )
        return fillDayStats(dayStats: reducedRecords)
    }
    
    var chosenDateRecords: [Record] {
        if let _chosenDate = chosenDate {
            return records.filter { Calendar.current.isDate($0.date!, inSameDayAs: _chosenDate) }
        }

        return []
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
        }
    }

    var body: some View {
        VStack {
            CalendarLayout(dayStats: dayStats, onTapDate: { chosenDate = $0 })
            recordList
        }
        .navigationBarHidden(true)
    }
}

struct RecordPage_Previews: PreviewProvider {
    static var previews: some View {
        RecordPage()
            .environment(\.managedObjectContext, CoreDataContainer.shared.context)
    }
}
