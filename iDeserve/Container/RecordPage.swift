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

    static var recordRequest: NSFetchRequest<Record> {
        let request: NSFetchRequest<Record> = Record.fetchRequest()
        request.sortDescriptors = []
        return request
   }

    var body: some View {
        NavigationView() {
            VStack {
                List {
                    ForEach (records) { record in
                        VStack {
                            HStack {
                                Text(record.name ?? "未知")
                                Spacer()
                                Text(String(record.value))
                            }
                            Text(dateToString(record.date!))
                        }
                    }
                        .onDelete(perform: deleteRecord)
                }
            }
                .navigationTitle("历史记录")
        }
        .navigationBarHidden(true)
    }

    func deleteRecord (at offsets: IndexSet) {
        for index in offsets {
            let record = records[index]
            moc.delete(record)
        }
    }
}

struct RecordPage_Previews: PreviewProvider {
    static var previews: some View {
        RecordPage()
            .environment(\.managedObjectContext, CoreDataContainer.shared.context)
    }
}
