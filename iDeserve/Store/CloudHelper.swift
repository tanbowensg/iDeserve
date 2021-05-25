//
//  CloudHelper.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/5/20.
//

import Foundation
import CloudKit
import FileProvider

class CloudHelper {
    static let shared = CloudHelper() // Singleton
    
    let localDocumentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("coredata.backup")
    let iCloudURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)
    
    var iCloudDocumentsURL: URL {
        iCloudURL!.appendingPathComponent("Documents").appendingPathComponent("coredata.backup")
    }
    
    func isCloudEnabled() -> Bool {
        if iCloudURL != nil { return true }
        else { return false }
    }

    func getICloudBackUpDataDate() -> Date? {
        do {
            let isExist = FileManager.default.fileExists(atPath: iCloudDocumentsURL.path)
            if isExist {
                let data = try FileManager.default.attributesOfItem(atPath: iCloudDocumentsURL.path)
                return data[FileAttributeKey.creationDate] as? Date
            }
        } catch {
            print("获取备份文件日期失败")
        }
        return nil
    }
    
    func save(data: Data) {
        do {
            if FileManager.default.fileExists(atPath: iCloudDocumentsURL.path) {
                try FileManager.default.removeItem(at: iCloudDocumentsURL)
            }
            try data.write(to: iCloudDocumentsURL)
        } catch let error  {
            print(error)
            print("写入错误")
        }
    }
    func read() -> TotalJsonData? {
        do {
            let isExist = FileManager.default.fileExists(atPath: iCloudDocumentsURL.path)
            if !isExist {
                try FileManager.default.startDownloadingUbiquitousItem(at: iCloudDocumentsURL)
            }
            let data = try Data(contentsOf: iCloudDocumentsURL)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let totalJson = try decoder.decode(TotalJsonData.self, from: data) as TotalJsonData
            return totalJson
        } catch let error  {
            print(error)
            print("读取错误")
        }
        return nil
    }
}
