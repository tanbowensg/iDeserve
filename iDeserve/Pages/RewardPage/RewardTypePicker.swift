//
//  RewardTypePicker.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/3/1.
//

import SwiftUI

struct RewardTypePicker: View {
    @Binding var selectedType: RewardType

    var body: some View {
        HStack {
            Spacer()
            GridStack(rows: 2, columns: 3) { (i, j) in
                let type = RewardType.allCases[i * 2 + j]
                let color: Color = RewardTypeColorMap[type] ?? Color.red
                VStack(spacing: 8.0) {
                    Text("")
                        .frame(width: 100, height: 100, alignment: .center)
                        .background(color)
                        .cornerRadius(50)
                        .roundBorder(selectedType == type ? Color.rewardColor : Color.white, width: 2, cornerRadius: 50)
                    Text(RewardTypeText[type] ?? "")
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

//struct RewardTypePicker_Previews: PreviewProvider {
//    static var previews: some View {
//        RewardTypePicker()
//    }
//}
