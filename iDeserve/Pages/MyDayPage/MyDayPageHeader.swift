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
            Image("headerCover")
                .resizable()
                .frame(height: HEADER_HEIGHT)
            Image("headerLeaf")
                .resizable()
                .frame(height: HEADER_HEIGHT)
            Image("squirrel")
                .resizable()
                .frame(width: 123.0, height: 121.0)
                .padding(.leading, 178)
                .padding(.bottom, 32)
            Text("每日任务")
                .font(.titleCustom)
                .fontWeight(.bold)
                .foregroundColor(.customBrown)
                .padding(.bottom, 46)
                .padding(.leading, 25)
        }
        .ignoresSafeArea()
        .frame(width: UIScreen.main.bounds.size.width, height: HEADER_HEIGHT)
    }
}

struct MyDayPageHeader_Previews: PreviewProvider {
    static var previews: some View {
        MyDayPageHeader()
    }
}
