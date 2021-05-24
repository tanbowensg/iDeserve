//
//  TotalJson.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/5/24.
//

import Foundation
import CoreData

struct TotalJsonData: Codable {
    var value: Int
    var tasks: [TaskJson]
    var rewards: [RewardJson]
    var records: [RecordJson]
}

func backupData() {
    do {
        let fetchedTasks = try CoreDataContainer.shared.context.fetch(NSFetchRequest(entityName: "Task")) as! [Task]
        let fetchedRewards = try CoreDataContainer.shared.context.fetch(NSFetchRequest(entityName: "Reward")) as! [Reward]
        let fetchedRecords = try CoreDataContainer.shared.context.fetch(NSFetchRequest(entityName: "Record")) as! [Record]
        
        var taskJsons: [TaskJson] = []
        fetchedTasks.forEach { t in
            taskJsons.append(TaskJson(t: t))
        }
        
        
        var rewardJsons: [RewardJson] = []
        fetchedRewards.forEach { r in
            rewardJsons.append(RewardJson(r: r))
        }
        
        var recordJsons: [RecordJson] = []
        fetchedRecords.forEach { r in
            recordJsons.append(RecordJson(r: r))
        }
        
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let rawJson = TotalJsonData(
                value: PointsStore.shared.points,
                tasks: taskJsons,
                rewards: rewardJsons,
                records: recordJsons
            )

            let json = try encoder.encode(rawJson)
            
            print("写入的")
            print(json)

            CloudHelper.shared.save(data: json)
        } catch {
            print("失败了")
        }
    } catch {
        fatalError("读取coredata的目标数据失败: \(error)")
    }
}

func restoreData () {
    CloudHelper.shared.read()
}
