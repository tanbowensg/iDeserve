//
//  AppHeader.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/1/3.
//

import SwiftUI

struct AppHeader: View {
    var points: Int
    var title: String
    
    var nuts: some View {
        HStack(alignment: .center, spacing: 2){
            Image("NutIcon")
                .resizable()
                .scaledToFit()
                .padding(6)
                .frame(width: 36.0, height: 36.0)
            Spacer()
            AnimatedPoints(points: points)
                .frame(height: 16.0)
        }
        .padding(.horizontal, 18.0)
        .frame(height: 48.0)
        .frame(maxWidth: 200.0)
        .background(Color.white)
        .cornerRadius(24)
    }
    
    var settingsIcon: some View {
        NavigationLink(destination: SettingsPage()) {
            Image(systemName: "gear")
                .resizable()
                .frame(width: 20.0, height: 20.0)
                .padding(.horizontal, 12.0)
                .padding(.vertical, 4.0)
                .background(Color("rewardGold"))
                .foregroundColor(.white)
                .cornerRadius(22)
        }
    }

    var body: some View {
        ZStack {
            HStack {
                Text(title)
                    .foregroundColor(.white)
                    .font(.titleCustom)
                    .lineLimit(1)
                Spacer()
                
                HStack(alignment: .center, spacing: 4.0) {
                    nuts
                    settingsIcon
                }
            }
        }
        .padding(.horizontal, 16.0)
        .frame(height: 120.0)
        .frame(minWidth: 0, maxWidth: .infinity)
        .background(Color.darkBrandGreen)
    }
}

struct AppHeader_Previews: PreviewProvider {
    static var previews: some View {
        AppHeader(points: 888, title: "今日任务")
    }
}
