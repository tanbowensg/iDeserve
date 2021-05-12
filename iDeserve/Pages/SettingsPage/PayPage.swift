//
//  PayPage.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/4/15.
//

import SwiftUI
import SwiftUIPager

struct Feature {
    var image: String
    var title: String
    var desc: String
}

let FeatureList = [
    Feature(image: "infinity", title: "无数量限制", desc: "你可以创建无限个目标和奖励"),
    Feature(image: "credit", title: "透支坚果", desc: "你的坚果数量可以变成负数，兑换坚果更灵活"),
    Feature(image: "reverse", title: "撤销历史记录", desc: "你可以撤销历史记录，恢复坚果数量"),
    Feature(image: "cloud", title: "数据云存储", desc: "你的数据可以通过 iCloud 备份")
]

struct PayPage: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var gs: GlobalStore
    
    @StateObject var page: Page = .first()
    
    var dots: some View {
        HStack(spacing: 10.0) {
            ForEach(0...FeatureList.count - 1, id: \.self) {i in
                Dot(isActive: page.index == i)
                    .onTapGesture {
                        withAnimation {
                            page.update(.new(index: i))
                        }
                    }
            }
        }
    }

    func featureView(_ feature: Feature) -> some View {
        return VStack(alignment: .center, spacing: 20.0) {
            Image(feature.image)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
            Text(feature.title)
                .font(.bodyCustom)
                .fontWeight(.bold)
            Text(feature.desc)
                .font(.footnoteCustom)
        }
        .background(Color.transparent)
    }
    
    var features: some View {
        VStack(spacing: 10.0) {
            Text("Pro 版特权")
                .font(.titleCustom)
                .fontWeight(.bold)
                .foregroundColor(.b4)
            Pager(
                page: page,
                data: [0, 1, 2, 3],
                id: \.self,
                content: { i in
                    featureView(FeatureList[i])
                })
                .frame(height: 175)
            dots
        }
        .padding(.horizontal, 25)
    }
    
    var price: some View {
        ZStack(alignment: .topLeading){
            VStack(spacing: 10.0) {
                Text("50元 / 永久")
                    .font(.footnoteCustom)
                    .foregroundColor(.b1)
                    .strikethrough()
                Text("25元 / 永久")
                    .font(.bodyCustom)
                    .foregroundColor(.b4)
                    .fontWeight(.bold)
            }
                .padding(16)
                .padding(.vertical, 20)
            Text("限时-50%")
                .font(.captionCustom)
                .padding([.top, .leading], 12.0)
                .padding([.bottom, .trailing], 4.0)
                .background(Color.customOrange)
                .foregroundColor(.white)
                .cornerRadius(8)
                .offset(x: -4, y: -8)
        }
        .roundBorder(Color.customOrange, width: 2, cornerRadius: 16)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark")
                    .foregroundColor(.b2)
                    .font(Font.headlineCustom.weight(.bold))
                    .padding(25)
            }
            VStack(spacing: 25) {
                features
                price
                Button(action: {
                    gs.iapHelper.buyProduct(productIdentifier: PRO_IDENTIFIER) { (success) in
                        print("购买成功\(success)")
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Text("立即购买坚果计划 Pro")
                        .font(.body)
                        .fontWeight(.bold)
                        .padding(16)
                        .padding(.horizontal, 25)
                        .background(Color.customOrange)
                        .foregroundColor(.white)
                        .cornerRadius(50)
                }
                Spacer()
            }
        }
            .background(
                Image("headerBg")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.size.width)
                    .ignoresSafeArea()
            )
            .navigationBarHidden(true)
    }
}

struct PayPage_Previews: PreviewProvider {
    static var previews: some View {
        PayPage()
    }
}
