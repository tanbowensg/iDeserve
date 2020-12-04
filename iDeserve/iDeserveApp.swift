//
//  iDeserveApp.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/9/30.
//

import SwiftUI
import CoreData

//重置任务完成状态的定时任务
func resetTaskStatus () {
    let moc = GlobalStore.shared.moc
    let taskRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Task")
    
    do {
        let fetchedTasks = try moc.fetch(taskRequest) as! [Task]
        fetchedTasks.forEach {task in
            if (task.done && task.completeTimes < task.repeatTimes) {
                task.done = false
            }
        }
        try moc.save()
    } catch {
        print("执行任务状态重置")
    }
}


// 重置目标的pos值
func resetGoalPos () {
    let moc = GlobalStore.shared.moc
    let goalRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Goal")
    goalRequest.sortDescriptors = [
        NSSortDescriptor(keyPath: \Goal.pos, ascending: true)
    ]
    
    do {
        let fetchedGoals = try moc.fetch(goalRequest) as! [Goal]
        fetchedGoals.indices.forEach {i in
            fetchedGoals[i].pos = Int16(i * 32767 / fetchedGoals.count)
        }
        try moc.save()
    } catch {
        print("重置目标的pos值")
    }
}

@main
struct iDeserveApp: App {
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        
        WindowGroup {
            ZStack {
                    Color.bg
                        .ignoresSafeArea()
                    TabWapper()
                        .environment(\.managedObjectContext, GlobalStore.shared.moc)
                        .environmentObject(GlobalStore.shared)
                        .environmentObject(PointsStore.shared)
            }
            .font(.hiraginoSansGb14Pt2)
        }
        .onChange(of: scenePhase) { phase in
            switch phase {
                case .active:
                    resetTaskStatus()
                    resetGoalPos()
                default:
                    print(phase)
            }
        }
    }
}
