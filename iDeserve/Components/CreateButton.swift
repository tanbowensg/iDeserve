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
            .frame(width: 40, height: 40, alignment: .center)
            .font(.system(size: 16))
            .background(Color.brandGreen)
            .cornerRadius(32)
    }
}

struct CreateButton_Previews: PreviewProvider {
    static var previews: some View {
        CreateButton()
    }
}
