//
//  RewardTypePicker.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/3/1.
//

import SwiftUI

struct RewardTypePicker: View {
    @Binding var selectedType: RewardType
    @Binding var isShow: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 30.0) {
            Image(systemName: "xmark")
                .foregroundColor(.subtitle)
                .frame(width: 9.0, height: 9.0)
                .padding(.leading, 25)
                .onTapGesture {
                    isShow.toggle()
                }
            HStack {
                Spacer()
                GridStack(rows: 2, columns: 3) { (i, j) in
                    let type = RewardType.allCases[i * 3 + j]
                    if type != .system {
                        let color: Color = RewardColorMap[type] ?? Color.red
                        VStack(spacing: 8.0) {
                            Image(systemName: RewardIconMap[type] ?? "bag")
                                .frame(width: 100, height: 100, alignment: .center)
                                .background(color)
                                .foregroundColor(Color.white)
                                .cornerRadius(50)
                                .roundBorder(selectedType == type ? Color.rewardColor : Color.white, width: 2, cornerRadius: 50)
                            Text(RewardTypeText[type] ?? "")
                        }
                        .onTapGesture {
                            selectedType = type
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

//struct RewardTypePicker_Previews: PreviewProvider {
//    static var previews: some View {
//        RewardTypePicker()
//    }
//}
