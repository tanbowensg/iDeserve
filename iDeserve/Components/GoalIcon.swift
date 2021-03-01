//
//  GoalIcon.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/3/1.
//

import SwiftUI

struct GoalIcon: View {
    var goalType: GoalType
    var size: CGFloat = 60
    
    var body: some View {
        Image(systemName: goalType.rawValue)
            .resizable()
//                .aspectRatio(1, contentMode: .fit)
            .padding(10)
            .scaledToFit()
            .frame(width: size, height: size)
            .background(Color.tagBg)
            .cornerRadius(size / 4)
            .foregroundColor(Color.tagColor)
    }
}

struct GoalIcon_Previews: PreviewProvider {
    static var previews: some View {
        GoalIcon(goalType: .health)
    }
}
