//
//  GridStack.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/3/3.
//

import SwiftUI

struct GridStack<Content: View>: View {
    let rows: Int
    let columns: Int
    let content: (Int, Int) -> Content

    var body: some View {
        VStack(spacing: 20.0) {
            ForEach(0 ..< rows, id: \.self) { row in
                HStack(spacing: 20.0) {
                    ForEach(0 ..< columns, id: \.self) { column in
                        content(row, column)
                    }
                }
            }
        }
    }

    init(rows: Int, columns: Int, @ViewBuilder content: @escaping (Int, Int) -> Content) {
        self.rows = rows
        self.columns = columns
        self.content = content
    }
}
//
//struct GridStack_Previews: PreviewProvider {
//    static var previews: some View {
//        GridStack()
//    }
//}
