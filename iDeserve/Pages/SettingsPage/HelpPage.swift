//
//  HelpPage.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/1/14.
//

import SwiftUI

struct HelpPage: View {
    @State private var shouldRefresh = false
    let faqDocumentUrl = "https://thoughts.teambition.com/share/605844ad2aee180046db20bd"

    var body: some View {
        VStack {
            MyWebView(url: URL(string: faqDocumentUrl), reload: $shouldRefresh)
        }
    }
}

struct HelpPage_Previews: PreviewProvider {
    static var previews: some View {
        HelpPage()
    }
}
