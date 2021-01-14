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

struct GoalPage: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var gs: GlobalStore
    
    @FetchRequest(fetchRequest: goalRequest) var goals: FetchedResults<Goal>
    
    @State private var draggedGoal: Goal?
    @State private var showAlert = false
    @State private var highlightIndex: Int? = 0

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
        VStack(spacing: 0.0) {
            AppHeader(points: gs.pointsStore.points, title: "目标任务")
            ZStack(alignment: .bottomTrailing) {
                ZStack(alignment: .top) {
                    ScrollView {
                        ForEach (goals, id: \.id) { goal in
                            NavigationLink(destination: EditGoalPage(initGoal: goal)) {
                                SwipeWrapper(
                                    content: GoalItem(
                                        name: goal.name!,
                                        taskNum: goal.tasks!.count,
                                        value: 188,
                                        progress: 0.32
                                    ),
                                    height: Int(GOAL_ROW_HEIGHT),
                                    onLeftSwipe: { showAlert = true },
                                    onRightSwipe: { gs.goalStore.removeGoal(goal) }
                                )
                                .alert(isPresented: $showAlert, content: {
                                    let confirmButton = Alert.Button.default(Text("完成")) {
                                        gs.goalStore.completeGoal(goal)
                                    }
                                    let cancelButton = Alert.Button.cancel(Text("取消"))
                                    return Alert(
                                        title: Text("完成目标"),
                                        message: Text("确定要完成\(goal.name!)吗？\n完成以后将开始结算完成目标的额外奖励。"),
                                        primaryButton: confirmButton,
                                        secondaryButton: cancelButton
                                    )
                                })
                            }
                            .buttonStyle(PlainButtonStyle())
//                            .onDrag {
//                                self.draggedGoal = goal
//                                return NSItemProvider(object: goal.id!.uuidString as NSString)
//                            }
//                            .onDrop(
//                                of: [UTType.text],
//                                delegate: DragRelocateDelegate(
//                                    item: goal,
//                                    goals: goals,
//                                    current: $draggedGoal,
//                                    highlightIndex: $highlightIndex
//                                )
//                            )
                        }
                    }
                    highlightIndex != nil ? reorderDivider : nil
                }
                VStack {
                    NavigationLink(destination: EditGoalPage(initGoal: nil)) {
                        CreateButton()
                    }
                }
                .padding([.trailing, .bottom], 16)
            }
        }
            .navigationBarHidden(true)
    }
}

struct DragRelocateDelegate: DropDelegate {
    let item: Goal
    var goals: FetchedResults<Goal>
    @Binding var current: Goal?
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
        print("dropEntered")
        updateHighlight(info.location.y)
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        updateHighlight(info.location.y)
        return DropProposal(operation: .move)
    }
    
    func dropExited(info: DropInfo) {
        print("dropExited")
    }

    func performDrop(info: DropInfo) -> Bool {
        withAnimation {
            print("performDrop")
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
            self.highlightIndex = nil
        }
        return true
    }
}
struct DropOutsideDelegate: DropDelegate {
    @Binding var current: Goal?
    @Binding var highlightIndex: Int?
        
    func performDrop(info: DropInfo) -> Bool {
        current = nil
        highlightIndex = nil
        return true
    }
}

struct TaskPage_Previews: PreviewProvider {
    let tasks = genMockTasks(CoreDataContainer.shared.context)
    
    static var previews: some View {
        GoalPage()
            .environment(\.managedObjectContext, CoreDataContainer.shared.context)
    }
}
