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
    @State private var isShowAlert = false
    @State private var isShowCompleteGoalView = false
    @State private var isShowHelp = false
    @State private var isShowPurchase = false
    @State private var completingGoal: Goal?
    @State private var deletingGoal: Goal?

    let padding: CGFloat = GOAL_ROW_PADDING

    let safeAreaHeight: CGFloat = (UIApplication.shared.windows.first?.safeAreaInsets.top)!

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
        isPro || goals.count < MAX_GOAL
    }
    
    var reorderDivider: some View {
//        算法是index*（每一个目标高度+padding）
        let offset = CGFloat(highlightIndex!) * (GOAL_ROW_HEIGHT + GOAL_ROW_PADDING * 2)

        return ExDivider()
            .offset(y: highlightIndex != nil ? offset : -666)
    }
    
    func undoneGoalItem(_ goal: Goal) -> some View {
        return GoalItemView(
            goal: goal,
            hideTasks: draggedGoal != nil,
            onLeftSwipe: {
                isShowCompleteGoalView = true
                completingGoal = goal
            },
            onRightSwipe: {
                deletingGoal = goal
                isShowAlert.toggle()
            }
        )
        .onDrag {
            withAnimation {
                self.draggedGoal = goal
            }
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
        
        .onChange(of: highlightIndex, perform: { _ in
            viberate()
        })
        .alert(isPresented: $isShowAlert, content: { deleteConfirmAlert })
        .buttonStyle(PlainButtonStyle())
    }
    
    func doneGoalItem(_ goal: Goal) -> some View {
        return GoalItemView(
            goal: goal,
            onRightSwipe: {
                deletingGoal = goal
                isShowAlert.toggle()
            }
        )
        .alert(isPresented: $isShowAlert, content: { deleteConfirmAlert })
        .buttonStyle(PlainButtonStyle())
    }
    
    var goalListView: some View {
        CustomScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 10.0) {
                VStack(spacing: 0.0) {
                    ForEach (undoneGoals, id: \.id) { goal in
                        undoneGoalItem(goal)
                    }
                }
                doneGoals.count <= 0 ? nil : Text("实现的目标").font(.subheadCustom).foregroundColor(.b3).fontWeight(.medium).padding(.horizontal, 20.0)
                doneGoals.count <= 0 ? nil : VStack(spacing: 0.0) {
                    ForEach (doneGoals, id: \.id) { goal in
                        doneGoalItem(goal)
                    }
                }
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
        let confirmButton = Alert.Button.destructive(Text("删除")) {
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

    var goalLimitAlert: Alert {
        let confirmButton = Alert.Button.default(Text("购买 Pro 版")) {
            gs.isShowPayPage = true
        }
        return Alert(
            title: Text("目标数量达到上限"),
            message: Text(GOAL_LIMIT_ALERT),
            primaryButton: confirmButton,
            secondaryButton: Alert.Button.cancel(Text("以后再说"))
        )
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ZStack(alignment: .top) {
                Image("headerBg")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.size.width)
                    .ignoresSafeArea()
                VStack(spacing: 0.0) {
                    AppHeader(title: "目标列表", image: "fox")
                    ZStack(alignment: .top) {
                        goalListView
                        highlightIndex != nil ? reorderDivider : nil
                    }
                }
            }
            canCreateGoal ? NavigationLink(destination: EditGoalPage(initGoal: nil)) {
                CreateButton().padding(25)
            } : nil
            !canCreateGoal ? Button(action: { isShowPurchase.toggle() }) {
                CreateButton().padding(25)
            } : nil
            isShowCompleteGoalView || isShowHelp ? PopupMask() : nil
        }
        .ignoresSafeArea()
        .navigationBarHidden(true)
        .popup(isPresented: $isShowCompleteGoalView, type: .default, animation: .default, closeOnTap: false, closeOnTapOutside: true) {
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
            HelpTextModal(title: GOAL_RESULT_DESC_TITLE, text: GOAL_RESULT_DESC)
        }
        .alert(isPresented: $isShowPurchase, content: { goalLimitAlert })
        .onChange(of: isShowCompleteGoalView, perform: { value in
            gs.isShowMask = value
        })
    }
}

struct TaskPage_Previews: PreviewProvider {
    let tasks = genMockTasks(CoreDataContainer.shared.context)
    
    static var previews: some View {
        GoalPage()
            .environment(\.managedObjectContext, CoreDataContainer.shared.context)
    }
}
