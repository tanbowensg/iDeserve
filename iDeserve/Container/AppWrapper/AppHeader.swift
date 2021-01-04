//
//  AppHeader.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/1/3.
//

import SwiftUI

struct AppHeader: View {
    var points: Int
    var title: String

    var body: some View {
        ZStack {
            HStack {
                Text(title)
                    .foregroundColor(.white)
                    .font(.hiraginoSansGb26)
                    .fontWeight(.black)
                    .lineLimit(1)
                Spacer()
                HStack(alignment: .center, spacing: 2){
                    Image("NutIcon")
                        .resizable()
                        .padding(6)
                        .frame(width: 36.0, height: 36.0)
                    Spacer()
                    Text(String(points))
                        .font(.avenirBlack36)
                        .fontWeight(.bold)
                        .foregroundColor(.rewardColor)
                        .frame(height: 16.0)
                }
                    .padding(.horizontal, 18.0)
                    .frame(height: 48.0)
                    .frame(maxWidth: 200.0)
                    .background(Color.white)
                    .cornerRadius(24)
            }
        }
        .padding(.horizontal, 16.0)
        .frame(height: 120.0)
        .frame(minWidth: 0, maxWidth: .infinity)
        .background(Color.headerGreen)
    }
}

struct AppHeader_Previews: PreviewProvider {
    static var previews: some View {
        AppHeader(points: 888, title: "我的一天")
    }
}
