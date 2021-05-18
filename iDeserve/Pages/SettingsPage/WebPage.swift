//
//  HelpPage.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/1/14.
//

import SwiftUI

struct WebPage: View {
    @State private var shouldRefresh = false
    var url: String

    var body: some View {
        VStack {
            MyWebView(url: URL(string: url), reload: $shouldRefresh)
        }
    }
}
