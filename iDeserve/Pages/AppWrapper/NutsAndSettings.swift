//
//  SwiftUIView.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/4/26.
//

import SwiftUI

struct NutsAndSettings: View {
    @AppStorage(POINTS) var points = 0
    
    var nuts: some View {
        HStack(alignment: .center, spacing: -30) {
            Image("NutIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 36.0, height: 36.0)
                .zIndex(1)
                .offset(y: -2)
            AnimatedPoints(points: points)
                .padding(.trailing, 12)
                .frame(width: 100.0, height: 32.0, alignment: .trailing)
                .background(Color.nutBg)
                .cornerRadius(16)
        }
    }

    var settingsIcon: some View {
        NavigationLink(destination: SettingsPage()) {
            Image("gear")
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .padding(4)
                .background(
                    Color.white
                        .cornerRadius(10)
                        .shadow(color: Color.darkShadow, radius: 10, x: 0, y: 2)
                )
        }
        .buttonStyle(PlainButtonStyle())
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
        NutsAndSettings()
    }
}
