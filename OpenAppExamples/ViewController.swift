//
//  ViewController.swift
//  OpenAppExamples
//
//  Created by Taof on 11/09/2021.
//

import UIKit
import UniformTypeIdentifiers

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onImportFile(_ sender: Any) {
        // MARK: - import UniformTypeIdentifiers để sử dụng UTType
        // Tham khảo: https://developer.apple.com/documentation/uniformtypeidentifiers
        
        let supportedTypes: [UTType] = [UTType.text]
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes, asCopy: true)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true, completion: nil)
    }
    
    // MARK: - Máy ảo không thực hiện cuộc gọi, hãy thử trên máy thật
    // Tham khảo: https://stackoverflow.com/questions/27259824/calling-a-phone-number-in-swift
    
    @IBAction func onCall(_ sender: Any) {
        callNumber(phoneNumber: "0972129141")
    }
    
    private func callNumber(phoneNumber:String) {
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
}

extension ViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFileURL = urls.first else {
            return
        }
        
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let sandboxFileURL = dir.appendingPathComponent(selectedFileURL.lastPathComponent)
        
        if FileManager.default.fileExists(atPath: sandboxFileURL.path) {
            print("Already exists! Do nothing")
        }
        else {
            do {
                try FileManager.default.copyItem(at: selectedFileURL, to: sandboxFileURL)
                print("Copied file!")
            }
            catch {
                print("Error: \(error)")
            }
        }
    }
}
