//
//  RecordPage.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/10/19.
//

import SwiftUI

struct RecordPage: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        entity: Record.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Record.date, ascending: true)
        ]
    ) var records: FetchedResults<Record>

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
        let newRecord = Record(context: self.managedObjectContext)
        newRecord.title = "学习 CoreData"
        newRecord.value = 999
        newRecord.date = Date()
        do {
            try self.managedObjectContext.save()
        } catch {
            // handle the Core Data error
        }
    }
    
    func deleteRecord (at offsets: IndexSet) {
        for index in offsets {
            let record = records[index]
            managedObjectContext.delete(record)
        }
    }
}

struct RecordPage_Previews: PreviewProvider {
    static var previews: some View {
        RecordPage()
            .environment(\.managedObjectContext, CoreDataContainer.shared.context)
    }
}
