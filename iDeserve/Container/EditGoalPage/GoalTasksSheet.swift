//
//  GoalTasksSheet.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/10/26.
//

import SwiftUI

struct GoalTasksSheet: View {
    @Binding var taskState: TaskState
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var backBtn: some View {
        Button(action: {
//            self.saveTask()
            self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.left")
                    .padding(.leading, 16.0)
                    
                Text("返回")
            }
        }
    }

    var body: some View {
        VStack(alignment: .leading) {
            backBtn
            TaskForm(taskState: $taskState)
        }
    }
}

struct GoalTasksSheetPreviewWrapper: View {
    @State var taskState = TaskState(nil)

    var body: some View {
        GoalTasksSheet(taskState: $taskState)
    }
}

struct GoalTasksSheet_Previews: PreviewProvider {
    static var previews: some View {
        GoalTasksSheetPreviewWrapper()
    }
}
