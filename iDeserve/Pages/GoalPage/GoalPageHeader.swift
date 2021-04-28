//
//  GoalPageHeader.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/4/28.
//

import SwiftUI

struct GoalPageHeader: View {
    var body: some View {
        ZStack(alignment: .topLeading) {
            Image("headerCover")
                .resizable()
                .frame(height: HEADER_HEIGHT + TASK_ROW_PADDING)
            Image("headerLeaf")
                .resizable()
                .frame(height: HEADER_HEIGHT)
            Image("fox")
                .resizable()
                .frame(width: 123.0, height: 121.0)
                .padding(.leading, 178)
                .padding(.top, 55)
            Text("目标列表")
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

struct GoalPageHeader_Previews: PreviewProvider {
    static var previews: some View {
        GoalPageHeader()
    }
}
