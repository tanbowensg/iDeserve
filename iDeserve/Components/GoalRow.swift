//
//  GoalRow.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/10/26.
//

import SwiftUI

struct GoalRow: View {
    @ObservedObject var goal: Goal

    var body: some View {
        HStack {
            Text(goal.name ?? "")
            
        }
    }
}

//struct GoalRow_Previews: PreviewProvider {
//    static var previews: some View {
//        GoalRow()
//    }
//}
