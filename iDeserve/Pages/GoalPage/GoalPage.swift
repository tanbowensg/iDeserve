//
//  TaskPage.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/10/5.
//

import SwiftUI
import CoreData
import UniformTypeIdentifiers

enum AlertType: Int, CaseIterable {
    case complete = 0
    case delete = 1
}

struct GoalPage: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var gs: GlobalStore
    
    @FetchRequest(fetchRequest: goalRequest) var goals: FetchedResults<Goal>
    
    @State private var draggedGoal: Goal?
    @State private var highlightIndex: Int? = nil
    @State private var isShowAlert = false
    @State private var isShowCompleteGoalView = false
    @State private var completingGoal: Goal?
    @State private var deletingGoal: Goal?
    
    let padding: CGFloat = 8

    static var goalRequest: NSFetchRequest<Goal> {
        let request: NSFetchRequest<Goal> = Goal.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Goal.pos, ascending: true)
        ]
        return request
    }
    
    var doneGoals: [Goal] {
        goals.filter{ $0.done }
    }

    var undoneGoals: [Goal] {
        goals.filter{ !$0.done }
    }
    
    var reorderDivider: some View {
        Divider()
            .offset(y: highlightIndex != nil ? CGFloat(highlightIndex! * Int(GOAL_ROW_HEIGHT)) + padding : -666)
    }
    
    func undoneGoalItem(_ goal: Goal) -> some View {
        return NavigationLink(destination: EditGoalPage(initGoal: goal)) {
            SwipeWrapper(
                content: GoalItemView(
                    name: goal.name!,
                    type: GoalType(rawValue: goal.type ?? "flag") ?? GoalType.hobby,
                    taskNum: goal.tasks!.count,
                    value: goal.value,
                    progress: Float(goal.gotValue) / Float(goal.totalValue),
                    isDone: goal.done
                ),
                height: Int(GOAL_ROW_HEIGHT),
                onLeftSwipe: {
                    withAnimation {
                        isShowCompleteGoalView = true
                        completingGoal = goal
                    }
                },
                onRightSwipe: {
                    deletingGoal = goal
                    isShowAlert.toggle()
                }
            )
            .alert(isPresented: $isShowAlert, content: { deleteConfirmAlert })
            .buttonStyle(PlainButtonStyle())
            .onDrag {
                self.draggedGoal = goal
                return NSItemProvider(object: goal.id!.uuidString as NSString)
            }
            .onDrop(
                of: [UTType.text],
                delegate: DragRelocateDelegate(
                    item: goal,
                    goals: undoneGoals,
                    padding: padding,
                    current: $draggedGoal,
                    highlightIndex: $highlightIndex
                )
            )
        }
    }
    
    func doneGoalItem(_ goal: Goal) -> some View {
        return NavigationLink(destination: EditGoalPage(initGoal: goal)) {
            SwipeWrapper(
                content: GoalItemView(
                    name: goal.name!,
                    type: GoalType(rawValue: goal.type ?? "flag") ?? GoalType.hobby,
                    taskNum: goal.tasks!.count,
                    value: goal.value,
                    progress: Float(goal.gotValue) / Float(goal.totalValue),
                    isDone: goal.done
                ),
                height: Int(GOAL_ROW_HEIGHT),
                onRightSwipe: {
                    deletingGoal = goal
                    isShowAlert.toggle()
                }
            )
            .alert(isPresented: $isShowAlert, content: { deleteConfirmAlert })
            .buttonStyle(PlainButtonStyle())
        }
        
    }
    
    var goalListView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10.0) {
                VStack(spacing: 0.0) {
                    ForEach (undoneGoals, id: \.id) { goal in
                        undoneGoalItem(goal)
                    }
                }
                doneGoals.count <= 0 ? nil : Text("实现的目标").fontWeight(.medium).padding(.leading, 20.0)
                doneGoals.count <= 0 ? nil : VStack(spacing: 0.0) {
                    ForEach (doneGoals, id: \.id) { goal in
                        doneGoalItem(goal)
                    }
                }
                .padding(.vertical, padding)
            }
        }
        .onDrop(
            of: [UTType.text],
            delegate: DropOutsideDelegate(
                current: $draggedGoal,
                highlightIndex: $highlightIndex
            )
        )
    }

    var deleteConfirmAlert: Alert {
        let confirmButton = Alert.Button.default(Text("删除")) {
            gs.goalStore.removeGoal(deletingGoal!)
        }
        let cancelButton = Alert.Button.cancel(Text("取消"))
        return Alert(
            title: Text("删除目标"),
            message: Text("确定要删除目标\(deletingGoal!.name!)吗？\n删除后无法恢复。"),
            primaryButton: confirmButton,
            secondaryButton: cancelButton
        )
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(spacing: 0.0) {
                AppHeader(points: gs.pointsStore.points, title: "目标任务")
                ZStack(alignment: .top) {
                    goalListView
                    highlightIndex != nil ? reorderDivider : nil
                }
            }
            VStack {
                NavigationLink(destination: EditGoalPage(initGoal: nil)) {
                    CreateButton()
                }
            }
            Popup(
                isVisible: $isShowCompleteGoalView,
                content: CompleteGoalView(
                    goalReward: completingGoal?.goalReward,
                    onClose: {
                        if let _goal = completingGoal {
                            withAnimation {
                                gs.goalStore.completeGoal(_goal)
                                isShowCompleteGoalView = false
                            }
                        }
                    }
                ),
                alignment: .center
            )
        }
        .navigationBarHidden(true)
    }
}

struct TaskPage_Previews: PreviewProvider {
    let tasks = genMockTasks(CoreDataContainer.shared.context)
    
    static var previews: some View {
        GoalPage()
            .environment(\.managedObjectContext, CoreDataContainer.shared.context)
    }
}