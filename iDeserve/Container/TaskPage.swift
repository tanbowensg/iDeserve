//
//  TaskPage.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/10/5.
//

import SwiftUI
import CoreData
import UniformTypeIdentifiers

struct TaskPage: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var gs: GlobalStore

    @FetchRequest(fetchRequest: goalRequest) var goals: FetchedResults<Goal>
    
    @State private var draggedGoal: Goal?
//    强制所有goalRow收起
    @State private var forceCollapse = false
    
//    为了在任务更新的时候重新渲染目标
//    https://stackoverflow.com/questions/58643094/how-to-update-fetchrequest-when-a-related-entity-changes-in-swiftui
    @State private var refreshing = false
    private var didSave =  NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave)

    static var goalRequest: NSFetchRequest<Goal> {
        let request: NSFetchRequest<Goal> = Goal.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Goal.pos, ascending: true)
        ]
        return request
   }

    var body: some View {
        NavigationView() {
            ZStack(alignment: .bottomTrailing) {
                ScrollView {
                    ForEach (goals, id: \.id) { goal in
                        GoalRow(
                            goal: goal,
                            forceCollapse: forceCollapse,
                            isBeingDragged: draggedGoal?.id == goal.id,
                            onCompleteTask: { task in
                                gs.taskStore.completeTask(task)
                            },
                            onRemoveTask: { task in
                                gs.taskStore.removeTask(task)
                            }
                        )
                        .overlay(draggedGoal?.id == goal.id ? Color.white.opacity(0.8) : Color.clear)
                        .onDrag {
                            print("开始拖")
                            self.draggedGoal = goal
                            self.forceCollapse = true
                            return NSItemProvider(object: goal.id!.uuidString as NSString)
                        }
                        .onDrop(of: [UTType.text], delegate: DragRelocateDelegate(item: goal, goals: goals, current: $draggedGoal, forceCollapse: $forceCollapse))
                    }
//                    无用，纯粹为了在任务更新时刷新目标列表
                    Text(self.refreshing ? "" : "")
                }
                    .onReceive(self.didSave) { _ in
                        self.refreshing.toggle()
                    }
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        NavigationLink(destination: EditTaskPage(originTask: nil)) {
                            CreateButton()
                        }
                        NavigationLink(destination: EditGoalPage(initGoal: nil)) {
                            CreateButton()
                        }
                    }
                    .padding(.trailing, 16)
                }
                .padding(.bottom, 16)
            }
                .navigationBarHidden(true)
        }
    }
}

struct DragRelocateDelegate: DropDelegate {
    let item: Goal
    var goals: FetchedResults<Goal>
    @Binding var current: Goal?
    @Binding var forceCollapse: Bool
    
    func moveBefore() {
        let itemIndex = Int(goals.firstIndex(of: item)!)
        var beforePos: Int
        if itemIndex == 0 {
            beforePos = 0
        } else {
            beforePos = Int(goals[itemIndex - 1].pos)
        }

        let newPos = (Int(item.pos) + beforePos) / 2
        print("前一个newPos:\(newPos)")

//        万一pos值用尽的应急方案
        if (current!.pos == Int16(newPos)) {
            resetGoalPos()
            moveBefore()
            return
        }

        current!.pos = Int16(newPos)
        GlobalStore.shared.coreDataContainer.saveContext()
    }
    
    func moveAfter() {
        let itemIndex = Int(goals.firstIndex(of: item)!)
        var afterPos: Int
        if itemIndex == goals.count - 1 {
            afterPos = MAX_POS
        } else {
            afterPos = Int(goals[itemIndex + 1].pos)
        }

        let newPos = (Int(item.pos) + afterPos) / 2
        print("后一个newPos:\(newPos)")

//        万一pos值用尽的应急方案
        if (current!.pos == Int16(newPos)) {
            resetGoalPos()
            moveAfter()
            return
        }

        current!.pos = Int16(newPos)
        GlobalStore.shared.coreDataContainer.saveContext()
    }

    func dropEntered(info: DropInfo) {
    }

    func dropUpdated(info: DropInfo) -> DropProposal? {
        print(info.location)
        return DropProposal(operation: .move)
    }

    func performDrop(info: DropInfo) -> Bool {
        if item.id != current?.id && current != nil {
//            moveBefore()
            moveAfter()
        }

        self.current = nil
        self.forceCollapse = false

        return true
    }
}

struct TaskPage_Previews: PreviewProvider {
    let tasks = genMockTasks(CoreDataContainer.shared.context)
    
    static var previews: some View {
        TaskPage()
            .environment(\.managedObjectContext, CoreDataContainer.shared.context)
    }
}
