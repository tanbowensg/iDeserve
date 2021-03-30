//
//  GoalTaskItem.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/3/30.
//

import SwiftUI

struct SimpleTaskItem: View {
    var task: TaskState
    var onRemoveTask: (() -> Void)

    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center) {
                Text(task.name)
                    .font(.subheadline)
                    .foregroundColor(.black333)
                Spacer()
                NutIcon(value: task.value, hidePlus: true)
                Button(action: { onRemoveTask() }) {
                    Image(systemName: "xmark")
                        .resizable()
                        .font(Font.subheadCustom.weight(.black))
                        .foregroundColor(.subtitle)
                        .frame(width: 6, height: 6)
                        .padding(5)
                        .background(Color.placeholder.cornerRadius(8))
                }
            }
            .padding(.vertical, 20.0)
            ExDivider()
        }
        .padding(.horizontal, 25)
    }
}

struct GoalTaskItem_Previews: PreviewProvider {
    static var previews: some View {
        SimpleTaskItem(task: TaskState(nil), onRemoveTask: emptyFunc)
    }
}
