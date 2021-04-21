//
//  GoalIcon.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/3/1.
//

import SwiftUI

struct GoalIcon: View {
    var goalType: GoalType
    var size: CGFloat = 70
    
    var body: some View {
        Image(goalType.rawValue)
            .resizable()
            .scaledToFit()
            .cornerRadius(size / 5)
            .frame(width: size, height: size)
            .shadow(color: .darkShadow, radius: size / 5, x: 0, y: 0)
    }
}

struct GoalIcon_Previews: PreviewProvider {
    static var previews: some View {
        GoalIcon(goalType: .study)
    }
}
