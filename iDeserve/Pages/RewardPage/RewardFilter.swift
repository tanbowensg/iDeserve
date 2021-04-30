//
//  RewardFilter.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/4/29.
//

import SwiftUI

enum RewardFilterType: CaseIterable {
    case createDesc
    case createAsc
    case valueDesc
    case valueAsc
}

struct RewardFilter: View {
    @Binding var filterType: RewardFilterType
    
    var body: some View {
        Menu {
            ForEach(RewardFilterType.allCases, id: \.self) { filter in
                Button(action: { filterType = filter}) {
                    Text(RewardFilterText[filter]!)
                }
            }
        } label: {
            HStack(spacing: 10.0) {
                Text(RewardFilterText[filterType]!)
                Image(systemName: "arrow.up.arrow.down")
            }
                .font(Font.footnoteCustom.weight(.bold))
                .padding(.vertical, 10)
                .padding(.horizontal, 18)
                .background(
                    Color.white
                        .cornerRadius(20)
                        .shadow(color: Color.darkShadow, radius: 10, x: 0, y: 2)
                )
                .foregroundColor(.b3)
        }
    }
}
