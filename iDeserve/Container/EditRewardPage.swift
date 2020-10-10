//
//  EditRewardPage.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/10/5.
//

import SwiftUI

struct EditRewardPage: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var initReward: Reward?
    var rewardsStore: RewardsStore

    @State var name: String = ""
    @State var value: String = "0"
    @State var repeatFrequency: RepeatFrequency = RepeatFrequency.never
    @State var desc = ""
    @State var cover: UIImage? = nil
    
    @State var isShowRepeatPicker = false
    @State var isShowImagePicker: Bool = false

    @State var image: Image? = nil

    init (initReward: Reward?, rewardsStore: RewardsStore) {
        self.initReward = initReward
        self.rewardsStore = rewardsStore
        if let existReward = initReward {
            _name = State(initialValue: existReward.name)
            _value = State(initialValue: String(existReward.value))
            _repeatFrequency = State(initialValue: existReward.repeatFrequency)
            _desc = State(initialValue: existReward.desc)
        }
    }

    var rewardTitle: some View {
        Group {
            TextField("奖励标题", text: $name)
                .font(.title)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 16.0)
            Divider()
        }
    }

    var rewardValue: some View {
        Group {
            HStack() {
                Image(systemName: "dollarsign.circle")
                Text("分值")
                Spacer()
                TextField("0", text: $value)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.numberPad)
            }
                .padding(.horizontal, 16.0)
            Divider()
        }
    }

    var rewardRepeat: some View {
        Group {
            Button(action: {
                isShowRepeatPicker.toggle()
            }) {
                HStack() {
                    Image(systemName: "repeat")
                    Text("重复")
                    Spacer()
                    Text(getRepeatFrequencyText(repeatFrequency))
                }
                    .padding(.horizontal, 16.0)
                    .foregroundColor(.g80)
            }
            Divider()
        }
    }

//    重复频率选择器
    var repeatPicker: some View {
        VStack(alignment: .trailing, spacing: 0) {
            Button(action: {
                isShowRepeatPicker.toggle()
            }) {
                Text("完成")
            }
                .padding(8)
            Picker("重复频率", selection: $repeatFrequency) {
                ForEach(RepeatFrequency.allCases, id: \.self) {repeatOption in
                    Text(getRepeatFrequencyText(repeatOption)).tag(repeatOption)
                }
                .labelsHidden()
            }
        }
            .background(Color.g10)
    }

    var coverImage: some View {
        if let existCover = cover {
            return Image(uiImage: existCover)
                .resizable()
                .aspectRatio(4/3, contentMode: .fit)
        }
        return Group {
            Button(action: {
                self.isShowImagePicker.toggle()
            }) {
                Image(systemName: "photo")
                Text("选择封面图片")
                Spacer()
            }
            .sheet(isPresented: $isShowImagePicker) {
                SUImagePickerView(sourceType:.photoLibrary, image: self.$cover, isPresented: self.$isShowImagePicker)
            }
            .padding(.horizontal, 16.0)
            .foregroundColor(.g80)
            
            Divider()
        }
    }

    var backBtn: some View {
        Button(action: {
            self.saveReward()
            self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.left")
                    .padding(.leading, 16.0)
                    
                Text("返回")
            }
        }
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(alignment: .leading) {
                backBtn
                coverImage
                rewardTitle
                rewardValue
                rewardRepeat
                HStack() {
                    TextField("备注", text: $desc)
                        .padding(.horizontal, 16.0)
                }
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
            Popup(isVisible: isShowRepeatPicker, content: repeatPicker)
        }
    }
    
    func saveReward () {
        if name == "" {
            return
        }
        if let rewardId = initReward?.id {
            rewardsStore.updateReward(
                id: rewardId,
                name: name,
                value: Int(value) ?? 0,
                cover: initReward!.cover,
                repeatFrequency: repeatFrequency,
                desc: desc
            )
        } else {
            rewardsStore.createReward(
                name: name,
                value: Int(value) ?? 0,
                cover: DefaultRewards[3].cover,
                repeatFrequency: repeatFrequency,
                desc: desc
            )
        }
    }
}

struct EditRewardPage_Previews: PreviewProvider {
    static var previews: some View {
        let rewardsStore = RewardsStore()
        EditRewardPage(initReward:rewardsStore.rewards[0], rewardsStore: rewardsStore)
        EditRewardPage(initReward: nil, rewardsStore: rewardsStore)
    }
}
