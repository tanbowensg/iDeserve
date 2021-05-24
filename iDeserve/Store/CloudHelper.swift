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
    
    let localDocumentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("coredata.json")
    let iCloudDirectoryURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)!.appendingPathComponent("Documents")
    let iCloudDocumentsURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)!.appendingPathComponent("Documents").appendingPathComponent("coredata.json")
    
    
    func save(data: Data) {
        print(iCloudDocumentsURL)
        do {
            // check for container existence
            if !FileManager.default.fileExists(atPath: iCloudDirectoryURL.path, isDirectory: nil) {
                print("创建新目录")
                try FileManager.default.createDirectory(at: iCloudDirectoryURL, withIntermediateDirectories: true, attributes: nil)
            }
            try data.write(to: iCloudDocumentsURL)
        } catch let error  {
            print(error)
            print("写入错误")
        }
    }
    func read() -> TotalJsonData? {
        do {
            print("存在吗？\(try FileManager.default.fileExists(atPath: iCloudDocumentsURL.path))")
//            if FileManager.default.fileExists(atPath: iCloudDocumentsURL.path) {
//                print("开始下载")
//                try FileManager.default.startDownloadingUbiquitousItem(at: iCloudDocumentsURL)
//                let data = try Data(contentsOf: iCloudDocumentsURL)
//                let decoder = JSONDecoder()
//                decoder.dateDecodingStrategy = .iso8601
//                let totalJson = try decoder.decode(TotalJsonData.self, from: data) as TotalJsonData
//                return totalJson
//            }
        } catch let error  {
            print(error)
            print("读取错误")
        }
        return nil
    }
    
    // Return the Document directory (Cloud OR Local)
    // To do in a background thread
    
    func getDocumentDiretoryURL() -> URL {
        print(iCloudDocumentsURL)
        print(localDocumentsURL)
        if isCloudEnabled()  {
            return iCloudDocumentsURL
        } else {
            return localDocumentsURL
        }
    }
    
    // Return true if iCloud is enabled
    
    func isCloudEnabled() -> Bool {
        //        if iCloudDocumentsURL != nil { return true }
        //        else { return false }
        return true
    }
    
    // Delete All files at URL
    
    func deleteFilesInDirectory(url: NSURL?) {
        let fileManager = FileManager.default
        let enumerator = fileManager.enumerator(atPath: url!.path!)
        while let file = enumerator?.nextObject() as? String {
            
            do {
                try fileManager.removeItem(at: url!.appendingPathComponent(file)!)
                print("Files deleted")
            } catch let error as NSError {
                print("Failed deleting files : \(error)")
            }
        }
    }
    
    // Move local files to iCloud
    // iCloud will be cleared before any operation
    // No data merging
    
    func moveFileToCloud() {
        if isCloudEnabled() {
            deleteFilesInDirectory(url: iCloudDocumentsURL as NSURL) // Clear destination
            let fileManager = FileManager.default
            let enumerator = fileManager.enumerator(atPath: localDocumentsURL.path)
            while let file = enumerator?.nextObject() as? String {
                
                do {
                    try fileManager.setUbiquitous(true,
                                                  itemAt: localDocumentsURL.appendingPathComponent(file),
                                                  destinationURL: iCloudDocumentsURL.appendingPathComponent(file))
                    print("Moved to iCloud")
                } catch let error as NSError {
                    print("Failed to move file to Cloud : \(error)")
                }
            }
        }
    }
    
    // Move iCloud files to local directory
    // Local dir will be cleared
    // No data merging
    
    func moveFileToLocal() {
        if isCloudEnabled() {
            deleteFilesInDirectory(url: localDocumentsURL as NSURL)
            let fileManager = FileManager.default
            let enumerator = fileManager.enumerator(atPath: iCloudDocumentsURL.path)
            while let file = enumerator?.nextObject() as? String {
                
                do {
                    try fileManager.setUbiquitous(false,
                                                  itemAt: iCloudDocumentsURL.appendingPathComponent(file),
                                                  destinationURL: localDocumentsURL.appendingPathComponent(file))
                    print("Moved to local dir")
                } catch let error as NSError {
                    print("Failed to move file to local dir : \(error)")
                }
            }
        }
    }
    
    
    
}
