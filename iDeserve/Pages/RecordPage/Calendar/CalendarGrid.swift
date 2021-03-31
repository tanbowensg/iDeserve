//
//  CalendarGrid.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/1/4.
//

import SwiftUI

struct CalendarGrid: View {
    var dayStat: DayStat
    var size: Int = 40
    var isHighlight: Bool = false
    var isCurrentMonth: Bool = true
    let OpacityBase: Double = 160
    let padding = 6
    
    var day: Int {
        Calendar.current.dateComponents([Calendar.Component.day], from: dayStat.date).day!
    }
    
    var placeHolder: some View {
        Text("")
            .frame(width: CGFloat(size), height: CGFloat(size))
            .disabled(true)
    }
    
    var foregroundColor: Color {
        if dayStat.income == 0  {
            return Color.body
        } else if Double(dayStat.income) / OpacityBase < 0.6 {
            return Color.hospitalGreen
        } else {
            return Color.white
        }
    }
    
    var grid: some View {
        Text(isCurrentMonth ? String(day) : "")
            .fontWeight(.medium)
            .font(.footnoteSmCustom)
            .foregroundColor(foregroundColor)
//            .frame(width: CGFloat(size - padding * 2), height: CGFloat(size - padding * 2))
            .frame(width: 24, height: 24)
            .background(dayStat.income > 0 ?
                Color.hospitalGreen
                .opacity(Double(dayStat.income) / OpacityBase).cornerRadius(7):
                nil
            )
            .frame(width: CGFloat(size), height: CGFloat(size))
//            .roundBorder(isHighlight ? Color.red : Color.white, width: 2, cornerRadius: 6)
            .scaleEffect(isHighlight ? 1.1 : 1)
            .animation(.easeInOut(duration: 0.1), value: isHighlight)
//            .padding(.all, CGFloat(padding))
            .id(dayStat.date)
    }

    var body: some View {
        if isCurrentMonth {
            grid
        } else {
            placeHolder
        }
    }
}

struct CalendarGrid_Previews: PreviewProvider {
    static var previews: some View {
        CalendarGrid(dayStat: DayStat(date: Date(), income: 10, outcome: 10))
    }
}
