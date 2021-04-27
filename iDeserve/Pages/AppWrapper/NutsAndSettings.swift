//
//  SwiftUIView.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/4/26.
//

import SwiftUI

struct NutsAndSettings: View {
    var points: Int
    
    var nuts: some View {
        HStack(alignment: .center, spacing: -15) {
            Image("NutIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 30.0, height: 30.0)
                .zIndex(1)
                .offset(y: -2)
            AnimatedPoints(points: points)
                .padding(.trailing, 12)
                .frame(width: 70.0, height: 24.0, alignment: .trailing)
                .background(Color.nutBg)
                .cornerRadius(12)
        }
    }

    var settingsIcon: some View {
        NavigationLink(destination: SettingsPage()) {
            Image("gear")
                .resizable()
                .frame(width: 20.0, height: 20.0)
        }
    }

    var body: some View {
        HStack(alignment: .center) {
            nuts
            Spacer()
            settingsIcon
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        NutsAndSettings(points: 50000)
    }
}
