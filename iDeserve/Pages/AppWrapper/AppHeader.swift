//
//  AppHeader.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/1/3.
//

import SwiftUI

struct AppHeader: View {
    var title: String
    var image: String

    var body: some View {
        ZStack(alignment: .topLeading) {
            Image("headerCover")
                .resizable()
                .frame(height: HEADER_HEIGHT + TASK_ROW_PADDING)
            Image("headerLeaf")
                .resizable()
                .frame(height: HEADER_HEIGHT)
            Image(image)
                .resizable()
                .frame(width: 123.0, height: 121.0)
                .padding(.leading, 178)
                .padding(.top, 55)
            Text(title)
                .font(.titleCustom)
                .fontWeight(.bold)
                .foregroundColor(.b4)
                .padding(.top, 130)
                .padding(.leading, 25)
        }
        .ignoresSafeArea()
        .frame(width: UIScreen.main.bounds.size.width, height: HEADER_HEIGHT)
    }
}

struct AppHeader_Previews: PreviewProvider {
    static var previews: some View {
        AppHeader(title: "今日任务", image: "fox")
    }
}
