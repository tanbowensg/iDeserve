//
//  GoalJson.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/5/24.
//

import Foundation
import CoreData

struct GoalJson: Codable {
    var name: String
    var done: Bool
    var importance: Int16
    var pos: Int16
    var type: String
    var tasks: [TaskJson]
    
    init(g: Goal) {
        name = g.name!
        done = g.done
        importance = g.importance
        pos = g.pos
        type = g.type!
        tasks = (g.tasks?.allObjects as! [Task]).map { t in
            TaskJson(t: t)
        } 
    }
}

func importGoal(goalJson: GoalJson) -> Goal {
    let g = Goal(context: CoreDataContainer.shared.context)
    g.id = UUID()
    g.name = goalJson.name
    g.done = goalJson.done
    g.importance = goalJson.importance
    g.pos = goalJson.pos
    g.type = goalJson.type
    g.tasks = NSSet(array: goalJson.tasks.map { taskJson in
        importTaskJson(taskJson: taskJson, goal: g)
    })
    return g
}
