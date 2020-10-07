//
//  CreateButton.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/10/5.
//

import SwiftUI

struct CreateButton: View {
    var body: some View {
        Image(systemName: "plus")
            .foregroundColor(Color.white)
            .frame(width: 64, height: 64, alignment: .center)
            .font(.system(size: 32))
            .background(Color.blue)
            .cornerRadius(32)
    }
}

struct CreateButton_Previews: PreviewProvider {
    static var previews: some View {
        CreateButton()
    }
}
