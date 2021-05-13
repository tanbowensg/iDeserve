//
//  PopupMask.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/5/13.
//

import SwiftUI

struct PopupMask: View {
    var body: some View {
        Color.popupMask.ignoresSafeArea()
    }
}

struct PopupMask_Previews: PreviewProvider {
    static var previews: some View {
        PopupMask()
    }
}
