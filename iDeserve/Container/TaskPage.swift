//
//  TaskPage.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/10/5.
//

import SwiftUI
import CoreData
import UniformTypeIdentifiers

//struct IHighlightGoal {
//    var id: UUID?
//    var isBefore: Bool
//}

struct TaskPage: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var gs: GlobalStore
    
    @FetchRequest(fetchRequest: goalRequest) var goals: FetchedResults<Goal>
    
    @State private var draggedGoal: Goal?
    //    强制所有goalRow收起
    @State private var forceCollapse = false
    @State private var highlightIndex: Int? = 0
    
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
    
    var reorderDivider: some View {
        Divider()
            .offset(y: highlightIndex != nil ? CGFloat(highlightIndex! * Int(GOAL_ROW_HEIGHT)) : 0)
    }
    
    var body: some View {
        NavigationView() {
            ZStack(alignment: .bottomTrailing) {
                ZStack(alignment: .top) {
                    highlightIndex != nil ? reorderDivider : nil
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
                                self.draggedGoal = goal
                                self.forceCollapse = true
                                return NSItemProvider(object: goal.id!.uuidString as NSString)
                            }
                            .onDrop(
                                of: [UTType.text],
                                delegate: DragRelocateDelegate(
                                    item: goal,
                                    goals: goals,
                                    current: $draggedGoal,
                                    forceCollapse: $forceCollapse,
                                    highlightIndex: $highlightIndex
                                )
                            )
                        }
                        //                    无用，纯粹为了在任务更新时刷新目标列表
                        Text(self.refreshing ? "" : "")
                    }
                    .onReceive(self.didSave) { _ in
                        self.refreshing.toggle()
                    }
                }
                VStack {
                    NavigationLink(destination: EditGoalPage(initGoal: nil)) {
                        CreateButton()
                    }
                }
                .padding([.trailing, .bottom], 16)
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
    @Binding var highlightIndex: Int?
    
    var itemIndex: Int {
        return Int(goals.firstIndex(of: item)!)
    }

    func updateHighlight(_ y: CGFloat) {
        let remainder = y.truncatingRemainder(dividingBy: GOAL_ROW_HEIGHT)
        if CGFloat(remainder) < GOAL_ROW_HEIGHT / 2 {
            highlightIndex = itemIndex
        } else {
            highlightIndex = itemIndex + 1
        }
    }
    
    //    根据被拖动的y，计算出新的pos值
    func caculateNewPos(_ y: Int) -> Int {
        let remainder = y % Int(GOAL_ROW_HEIGHT)
        var anotherItem: Int
        if CGFloat(remainder) < GOAL_ROW_HEIGHT / 2 {
            //            拖拽到上面
            if itemIndex == 0 {
                anotherItem = 0
            } else {
                anotherItem = Int(goals[itemIndex - 1].pos)
            }
        } else {
            //            拖拽到下面
            if itemIndex == goals.count - 1 {
                anotherItem = MAX_POS
            } else {
                anotherItem = Int(goals[itemIndex + 1].pos)
            }
        }
        return Int((anotherItem + Int(item.pos)) / 2)
    }
    
    func dropEntered(info: DropInfo) {
        updateHighlight(info.location.y)
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        updateHighlight(info.location.y)
        return DropProposal(operation: .move)
    }
    
    func dropExited(info: DropInfo) {
    }

    func performDrop(info: DropInfo) -> Bool {
        if item.id != current?.id && current != nil {
            let y = info.location.y
            var newPos = caculateNewPos(Int(y))
            
            if (current!.pos == Int16(newPos)) {
                resetGoalPos()
                newPos = caculateNewPos(Int(y))
            }
            
            current!.pos = Int16(newPos)
            GlobalStore.shared.coreDataContainer.saveContext()
        }
        
        self.current = nil
        self.forceCollapse = false
        self.highlightIndex = nil
        
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
