//
//  RecordStore.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/11/10.
//

import Foundation

final class RecordStore {
    static var shared = RecordStore()
    var moc = CoreDataContainer.shared.context
    private var pointsStore = PointsStore.shared
    
    func createRecord (
        name: String,
        kind: RecordKind,
        value: Int
    ) {
        let newRecord = Record(context: self.moc)
        newRecord.id = UUID()
        newRecord.name = name
        newRecord.kind = Int16(kind.rawValue)
        newRecord.value = Int16(value)
        newRecord.date = Date()
        do {
            try self.moc.save()
        } catch {
            print("创建记录失败")
        }
    }

    func deleteRecord (_ record: Record) {
        let kind = record.kind
        let value = record.value
        moc.delete(record)
        
        do {
            try self.moc.save()
            if kind == RecordKind.reward.rawValue {
                pointsStore.add(Int(value))
            } else {
                pointsStore.minus(Int(value))
            }
        } catch {
            print("删除记录失败")
        }
    }
}
