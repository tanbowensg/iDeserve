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
    @State var dragOver = false
    
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
                            return NSItemProvider(object: goal.id!.uuidString as NSString)
                        }
                        .onDrop(of: [UTType.text], delegate: DragRelocateDelegate(item: goal, current: $draggedGoal))
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
//    @Binding var listData: [Goal]
//    var goals: [Goal]
    @Binding var current: Goal?

    func dropEntered(info: DropInfo) {
        print("drop进入")
        print(item.name)
    }

    func dropUpdated(info: DropInfo) -> DropProposal? {
//        print("更新")
        return DropProposal(operation: .move)
    }

    func performDrop(info: DropInfo) -> Bool {
        print("drop了")
        
        if item.id != current?.id && current != nil {
//            let from = goals.firstIndex(of: current!)!
//            let to = goals.firstIndex(of: item)!
            let newPos = item.pos - 1
            print(newPos)
            current!.pos = newPos
            
            GlobalStore.shared.coreDataContainer.saveContext()
            
//            if listData[to].id != current!.id {
//                listData.move(fromOffsets: IndexSet(integer: from),
//                    toOffset: to > from ? to + 1 : to)
//            }
        }

        self.current = nil

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
