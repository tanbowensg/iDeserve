//
//  GoalTasksSheet.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/10/26.
//

import SwiftUI

struct GoalTasksSheet: View {
    @Binding var taskState: TaskState
    var onSave: () -> Void
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var backBtn: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.left")
                Text("返回")
                    .frame(height: 30)
            }
        }
    }
    
    var saveBtn: some View {
        Button(action: {
            self.onSave()
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Text("保存")
                .frame(height: 30)
        }
    }

    var body: some View {
        TaskForm(
            taskState: $taskState,
            showGoal: false,
            onTapClose: { self.presentationMode.wrappedValue.dismiss() },
            onTapSave: {
                onSave()
                self.presentationMode.wrappedValue.dismiss()
            }
        )
    }
}

struct GoalTasksSheetPreviewWrapper: View {
    @State var taskState = TaskState(nil)

    var body: some View {
        GoalTasksSheet(taskState: $taskState, onSave: emptyFunc)
    }
}

struct GoalTasksSheet_Previews: PreviewProvider {
    static var previews: some View {
        GoalTasksSheetPreviewWrapper()
    }
}
