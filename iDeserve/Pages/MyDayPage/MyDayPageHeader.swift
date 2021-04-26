//
//  MyDayPageHeader.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/4/26.
//

import SwiftUI

struct MyDayPageHeader: View {
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Color.headerBg
                .mask(LinearGradient(gradient: Gradient(colors: [Color.clear, Color.white]), startPoint: .bottom, endPoint: .init(x: 0.5, y: 0.5)))
                .ignoresSafeArea()
            Text("每日任务")
                .font(.titleCustom)
                .fontWeight(.bold)
                .foregroundColor(.customBrown)
                .padding(.bottom, 108)
                .padding(.leading, 25)
        }
        .frame(height: 360)
    }
}

struct MyDayPageHeader_Previews: PreviewProvider {
    static var previews: some View {
        MyDayPageHeader()
    }
}
