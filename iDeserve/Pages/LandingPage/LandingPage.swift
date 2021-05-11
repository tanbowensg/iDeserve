//
//  LandingPage.swift
//  哑铃
//
//  Created by 谈博文 on 2021/4/13.
//

import SwiftUI
import UIKit
import SwiftUIPager

struct Dot: View {
    var isActive = false
    
    var body: some View {
        Circle()
            .fill(isActive ? Color.customOrange : Color.g1)
            .frame(width: 8.0, height: 8.0)
    }
}

struct LandingPage: View {
    @AppStorage(HAS_LANDED) var hasLanded = false
    @StateObject var page: Page = .first()
    
    var dots: some  View {
        HStack(spacing: 10.0) {
            ForEach(0...3, id: \.self) {i in
                Dot(isActive: page.index == i)
                    .onTapGesture {
                        withAnimation {
                            page.update(.new(index: i))
                        }
                    }
            }
        }
    }
    
    var firstPage: some View {
        VStack {
            Spacer()
            Text("创建你的目标")
            Spacer()
        }
        .background(Color.white)
    }
    
    var secondPage: some View {
        VStack {
            Spacer()
            Text("上架你的奖励")
            Spacer()
        }
        .background(Color.white)
    }
    
    var thirdPage: some View {
        VStack {
            Spacer()
            Text("兑换奖励！")
            Spacer()
        }
        .background(Color.white)
    }

    var fourthPage: some View {
        VStack {
            Spacer()
            Button(action: {
                hasLanded = true
            }) {
                Spacer()
                Text("开始！")
                    .font(.system(size: 15))
                Spacer()
            }
            .frame(height: 35.0)
            .background(Color.brandGreen.cornerRadius(8))
            .foregroundColor(.white)
            Spacer()
        }
        .background(Color.white)
    }
    
    var body: some View {
        VStack {
            Pager(
                page: page,
                data: [0, 1, 2, 3],
                id: \.self,
                content: { i in
                    HStack(alignment: .center, spacing: 0.0) {
                        i == 0 ? firstPage : nil
                        i == 1 ? secondPage: nil
                        i == 2 ? thirdPage: nil
                        i == 3 ? fourthPage: nil
                    }
                })
            dots
        }
        .padding(16)
        .frame(width: UIScreen.main.bounds.width)
    }
}

struct LandingPage_Previews: PreviewProvider {
    static var previews: some View {
        LandingPage()
    }
}
