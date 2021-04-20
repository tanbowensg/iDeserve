//
//  GoalTypePicker.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/3/1.
//

import SwiftUI
import UIKit

struct GoalTypePicker: View {
    @Binding var selectedType: GoalType
    @Binding var isShow: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30.0) {
            Image(systemName: "xmark")
                .foregroundColor(.b2)
                .frame(width: 9.0, height: 9.0)
                .padding(.leading, 25)
                .onTapGesture {
                    isShow.toggle()
                }
            HStack {
                Spacer()
                GridStack(rows: 2, columns: 3) { (i, j) in
                    let index = i * 3 + j
                    let type = index <= GoalType.allCases.count - 1 ? GoalType.allCases[index] : GoalType.none
                    //  none类型的目标不展示，仅仅是占位
                    type == GoalType.none ? nil :
                        Button(action: {
                            selectedType = type
                            isShow.toggle()
                        }) {
                            VStack(spacing: 8.0) {
                                GoalIcon(goalType: type, size: 100)
                                Text(GoalTypeText[type] ?? "")
                                    .foregroundColor(.b2)
                                    .font(.subheadCustom)
                            }
                        }
                }
                Spacer()
            }
        }
        .padding(.top, 20.0)
        .padding(.bottom, 58 + (UIApplication.shared.windows.first?.safeAreaInsets.top)!)
        .background(Color.white)
    }
}

//struct GoalTypePicker_Previews: PreviewProvider {
//    static var previews: some View {
//        GoalTypePicker()
//    }
//}
