//
//  DocumentsManager.swift
//  Documents
//
//  Created by Razumov Pavel on 09.07.2025.
//

import UIKit

struct DocumentsManager {
    
    private let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

    var documents: [String] {
        let urls = try? FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil)
        return urls?.map { $0.lastPathComponent } ?? []
    }
    
    func saveImage(_ image: UIImage) {
        guard let data = image.jpegData(compressionQuality: 0.9) else { return }
        let fileName = UUID().uuidString.prefix(8) + ".jpg"
        let fileUrl = documentsUrl.appendingPathComponent(String(fileName))
        
        do {
            try data.write(to: fileUrl)
        } catch {
            print("Error with saving file: \(error.localizedDescription)")
        }
    }
    
    func deleteImage(at name: String) {
        let url = documentsUrl.appendingPathComponent(name)
        
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            print("Can not delete file: \(error.localizedDescription)")
        }
    }
}
