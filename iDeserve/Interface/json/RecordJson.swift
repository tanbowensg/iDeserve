//
//  RecordJson.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/5/24.
//

import Foundation

struct RecordJson: Codable {
    var name: String
    var kind: Int16
    var value: Int16
    var date: Date
    
    init(r: Record) {
        name = r.name!
        kind = r.kind
        value = r.value
        date = r.date!
    }
}

func importRewardJson(recordJson: RecordJson) -> Record {
    let r = Record(context: CoreDataContainer.shared.context)
    r.id = UUID()
    r.name = recordJson.name
    r.kind = recordJson.kind
    r.value = recordJson.value
    r.date = recordJson.date
    return r
}
