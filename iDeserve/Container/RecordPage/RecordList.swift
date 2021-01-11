//
//  RecordList.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/1/11.
//

import SwiftUI

struct RecordList: View {
    var records: [Record]
    
    func getNutIcon(_ value: Int) -> some View {
        return HStack(alignment: .center, spacing: 3.0) {
            Text("\(value >= 0 ? "+" : "")\(String(value))")
                .foregroundColor(value >= 0 ? Color.rewardColor : Color.red)
            Image("NutIcon")
                .resizable()
                .frame(width: 16.0, height: 16.0)
                .padding(/*@START_MENU_TOKEN@*/.all, 2.0/*@END_MENU_TOKEN@*/)
        }
    }
    
    var subtotal: some View {
        let sum = records.reduce(0) { (result, record) -> Int in
            switch RecordKind(rawValue: Int(record.kind)) {
            case .reward:
                return result - Int(record.value)
            case .task:
                return result + Int(record.value)
            default:
                return result
            }
        }
        return VStack(spacing: 0.0) {
            Divider()
            HStack {
                Text("总计")
                Spacer()
                getNutIcon(sum)
            }
            .background(Color.white)
        }
        .padding(.horizontal, 16.0)
    }

    var body: some View {
        return ZStack(alignment: .bottom) {
            ScrollView {
                VStack(spacing: 0.0) {
                    ForEach (records) { record in
                        HStack {
                            Text(record.name ?? "未知")
                            Spacer()
                            getNutIcon(Int(record.kind == RecordKind.task.rawValue ? record.value : -record.value))
                        }
                        .frame(height: 32)
                        .padding(.horizontal, 16.0)
                    }
                }
                .padding(.bottom, 32.0)
            }
            records.count > 0 ? subtotal : nil
        }
        .font(.hiraginoSansGb14)
    }
}
//
//struct RecordList_Previews: PreviewProvider {
//    static var previews: some View {
//        RecordList(records: [])
//    }
//}
