//
//  HelpText.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/3/10.
//

import SwiftUI

struct HelpText: View {
    var title: String
    var text: String
    
    var body: some View {
        VStack(spacing: 10.0) {
            Text(title).font(.headlineCustom).multilineTextAlignment(.center)
            Text(text).font(.bodyCustom).multilineTextAlignment(.leading).lineSpacing(8)
        }
        .frame(width: 240.0)
        .padding(25.0)
        .background(Color.white)
        .cornerRadius(25)
    }
}

struct HelpText_Previews: PreviewProvider {
    static var previews: some View {
        HelpText(title: GOAL_RESULT_DESC_TITLE, text: GOAL_RESULT_DESC)
    }
}
