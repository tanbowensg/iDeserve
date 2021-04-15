//
//  PayPage.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/4/15.
//

import SwiftUI

struct PayPage: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var gs: GlobalStore

    var body: some View {
        Button(action: {
            gs.iapHelper.buyProduct(productIdentifier: PRO_IDENTIFIER) { (success) in
                print("购买成功\(success)")
                self.presentationMode.wrappedValue.dismiss()
            }
        }) {
            Text("点击购买")
        }
    }
}

struct PayPage_Previews: PreviewProvider {
    static var previews: some View {
        PayPage()
    }
}
