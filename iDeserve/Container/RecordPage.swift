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
                Button (action: self.insertRecord) {
                    Text("添加记录")
                }
                List {
                    ForEach (records) { record in
                        HStack {
                            Text(record.title ?? "未知")
                            Spacer()
                            Text(String(record.value))
                        }
                    }
                        .onDelete(perform: deleteRecord)
                }
            }
                .navigationTitle("历史记录")
        }
    }
    
    func insertRecord () {
        let newRecord = Record(context: self.moc)
        newRecord.title = "学习 CoreData"
        newRecord.value = 999
        newRecord.date = Date()
        do {
            try self.moc.save()
        } catch {
            // handle the Core Data error
        }
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
