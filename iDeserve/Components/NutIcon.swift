//
//  NutIcon.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/1/14.
//

import SwiftUI

struct NutIcon: View {
    var value: Int
    var hidePlus = false

    var body: some View {
        HStack(alignment: .center, spacing: 3.0) {
            Text("\(value >= 0 && !hidePlus ? "+" : "")\(String(value))")
                .foregroundColor(value >= 0 ? Color.rewardColor : Color.red)
                .font(.avenirBlack14)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            Image("NutIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 16.0, height: 16.0)
                .padding(/*@START_MENU_TOKEN@*/.all, 2.0/*@END_MENU_TOKEN@*/)
        }
    }
}

struct NutIcon_Previews: PreviewProvider {
    static var previews: some View {
        NutIcon(value: 120)
    }
}
