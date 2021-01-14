//
//  MyWebview.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/1/14.
//

import SwiftUI
import Combine
import WebKit

struct MyWebView: UIViewRepresentable {
    var url: URL?     // optional, if absent, one of below search servers used
    @Binding var reload: Bool

    private let urls = [URL(string: "https://google.com/")!, URL(string: "https://bing.com")!]
    private let webview = WKWebView()

    fileprivate func loadRequest(in webView: WKWebView) {
        if let url = url {
            webView.load(URLRequest(url: url))
        } else {
            let index = Int(Date().timeIntervalSince1970) % 2
            webView.load(URLRequest(url: urls[index]))
        }
    }

    func makeUIView(context: Context) -> WKWebView {
        loadRequest(in: webview)
        return webview
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if reload {
            loadRequest(in: uiView)
            DispatchQueue.main.async {
                self.reload = false     // must be async
            }
        }
    }
}

//struct MyWebView_Previews: PreviewProvider {
//    @State var shouldRefresh = false
//
//    static var previews: some View {
//        MyWebView(url: URL(string: "https://www.baidu.com"), )
//    }
//}
