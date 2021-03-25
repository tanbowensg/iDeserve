//
//  EditRewardPage.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/10/5.
//

import SwiftUI

struct EditRewardPage: View {
    @EnvironmentObject private var gs: GlobalStore
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var initReward: Reward?

    @State var name: String = ""
    @State var type: RewardType = RewardType.entertainment
    @State var value: String = ""
    @State var isRepeat = true
    @State var desc = ""
    @State var cover: UIImage? = nil

    @State var isShowImagePicker: Bool = false
    @State var isShowTypePicker = false
    @State var isShowHelp = false

    @State var image: Image? = nil

    init (initReward: Reward?) {
        self.initReward = initReward
        if let existReward = initReward {
            _name = State(initialValue: existReward.name ?? "")
            _type = State(initialValue: RewardType.init(rawValue:existReward.type ?? "food") ?? RewardType.entertainment)
            _value = State(initialValue: String(existReward.value))
            _isRepeat = State(initialValue: existReward.isRepeat)
            _desc = State(initialValue: existReward.desc ?? "")
            
            if let existCover = existReward.cover {
                _cover = State(initialValue: UIImage(data: existCover))
            }
        }
    }

    var rewardTitle: some View {
        Group {
            TextField("奖励标题", text: $name)
                .font(.headlineCustom)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 16.0)
                .frame(height: 56)
            Divider()
        }
    }

    var rewardType: some View {
        Button(action: { isShowTypePicker.toggle() }) {
            FormItem(
                name: "类别",
                valueView: Text(RewardTypeText[type] ?? "未知类别")
            )
        }
    }

    var rewardValue: some View {
        FormItem(
            name: "所需坚果数",
            valueView: TextField("10", text: $value)
                .multilineTextAlignment(.trailing)
                .keyboardType(.numberPad),
            onClickHelp: { isShowHelp.toggle() }
        )
    }

    var rewardRepeat: some View {
        FormItem(
            name: "可重复兑换",
            valueView: Toggle("", isOn: $isRepeat)
        )
    }

//    @ViewBuilder var coverImage: some View {
//        if let existCover = cover {
//            Image(uiImage: existCover)
//                .resizable()
//                .aspectRatio(4/3, contentMode: .fit)
//        }
//        Group {
//            Button(action: {
//                self.isShowImagePicker.toggle()
//            }) {
//                Image(systemName: "photo")
//                Text("选择封面图片")
//                Spacer()
//            }
//            .sheet(isPresented: $isShowImagePicker) {
//                SUImagePickerView(sourceType:.photoLibrary, image: self.$cover, isPresented: self.$isShowImagePicker)
//            }
//            .padding(.horizontal, 16.0)
//            .foregroundColor(.g80)
//
//            Divider()
//        }
//    }

    var backBtn: some View {
        Button(action: {
            self.saveReward()
            self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.left")
                    .padding(.leading, 16.0)
                    
                Text("返回")
                    .frame(height: 30)
            }
        }
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(alignment: .leading) {
                backBtn
//                coverImage
                rewardTitle
                rewardType
                rewardValue
                rewardRepeat
                Spacer()
            }
                .frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    minHeight: 0,
                    maxHeight: .infinity,
                    alignment: .topLeading
                )
                .navigationBarHidden(true)
            MyPopup(isVisible: $isShowTypePicker, content: RewardTypePicker(selectedType: $type))
            MyPopup(isVisible: $isShowHelp, content: HelpText(title: REWARD_VALUE_DESC_TITLE, text: REWARD_VALUE_DESC), alignment: .center, background: nil)
        }
    }
    
    func saveReward () {
        if name == "" {
            return
        }
        if initReward?.id != nil {
            gs.rewardStore.updateReward(targetReward: initReward!, name: name, type: type, value: Int(value)!, isRepeat: isRepeat, desc: desc, cover: cover?.pngData())
        } else {
            gs.rewardStore.createReward(name: name, type: type, value: Int(value) ?? 10, isRepeat: isRepeat, desc: desc, cover: cover?.pngData())
        }
    }
}
//
//struct EditRewardPage_Previews: PreviewProvider {
//    static var previews: some View {
//        let rewardsStore = RewardsStore()
//        EditRewardPage(initReward:rewardsStore.rewards[0], rewardsStore: rewardsStore)
//        EditRewardPage(initReward: nil, rewardsStore: rewardsStore)
//    }
//}
