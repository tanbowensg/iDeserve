//
//  CalendarGrid.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/1/4.
//

import SwiftUI

struct CalendarGrid: View {
    var dayStat: DayStat
    var isHighlight: Bool = false
    var isCurrentMonth: Bool = true
    let OpacityBase: Double = 160
    
    var day: Int {
        Calendar.current.dateComponents([Calendar.Component.day], from: dayStat.date).day!
    }
    
    var placeHolder: some View {
        Text("")
            .frame(width: CalendarGridSize, height: CalendarGridSize)
            .disabled(true)
    }
    
    var foregroundColor: Color {
        if dayStat.income == 0  {
            return Color.body
        } else if Double(dayStat.income) / OpacityBase < 0.6 {
            return Color.brandGreen
        } else {
            return Color.white
        }
    }
    
    var grid: some View {
        Text(isCurrentMonth ? String(day) : "")
            .font(.footnoteCustom)
            .foregroundColor(foregroundColor)
            .frame(width: CalendarGridSize, height: CalendarGridSize)
            .background(dayStat.income > 0 ?
                Color.brandGreen
                .opacity(Double(dayStat.income) / OpacityBase).cornerRadius(CalendarGridSize / 4):
                nil
            )
            .applyIf(isHighlight, apply: { content in
                content.roundBorder(isHighlight ? Color.darkBrandGreen : Color.white, width: 2, cornerRadius: CalendarGridSize / 4)
            })
            .animation(.easeInOut(duration: 0.1), value: isHighlight)
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
