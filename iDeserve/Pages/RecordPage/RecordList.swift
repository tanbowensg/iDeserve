//
//  RecordList.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/1/11.
//

import SwiftUI

struct RecordList: View {
    var records: [Record]

    var subtotal: some View {
        let sum = records.reduce(0) { (result, record) -> Int in
            switch RecordKind(rawValue: Int(record.kind)) {
            case .reward:
                return result - Int(record.value)
            case .task:
                return result + Int(record.value)
            case .goal:
                return result + Int(record.value)
            default:
                return result
            }
        }
        return VStack(spacing: 0.0) {
            Divider()
            HStack(alignment: .center) {
                Text("总计")
                Spacer()
                NutIcon(value: sum)
            }
            .frame(height: 40.0)
            .padding(.horizontal, 16.0)
        }
        .background(Color.white)
    }

    var body: some View {
        return ZStack(alignment: .bottom) {
            ScrollView {
                VStack(spacing: 0.0) {
                    ForEach (records) { record in
                        RecordItem(record: record)
                    }
                }
                .padding(.bottom, 32.0)
            }
            records.count > 0 ? subtotal : nil
        }
        .font(.hiraginoSansGb14)
    }
}

struct RecordItem: View {
    var record: Record
    
    var icon: some View {
        let kind = RecordKind(rawValue: Int(record.kind))
        
        switch kind {
            case .goal:
                return Image(systemName: "list.dash")
            case .task:
                return Image(systemName: "checkmark")
            case .reward:
                return Image(systemName: "gift.fill")
            default:
                return Image(systemName: "list.dash")
        }
    }

    var body: some View {
        HStack(alignment: .center, spacing: 6.0) {
            icon
            Text(record.name!)
                .font(.hiraginoSansGb14w3)
            Spacer()
            NutIcon(value: Int(record.kind == RecordKind.reward.rawValue ? -record.value : record.value))
        }
        .padding(.horizontal, 16.0)
        .frame(height: 40.0)
    }
}

//
//struct RecordList_Previews: PreviewProvider {
//    static var previews: some View {
//        RecordList(records: [])
//    }
//}
