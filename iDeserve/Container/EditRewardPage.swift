//
//  EditRewardPage.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/10/5.
//

import SwiftUI

struct EditRewardPage: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var initReward: Reward?

    @State var name: String = ""
    @State var value: String = "0"
    @State var repeatFrequency: RepeatFrequency = RepeatFrequency.never
    @State var desc = ""
    @State var cover: UIImage? = nil
    
    @State var isShowRepeatPicker = false
    @State var isShowImagePicker: Bool = false

    @State var image: Image? = nil

    init (initReward: Reward?) {
        self.initReward = initReward
        if let existReward = initReward {
            _name = State(initialValue: existReward.name ?? "")
            _cover = State(initialValue: UIImage(data: existReward.cover!))
            _value = State(initialValue: String(existReward.value))
            _repeatFrequency = State(initialValue: RepeatFrequency(rawValue: Int(existReward.repeatFrequency)) ?? RepeatFrequency.never)
            _desc = State(initialValue: existReward.desc ?? "")
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

    @ViewBuilder var coverImage: some View {
        if let existCover = cover {
            Image(uiImage: existCover)
                .resizable()
                .aspectRatio(4/3, contentMode: .fit)
        }
        Group {
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
        if initReward?.id != nil {
            updateReward()
        } else {
            createReward()
        }
    }
    
    func updateReward () {
        let targetReward = initReward!
        targetReward.name = name
        targetReward.value = Int16(value) ?? 0
        targetReward.repeatFrequency = Int16(repeatFrequency.rawValue)
        targetReward.desc = desc
        targetReward.isSoldout = false
        targetReward.cover = cover?.pngData()

        do {
            try self.moc.save()
        } catch {
            fatalError("更新奖励到 coredata中失败")
        }
    }
    
    func createReward () {
        let newReward = Reward(context: self.moc)
        newReward.id = UUID()
        newReward.name = name
        newReward.value = Int16(value) ?? 0
        newReward.repeatFrequency = Int16(repeatFrequency.rawValue)
        newReward.desc = desc
        newReward.isSoldout = false
        newReward.cover = cover?.pngData()

        do {
            try self.moc.save()
        } catch {
            fatalError("创建奖励到 coredata中失败")
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
