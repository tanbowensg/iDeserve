//
//  RewardStore.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/10/7.
//

import Foundation

let DefaultRewards: [Reward] = [
    Reward(
        name: "去九寨沟旅行",
        value: 3500,
        cover: "https://www.jiuzhai.com/templates/rt_topaz/custom/images/325.jpg"
    ),
    Reward(
        name: "iPhone 12",
        value: 6188,
        cover: "https://n.sinaimg.cn/sinacn20190912ac/286/w1097h789/20190912/57c5-iepyyhh5827509.jpg"
    ),
    Reward(
        name: "一杯喜茶",
        value: 30,
        cover: "https://www.heytea.com/img/bg1.jpg",
        repeatFrequency: RepeatFrequency.daily
    ),
    Reward(
        name: "原神十连抽",
        value: 328,
        cover: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1602061007654&di=3ae5cf9e973aad09f99488e7648e93d5&imgtype=0&src=http%3A%2F%2Fwx2.sinaimg.cn%2Fcrop.0.39.1146.637%2F007ccotFgy1g3tld79wc7j30vu0jxarp.jpg",
        repeatFrequency: RepeatFrequency.daily
    ),
    Reward(
        name: "小棕瓶",
        value: 678,
        cover: "https://img.51wendang.com/pic/6c982b5f992fb009e1547aaa/2-810-jpg_6-1080-0-0-1080.jpg"
    ),
    Reward(
        name: "Filco红轴键盘",
        value: 1000,
        cover: "https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=1469704910,3774635822&fm=26&gp=0.jpg"
    ),
    Reward(
        name: "Anker 快充充电器",
        value: 129,
        cover: "https://m.media-amazon.com/images/I/71yHi77RUPL._AC_UY436_FMwebp_QL65_.jpg"
    ),
]

final class RewardsStore: ObservableObject {
    @Published var rewards: [Reward] = DefaultRewards
    
    func createReward (
        name: String,
        value: Int,
        cover: String,
        repeatFrequency: RepeatFrequency = .never,
        desc: String = ""
    ) {
        let newReward = Reward(
            id: UUID().uuidString,
            name: name,
            value: value,
            cover: cover,
            repeatFrequency: repeatFrequency,
            desc: desc
        )
        self.rewards += [newReward]
    }
    
    func deleteReward (id: String) {
        self.rewards.removeAll{ $0.id == id }
    }

    // 修改任务标题
    func changeRewardName (id: String, newName: String) {
        let index = self.rewards.firstIndex(where: { $0.id == id })!
        self.rewards[index].name = newName
    }
    
    func updateReward (
        id: String,
        name: String,
        value: Int,
        cover: String,
        repeatFrequency: RepeatFrequency,
        desc: String
    ) {
        let index = self.rewards.firstIndex(where: { $0.id == id })!
        self.rewards[index].name = name
        self.rewards[index].value = value
        self.rewards[index].cover = cover
        self.rewards[index].repeatFrequency = repeatFrequency
        self.rewards[index].desc = desc
    }
}
