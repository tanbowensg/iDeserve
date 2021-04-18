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
    
    @AppStorage(PRO_IDENTIFIER) var isPro = false
    @State private var draggedGoal: Goal?
    @State private var highlightIndex: Int? = nil
    @State private var isShowTasks = true
    @State private var isShowAlert = false
    @State private var isShowCompleteGoalView = false
    @State private var isShowHelp = false
    @State private var isShowPurchase = false
    @State private var completingGoal: Goal?
    @State private var deletingGoal: Goal?
    
//    用来跳转页面的
    @State private var currentTag: Goal? = nil
    
    @GestureState var isDetectingLongPress = false

    let padding: CGFloat = GOAL_ROW_PADDING

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
    
    var canCreateGoal: Bool {
//        isPro || goals.count < MAX_GOAL
        true
    }
    
    var reorderDivider: some View {
//        算法是index*（每一个目标高度+padding），然后减掉整个列表的上padding
        let offset = CGFloat(highlightIndex!) * (GOAL_ROW_HEIGHT + GOAL_ROW_PADDING * 2)

        return Divider()
            .offset(y: highlightIndex != nil ? offset - GOAL_ROW_PADDING : -666)
    }
    
    func undoneGoalItem(_ goal: Goal) -> some View {
        return
            GoalItemView(
                goal: goal,
                name: goal.name!,
                type: GoalType(rawValue: goal.type ?? "flag") ?? GoalType.hobby,
                importance: Importance(rawValue: Int(goal.importance)) ?? Importance.normal,
                taskNum: goal.tasks!.count,
                value: goal.value,
                progress: Float(goal.gotValue) / Float(goal.totalValue),
                isDone: goal.done,
                tasks: (goal.tasks!.allObjects as! [Task]).map{ $0.ts },
                isShowTasks: !isDetectingLongPress,
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
        .applyIf(false, apply: { content in
            content
                .onDrag {
                    print("拖拽了")
                    self.draggedGoal = goal
                    return NSItemProvider(object: goal.id!.uuidString as NSString)
                }
                .onDrop(
                    of: [UTType.text],
                    delegate: DragRelocateDelegate(
                        item: goal,
                        goals: undoneGoals,
                        current: $draggedGoal,
                        highlightIndex: $highlightIndex
                    )
                )
        })
        .alert(isPresented: $isShowAlert, content: { deleteConfirmAlert })
        .buttonStyle(PlainButtonStyle())
    }
    
    func doneGoalItem(_ goal: Goal) -> some View {
        return NavigationLink(destination: EditGoalPage(initGoal: goal)) {
            GoalItemView(
                goal: goal,
                name: goal.name!,
                type: GoalType(rawValue: goal.type ?? "flag") ?? GoalType.hobby,
                importance: Importance(rawValue: Int(goal.importance)) ?? Importance.normal,
                taskNum: goal.tasks!.count,
                value: goal.value,
                progress: Float(goal.gotValue) / Float(goal.totalValue),
                isDone: goal.done,
                onRightSwipe: {
                    deletingGoal = goal
                    isShowAlert.toggle()
                }
            )
        }
        .alert(isPresented: $isShowAlert, content: { deleteConfirmAlert })
        .buttonStyle(PlainButtonStyle())
    }
    
    var goalListView: some View {
        CustomScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 10.0) {
                VStack(spacing: 40.0) {
                    ForEach (undoneGoals, id: \.id) { goal in
                        undoneGoalItem(goal)
                    }
                }
                doneGoals.count <= 0 ? nil : Text("实现的目标").fontWeight(.medium).padding(.horizontal, 20.0)
                doneGoals.count <= 0 ? nil : VStack(spacing: 40.0) {
                    ForEach (doneGoals, id: \.id) { goal in
                        doneGoalItem(goal)
                    }
                }
            }
        }
        .padding(.vertical, 20.0)
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
            canCreateGoal ? NavigationLink(destination: EditGoalPage(initGoal: nil)) {
                CreateButton()
            } : nil
            !canCreateGoal ? Button(action: { isShowPurchase.toggle() }) {
                CreateButton()
            } : nil
            if isShowCompleteGoalView || isShowHelp {
                Rectangle().fill(Color.black.opacity(0.4)).animation(.none)
            }
        }
        .navigationBarHidden(true)
        .popup(isPresented: $isShowCompleteGoalView, type: .default, closeOnTap: false, closeOnTapOutside: true) {
            CompleteGoalView(
                goalReward: completingGoal?.goalReward,
                onClose: {
                    if let _goal = completingGoal {
                        withAnimation {
                            gs.goalStore.completeGoal(_goal)
                            isShowCompleteGoalView = false
                        }
                    }
                },
                openHelp: { isShowHelp.toggle() }
            )
        }
        .popup(isPresented: $isShowHelp, type: .default, closeOnTap: false, closeOnTapOutside: true) {
            HelpText(title: GOAL_RESULT_DESC_TITLE, text: GOAL_RESULT_DESC)
        }
        .popup(isPresented: $isShowPurchase, type: .default, closeOnTap: true, closeOnTapOutside: true) {
            NavigationLink(destination: PayPage()) {
                Text("点击购买PRO版本")
            }
        }
    }
}

struct TaskPage_Previews: PreviewProvider {
    let tasks = genMockTasks(CoreDataContainer.shared.context)
    
    static var previews: some View {
        GoalPage()
            .environment(\.managedObjectContext, CoreDataContainer.shared.context)
    }
}
