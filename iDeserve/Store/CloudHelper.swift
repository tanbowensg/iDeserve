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
    
    struct DocumentsDirectory {
        static let localDocumentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("hello.txt")
        static let iCloudDocumentsURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)!.appendingPathComponent("Documents").appendingPathComponent("coredata.json")
    }
    
    
    func save(data: Data) {
        print(DocumentsDirectory.iCloudDocumentsURL)
        do {
            try data.write(to: DocumentsDirectory.iCloudDocumentsURL)
        } catch let error  {
            print(error)
            print("写入错误")
        }
    }
    
    func read() {
        do {
            let data = try Data(contentsOf: DocumentsDirectory.iCloudDocumentsURL)
//            let json = try JSONSerialization.jsonObject(with: data, options: [])
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            print(try decoder.decode(TotalJsonData.self, from: data))
        } catch let error  {
            print(error)
            print("读取错误")
        }
    }
    
    // Return the Document directory (Cloud OR Local)
    // To do in a background thread
    
    func getDocumentDiretoryURL() -> URL {
        print(DocumentsDirectory.iCloudDocumentsURL)
        print(DocumentsDirectory.localDocumentsURL)
        if isCloudEnabled()  {
            return DocumentsDirectory.iCloudDocumentsURL
        } else {
            return DocumentsDirectory.localDocumentsURL
        }
    }
    
    // Return true if iCloud is enabled
    
    func isCloudEnabled() -> Bool {
//        if DocumentsDirectory.iCloudDocumentsURL != nil { return true }
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
            deleteFilesInDirectory(url: DocumentsDirectory.iCloudDocumentsURL as NSURL) // Clear destination
            let fileManager = FileManager.default
            let enumerator = fileManager.enumerator(atPath: DocumentsDirectory.localDocumentsURL.path)
            while let file = enumerator?.nextObject() as? String {
                
                do {
                    try fileManager.setUbiquitous(true,
                                                  itemAt: DocumentsDirectory.localDocumentsURL.appendingPathComponent(file),
                                                  destinationURL: DocumentsDirectory.iCloudDocumentsURL.appendingPathComponent(file))
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
            deleteFilesInDirectory(url: DocumentsDirectory.localDocumentsURL as NSURL)
            let fileManager = FileManager.default
            let enumerator = fileManager.enumerator(atPath: DocumentsDirectory.iCloudDocumentsURL.path)
            while let file = enumerator?.nextObject() as? String {
                
                do {
                    try fileManager.setUbiquitous(false,
                                                  itemAt: DocumentsDirectory.iCloudDocumentsURL.appendingPathComponent(file),
                                                  destinationURL: DocumentsDirectory.localDocumentsURL.appendingPathComponent(file))
                    print("Moved to local dir")
                } catch let error as NSError {
                    print("Failed to move file to local dir : \(error)")
                }
            }
        }
    }
    
    
    
}
