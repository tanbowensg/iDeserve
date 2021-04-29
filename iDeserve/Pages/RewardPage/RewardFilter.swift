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
            HStack(spacing: 4.0) {
                Text(RewardFilterText[filterType]!)
                Image(systemName: "arrow.up.arrow.down")
            }
            .font(.footnoteCustom)
            .foregroundColor(.b2)
        }
    }
}
//
//struct RewardFilter_Previews: PreviewProvider {
//    static var previews: some View {
//        RewardFilter()
//    }
//}
