//
//  HelpText.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/3/10.
//

import SwiftUI

struct HelpTextModal: View {
    @Binding var isShow: Bool
    var title: String
    var text: String
    
    var body: some View {
        VStack(spacing: 25.0) {
            Text(title)
                .font(.bodyCustom)
                .fontWeight(.bold)
                .padding(.top, 25)
            Text(text)
                .font(.subheadCustom)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 25.0)
                .lineSpacing(8)
            Button(action: {
                isShow = false
            }) {
                Text("知道了")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .frame(width: 265.0, height: 60.0)
                    .background(Color.customOrange)
            }
        }
        .frame(width: 265.0)
        .background(Color.white)
        .cornerRadius(25)
        .shadow(color: .darkShadow, radius: 20, x: 0, y: 0)
    }
}

//struct HelpText_Previews: PreviewProvider {
//    static var previews: some View {
//        HelpTextModal(title: GOAL_RESULT_DESC_TITLE, text: GOAL_RESULT_DESC)
//    }
//}
