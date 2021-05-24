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
    let iCloudDirectoryURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)!.appendingPathComponent("Documents").appendingPathComponent("iDeserve")
    let iCloudDocumentsURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)!.appendingPathComponent("Documents").appendingPathComponent("iDeserve").appendingPathComponent("coredata.backup")
    
    
    func save(data: Data) {
        do {
            // check for container existence
            //            if !FileManager.default.fileExists(atPath: iCloudDirectoryURL.path, isDirectory: nil) {
            //                print("创建新目录")
            //                try FileManager.default.createDirectory(at: iCloudDirectoryURL, withIntermediateDirectories: true, attributes: nil)
            //            }
            try data.write(to: localDocumentsURL)
            print("存储在本地成功：\(localDocumentsURL)")
            try FileManager.default.createDirectory(at: iCloudDirectoryURL, withIntermediateDirectories: true, attributes: nil)
//            if try FileManager.default.fileExists(atPath: localDocumentsURL.path) {
//                try FileManager.default.removeItem(at: iCloudDocumentsURL)
//            }
                
            try FileManager.default.setUbiquitous(true,
                                                  itemAt: localDocumentsURL,
                                                  destinationURL: iCloudDocumentsURL
            )
            
            print("移动到cloud成功:\(iCloudDocumentsURL)")
            //            try data.write(to: iCloudDocumentsURL)
        } catch let error  {
            print(error)
            print("写入错误")
        }
    }
    func read() -> TotalJsonData? {
        do {
            //            print("local存在吗？\(try FileManager.default.fileExists(atPath: localDocumentsURL.path))")
            print("icloud存在吗？\(try FileManager.default.attributesOfItem(atPath: iCloudDocumentsURL.path).values)")
            if FileManager.default.fileExists(atPath: iCloudDocumentsURL.path) {
                //                print("开始下载")
                //                try FileManager.default.startDownloadingUbiquitousItem(at: iCloudDocumentsURL)
                let data = try Data(contentsOf: iCloudDocumentsURL)
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let totalJson = try decoder.decode(TotalJsonData.self, from: data) as TotalJsonData
                return totalJson
            }
        } catch let error  {
            print(error)
            print("读取错误")
        }
        return nil
    }
    
    // Return true if iCloud is enabled
    
    //    func isCloudEnabled() -> Bool {
    //        //        if iCloudDocumentsURL != nil { return true }
    //        //        else { return false }
    //        return true
    //    }
    //
    //    // Delete All files at URL
    //
    //    func deleteFilesInDirectory(url: NSURL?) {
    //        let fileManager = FileManager.default
    //        let enumerator = fileManager.enumerator(atPath: url!.path!)
    //        while let file = enumerator?.nextObject() as? String {
    //
    //            do {
    //                try fileManager.removeItem(at: url!.appendingPathComponent(file)!)
    //                print("Files deleted")
    //            } catch let error as NSError {
    //                print("Failed deleting files : \(error)")
    //            }
    //        }
    //    }
    //
    //    // Move local files to iCloud
    //    // iCloud will be cleared before any operation
    //    // No data merging
    //
    //    func moveFileToCloud() {
    //        let fileManager = FileManager.default
    //        do {
    //            let file = try FileManager.fil(contentsOf: iCloudDocumentsURL)
    //            try fileManager.setUbiquitous(true,
    //                                          itemAt: localDocumentsURL.appendingPathComponet,
    //                                          destinationURL: iCloudDocumentsURL.appendingPathComponent(file))
    //            print("Moved to iCloud")
    //        } catch let error as NSError {
    //            print("Failed to move file to Cloud : \(error)")
    //        }
    //    }
    //
    //    // Move iCloud files to local directory
    //    // Local dir will be cleared
    //    // No data merging
    //
    //    func moveFileToLocal() {
    //        if isCloudEnabled() {
    //            deleteFilesInDirectory(url: localDocumentsURL as NSURL)
    //            let fileManager = FileManager.default
    //            let file = fileManager.rea
    //
    //                do {
    //                    try fileManager.setUbiquitous(false,
    //                                                  itemAt: iCloudDocumentsURL.appendingPathComponent(file),
    //                                                  destinationURL: localDocumentsURL.appendingPathComponent(file))
    //                    print("Moved to local dir")
    //                } catch let error as NSError {
    //                    print("Failed to move file to local dir : \(error)")
    //                }
    //            }
    //        }
    //    }
    //
}
