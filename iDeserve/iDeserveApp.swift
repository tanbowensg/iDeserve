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
    let frequencyDayMap: [RepeatFrequency: Int] = [
        .daily: 1,
        .monthly: 30,
        .weekly: 7,
        .never: 99999999,
    ]
    do {
        let fetchedTasks = try moc.fetch(taskRequest) as! [Task]
        fetchedTasks.forEach {task in
            if (task.done && task.completeTimes < task.repeatTimes) {
                let dateDiff = Calendar.current.dateComponents([.day], from: task.lastCompleteTime!, to: Date())
                print(dateDiff)
                let frequency = RepeatFrequency(rawValue: Int(task.repeatFrequency))!
                if dateDiff.day! >= frequencyDayMap[frequency]! {
                    task.done = false
                }
            }
        }
        try moc.save()
    } catch {
        print("执行任务状态重置")
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
