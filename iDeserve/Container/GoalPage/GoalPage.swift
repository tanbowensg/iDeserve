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
    @State private var showAlertType = AlertType.complete
    @State private var completingGoal: Goal?
    
    let padding: CGFloat = 8

    static var goalRequest: NSFetchRequest<Goal> {
        let request: NSFetchRequest<Goal> = Goal.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Goal.pos, ascending: true)
        ]
        return request
    }
    
    var reorderDivider: some View {
        Divider()
            .offset(y: highlightIndex != nil ? CGFloat(highlightIndex! * Int(GOAL_ROW_HEIGHT)) + padding : -666)
    }
    
    func completeConfirmAlert(_ goal: Goal) -> Alert {
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
    }

    func deleteConfirmAlert(_ goal: Goal) -> Alert {
        let confirmButton = Alert.Button.default(Text("删除")) {
            gs.goalStore.removeGoal(goal)
        }
        let cancelButton = Alert.Button.cancel(Text("取消"))
        return Alert(
            title: Text("删除目标"),
            message: Text("确定要删除目标\(goal.name!)吗？\n删除后无法恢复。"),
            primaryButton: confirmButton,
            secondaryButton: cancelButton
        )
    }
    
    func goalItem(_ goal: Goal) -> some View {
        return NavigationLink(destination: EditGoalPage(initGoal: goal)) {
            SwipeWrapper(
                content: GoalItemView(
                    name: goal.name!,
                    taskNum: goal.tasks!.count,
                    value: goal.value,
                    progress: Float(goal.gotValue) / Float(goal.totalValue)
                ),
                height: Int(GOAL_ROW_HEIGHT),
                onLeftSwipe: {
//                    isShowAlert.toggle()
//                    showAlertType = AlertType.complete
                    withAnimation {
                        isShowCompleteGoalView = true
                        completingGoal = goal
                    }
                },
                onRightSwipe: {
                    isShowAlert.toggle()
                    showAlertType = AlertType.delete
                }
            )
            .alert(isPresented: $isShowAlert, content: {
                switch showAlertType {
                    case .complete:
                        return completeConfirmAlert(goal)
                    case .delete:
                        return deleteConfirmAlert(goal)
                }
            })
            .buttonStyle(PlainButtonStyle())
            .onDrag {
                self.draggedGoal = goal
                return NSItemProvider(object: goal.id!.uuidString as NSString)
            }
            .onDrop(
                of: [UTType.text],
                delegate: DragRelocateDelegate(
                    item: goal,
                    goals: goals,
                    padding: padding,
                    current: $draggedGoal,
                    highlightIndex: $highlightIndex
                )
            )
        }
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(spacing: 0.0) {
                AppHeader(points: gs.pointsStore.points, title: "目标任务")
                ZStack(alignment: .top) {
                    ScrollView {
                        VStack(spacing: 0.0) {
                            ForEach (goals, id: \.id) { goal in
                                goalItem(goal)
                            }
                        }
                        .padding(.vertical, padding)
                    }
                    .onDrop(
                        of: [UTType.text],
                        delegate: DropOutsideDelegate(
                            current: $draggedGoal,
                            highlightIndex: $highlightIndex
                        )
                    )
                    highlightIndex != nil ? reorderDivider : nil
                }
            }
            VStack {
                NavigationLink(destination: EditGoalPage(initGoal: nil)) {
                    CreateButton()
                }
            }
                .padding([.trailing, .bottom], 16)
            Popup(
                isVisible: $isShowCompleteGoalView,
                content: CompleteGoalView(
                    goalReward: completingGoal?.goalReward,
                    onClose: { withAnimation { isShowCompleteGoalView = false } }
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
