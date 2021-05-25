//
//  BackupPage.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/5/25.
//

import SwiftUI

struct BackupPage: View {
    @EnvironmentObject var gs: GlobalStore
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @AppStorage(PRO_IDENTIFIER) var isPro = false
    @AppStorage(AUTO_BACKUP) var autoBackup = false
    @State var backupDate: Date?
    @State var alertItem: AlertItem?

    var payAlert: AlertItem {
        let confirmButton = Alert.Button.default(Text("购买 Pro 版")) {
            gs.isShowPayPage = true
        }
        return AlertItem(
            title: Text("购买 Pro 版"),
            message: Text(BACKUP_DATA_PAY_ALERT),
            primaryButton: confirmButton,
            secondaryButton: Alert.Button.cancel(Text("以后再说"))
        )
    }
    
    var confirmRestoreAlert: AlertItem {
        let confirmButton = Alert.Button.default(Text("还原")) {
            restoreData()
            alertItem = restoreSuccessAlert
        }
        return AlertItem(
            title: Text("还原数据"),
            message: Text("还原数据将会用云端的数据完全覆盖当前的所有数据。确定要还原吗？"),
            primaryButton: confirmButton,
            secondaryButton: Alert.Button.cancel(Text("取消"))
        )
    }
    
    var restoreSuccessAlert: AlertItem {
        return AlertItem(
            title: Text("还原数据成功！")
        )
    }
    
    var backupSuccessAlert: AlertItem {
        return AlertItem(
            title: Text("备份数据成功！")
        )
    }
    
    var enableICloudAlert: AlertItem {
        let confirmButton = Alert.Button.default(Text("确定")) {
            presentationMode.wrappedValue.dismiss()
        }
        return AlertItem(
            title: Text("无法访问 iCloud"),
            message: Text("请前往手机的设置界面登录 Apple Id，并开启 iCloud 权限。"),
            secondaryButton: confirmButton
        )
    }

    func btnText(_ text: String, _ image: String) -> some View {
        VStack(alignment: .center, spacing: 10.0) {
            Image(image)
                .resizable()
                .frame(width: 100.0, height: 100.0)
            Text(text)
                .font(.subheadCustom)
        }
        .frame(width: 126.0, height: 126.0)
        .padding(16)
        .background(Color.white)
        .cornerRadius(25)
        .shadow(color: Color.darkShadow, radius: 10, x: 0, y: 0)
    }

    var body: some View {
        VStack(spacing: 0.0) {
            FormItem(
                name: "最近备份于",
                rightContent: backupDate == nil ? Text("暂无备份") : Text(dateToString(backupDate!, timeStyle: .medium))
            )
            FormItem(
                name: "自动备份",
                rightContent: Toggle("", isOn: $autoBackup)
            )

            Spacer()
            
            HStack(alignment: .center, spacing: 25.0) {
                Button(action: {
                    if isPro {
                        backupData()
                        updateDate()
                        alertItem = backupSuccessAlert
                    } else {
                        alertItem = payAlert
                    }
                }) {
                    btnText("备份数据", "upload")
                }
                
                Button(action: {
                    if isPro {
                        alertItem = confirmRestoreAlert
                    } else {
                        alertItem = payAlert
                    }
                }) {
                    btnText("还原数据", "download")
                }
            }
        }
        .padding(25.0)
        .alert(item: $alertItem) { item in
            if item.primaryButton == nil {
                return Alert(title: item.title, message: item.message, dismissButton: item.secondaryButton)
            } else {
                return Alert(title: item.title, message: item.message, primaryButton: item.primaryButton!, secondaryButton: item.secondaryButton!)
            }
        }
        .navigationBarTitle("iCloud 数据备份")
        .onAppear {
            if CloudHelper.shared.isCloudEnabled() {
                updateDate()
            } else {
                alertItem = enableICloudAlert
            }
        }
    }
    
    func updateDate() {
        backupDate = CloudHelper.shared.getICloudBackUpDataDate()
    }
}

struct BackupPage_Previews: PreviewProvider {
    static var previews: some View {
        BackupPage()
    }
}
