//
//  RecipeViewControllerImagePickerExtension.swift
//  CookingMemo
//
//  Created by take on 2021/02/23.
//

import UIKit

extension RecipeViewController: UIImagePickerControllerDelegate {
    
    // カメラロールから画像を取得
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let getImage = info[.originalImage] as! UIImage
        
        self.imageName = fileInDocumentsDirectory(filename: getImage.description)
        
        saveImage(image: getImage, path: self.imageName!)
        
        self.image.image = getImage
        self.dismiss(animated: true)
    }
    
    func saveImage (image: UIImage, path: String ) {
        let jpgImageData = image.jpegData(compressionQuality:0.5)
        do {
            try jpgImageData!.write(to: URL(fileURLWithPath: path), options: .atomic)
        } catch {
            print(error)
        }
    }
    
    // DocumentディレクトリのfileURLを取得
    func getDocumentsURL() -> URL {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let imageDirectory = documentsURL.appendingPathComponent("image" + String(self.genreIndex!) , isDirectory: false)
        
        if FileManager.default.fileExists(atPath: imageDirectory.path) {
            print("true")
        } else {
            try? FileManager.default.createDirectory(at: imageDirectory, withIntermediateDirectories: true, attributes: nil)
        }
        return imageDirectory
    }

    // ディレクトリのパスにファイル名をつなげてファイルのフルパスを作る
    func fileInDocumentsDirectory(filename: String) -> String {
        let fileURL = getDocumentsURL().appendingPathComponent(filename)
        return fileURL.path
    }
}
