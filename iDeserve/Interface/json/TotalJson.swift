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
    var goals: [GoalJson]
    var rewards: [RewardJson]
    var records: [RecordJson]
}

func backupData() {
    do {
        let fetchedGoals = try CoreDataContainer.shared.context.fetch(NSFetchRequest(entityName: "Goal")) as! [Goal]
        let fetchedRewards = try CoreDataContainer.shared.context.fetch(NSFetchRequest(entityName: "Reward")) as! [Reward]
        let fetchedRecords = try CoreDataContainer.shared.context.fetch(NSFetchRequest(entityName: "Record")) as! [Record]
        
        var goalJsons: [GoalJson] = []
        fetchedGoals.forEach { g in
            goalJsons.append(GoalJson(g: g))
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
                goals: goalJsons,
                rewards: rewardJsons,
                records: recordJsons
            )

            let json = try encoder.encode(rawJson)

            CloudHelper.shared.save(data: json)
        } catch {
            print("解析备份文件json失败了")
        }
    } catch {
        fatalError("备份失败: \(error)")
    }
}

func restoreData () {
    let context = CoreDataContainer.shared.persistentContainer.viewContext
    if let totalJson = CloudHelper.shared.read() {
//        先清空原本的数据
        let entities = CoreDataContainer.shared.persistentContainer.managedObjectModel.entities
        for entity in entities {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity.name!)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                try context.executeAndMergeChanges(using: deleteRequest)
            } catch {
                print("删除coredata数据失败")
            }
        }
        context.refreshAllObjects()
    
//    再还原
        totalJson.goals.forEach{ gJson in
            let _ = importGoal(goalJson: gJson)
        }
        totalJson.rewards.forEach{ rJson in
            let _ = importRewardJson(rewardJson: rJson)
        }
        totalJson.records.forEach{ rJson in
            let _ = importRewardJson(recordJson: rJson)
        }

        CoreDataContainer.shared.saveContext()

        PointsStore.shared.setValue(totalJson.value)
    } else {
        print("还原数据失败，文件不存在")
    }
}

extension NSManagedObjectContext {
    
    /// Executes the given `NSBatchDeleteRequest` and directly merges the changes to bring the given managed object context up to date.
    ///
    /// - Parameter batchDeleteRequest: The `NSBatchDeleteRequest` to execute.
    /// - Throws: An error if anything went wrong executing the batch deletion.
    public func executeAndMergeChanges(using batchDeleteRequest: NSBatchDeleteRequest) throws {
        batchDeleteRequest.resultType = .resultTypeObjectIDs
        let result = try execute(batchDeleteRequest) as? NSBatchDeleteResult
        let changes: [AnyHashable: Any] = [NSDeletedObjectsKey: result?.result as? [NSManagedObjectID] ?? []]
        NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [self])
    }
}
