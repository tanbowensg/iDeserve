//
//  GoalIcon.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/3/1.
//

import SwiftUI

struct TypeIcon: View {
    var type: String
    var size: CGFloat = 60
    
    var body: some View {
        Image(type)
            .resizable()
            .scaledToFit()
            .cornerRadius(size / 5)
            .frame(width: size, height: size)
            .shadow(color: .darkShadow, radius: size / 5, x: 0, y: 0)
    }
}

struct GoalIcon_Previews: PreviewProvider {
    static var previews: some View {
        TypeIcon(type: GoalType.study.rawValue)
    }
}
