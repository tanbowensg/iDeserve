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

    var columns: [GridItem] {
        let array = Array(1...3)
        return array.map { _ in GridItem(.adaptive(minimum: 80, maximum: .infinity)) }
    }

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
                LazyVGrid(
                    columns: columns,
                    alignment: .center,
                    spacing: 20
                ) {
                    ForEach(0...8, id: \.self) {i in
                        let type = RewardType.allCases[i]
                        Button(action: {
                            selectedType = type
                            isShow.toggle()
                        }) {
                            VStack(spacing: 8.0) {
                                Image(type.rawValue)
                                    .resizable()
                                    .scaledToFit()
                                    .cornerRadius(16)
                                    .frame(width: 80, height: 80)
                                    .shadow(color: .darkShadow, radius: 16, x: 0, y: 0)
                                Text(RewardTypeText[type] ?? "")
                                    .foregroundColor(.b2)
                                    .font(.subheadCustom)
                            }
                        }
                        .frame(width: 80)
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
