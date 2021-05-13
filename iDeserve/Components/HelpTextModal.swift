//
//  HelpText.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/3/10.
//

import SwiftUI

struct HelpTextModal: View {
    var title: String
    var text: String
    
    var body: some View {
        VStack(spacing: 16.0) {
            Text(title).font(.headlineCustom).fontWeight(.bold).multilineTextAlignment(.center)
            Text(text).font(.bodyCustom).multilineTextAlignment(.leading).lineSpacing(8)
        }
        .frame(width: 240.0)
        .padding(25.0)
        .background(Color.white.cornerRadius(25).shadow(color: .darkShadow, radius: 20, x: 0, y: 0))
    }
}

struct HelpText_Previews: PreviewProvider {
    static var previews: some View {
        HelpTextModal(title: GOAL_RESULT_DESC_TITLE, text: GOAL_RESULT_DESC)
    }
}
