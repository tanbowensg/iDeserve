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
    
    var header: some View {
        Group {
            HStack {
                Button(action: {
                    self.saveReward()
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.b2)
                        .font(Font.headlineCustom.weight(.bold))
                }
                Spacer()
                Text(initReward == nil ? "上架新奖励" : "修改奖励")
                    .font(.headlineCustom)
                    .fontWeight(.bold)
                    .foregroundColor(.b3)
                Spacer()
                Button(action: {
                        self.saveReward()
                        self.presentationMode.wrappedValue.dismiss()
                    
                }) {
                    Text("保存")
                        .font(.subheadCustom)
                        .fontWeight(.bold)
                        .foregroundColor(.brandGreen)
                }
            }
            .padding(.vertical, 30.0)
            .padding(.horizontal, 25.0)
            ExDivider()
        }
    }

    var rewardType: some View {
        Button(action: {
            withAnimation {
                dismissKeyboard()
                isShowTypePicker.toggle()
            }
        }) {
            TypeIcon(type: type.rawValue, size: 85)
                .frame(width: 100, height: 100, alignment: .center)
                .background(
                    Color.white
                        .cornerRadius(12)
                        .shadow(color: Color.darkShadow, radius: 10, x: 0, y: 2)
                )
        }
            .padding(.top, 20)
    }

    var rewardTitle: some View {
        TextField("奖励标题", text: $name)
            .font(Font.titleCustom.weight(.bold))
            .multilineTextAlignment(.center)
            .padding(.vertical, 20)
    }

    var rewardValue: some View {
        Group {
            FormItem(
                name: "所需坚果数",
                rightContent: TextField("10", text: $value)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.numberPad),
                onClickHelp: { isShowHelp.toggle() }
            )
            ExDivider()
        }
    }

    var rewardRepeat: some View {
        FormItem(
            name: "可重复兑换",
            rightContent: Toggle("", isOn: $isRepeat).toggleStyle(SwitchToggleStyle(tint: .brandGreen))
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

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0.0) {
                header
                VStack(alignment: .center, spacing: 0.0) {
                    rewardType
                    //                coverImage
                    rewardTitle
                    rewardValue
                    rewardRepeat
                    Spacer()
                }
                .padding(.horizontal, 25.0)
                .navigationBarHidden(true)
            }
            isShowTypePicker || isShowHelp ? PopupMask() : nil
        }
        .popup(
            isPresented: $isShowTypePicker,
            type: .floater(verticalPadding: 0),
            position: .bottom,
            animation: .easeOut(duration: 0.3),
            closeOnTap: false,
            closeOnTapOutside: false,
            view: { RewardTypePicker(selectedType: $type, isShow: $isShowTypePicker) }
        )
        .popup(isPresented: $isShowHelp, type: .default, animation: .easeOut(duration: 0.3), closeOnTap: true, closeOnTapOutside: true, view: {
            HelpTextModal(isShow: $isShowHelp, title: REWARD_VALUE_DESC_TITLE, text: REWARD_VALUE_DESC)
        })
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
