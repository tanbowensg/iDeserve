//
//  HelpPage.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/1/14.
//

import SwiftUI

struct HelpPage: View {
    @State private var shouldRefresh = false
    let faqDocumentUrl = "https://thoughts.teambition.com/share/5fd6e41b93dd7a0046a33105#5fd6d28012d5ba0001efb65f"

    var body: some View {
        VStack {
            MyWebView(url: URL(string: faqDocumentUrl), reload: $shouldRefresh)
        }
        .navigationBarHidden(true)
    }
}

struct HelpPage_Previews: PreviewProvider {
    static var previews: some View {
        HelpPage()
    }
}
