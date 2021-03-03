//
//  GoalTypePicker.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/3/1.
//

import SwiftUI

struct GoalTypePicker: View {
    @Binding var selectedType: GoalType

    var body: some View {
        HStack {
            Spacer()
            GridStack(rows: 2, columns: 3) { (i, j) in
                let type = GoalType.allCases[i * 2 + j]
                VStack(spacing: 8.0) {
                    GoalIcon(goalType: type, size: 100)
                        .roundBorder(selectedType == type ? Color.rewardColor : Color.white, width: 2, cornerRadius: 25)
                    Text(GoalTypeText[type] ?? "")
                }
                .onTapGesture {
                    selectedType = type
                }
            }
            Spacer()
        }
        .frame(height: 260.0)
        .padding(.top, 20.0)
        .background(Color.white)
    }
}

//struct GoalTypePicker_Previews: PreviewProvider {
//    static var previews: some View {
//        GoalTypePicker()
//    }
//}
