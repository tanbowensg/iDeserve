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
        Image(goalType.rawValue)
            .resizable()
//                .aspectRatio(1, contentMode: .fit)
            .padding(10)
            .scaledToFit()
            .frame(width: size, height: size)
            .background(Color.white.cornerRadius(size / 5).shadow(color: .darkShadow, radius: size / 5, x: 0, y: 0))
    }
}

struct GoalIcon_Previews: PreviewProvider {
    static var previews: some View {
        GoalIcon(goalType: .job)
    }
}
