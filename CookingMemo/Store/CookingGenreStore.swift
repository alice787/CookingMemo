//
//  CookingGenreStore.swift
//  CookingMemo
//
//  Created by take on 2021/02/19.
//

import Foundation


final class CookingGenreStore {

    static let shared = CookingGenreStore()
    private var cookingGenreList: CookingGenreList!
    
    let dataUrl: URL = {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let dataUrl = url.appendingPathComponent("ganreData.json")
        return dataUrl
    }()

    private init() {
        load()
    }
    func count() -> Int {
        return cookingGenreList.list.count
    }

    func add(data: CookingGenreData) {
        cookingGenreList.list.append(data)
    }

    func remove(_ index:Int) {
        cookingGenreList.list.remove(at: index)
//        removeFile(index: index)
    }
    
    func removeFile(index: Int) {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            for fileName in fileURLs {
                if fileName.absoluteString.contains("data" + String(index)) || fileName.absoluteString.contains("image" + String(index)){
                    try? FileManager.default.removeItem(at: fileName)
                }
            }
        } catch {
            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
        }
    }

    func get(index i: Int) -> CookingGenreData? {
        if cookingGenreList.list.count > i {
            return cookingGenreList.list[i]
        }
        return nil
    }

    func move(from i: Int, to j: Int) {
        let cl = get(index: i)
        cookingGenreList.list.remove(at: i)
        cookingGenreList.list.insert(cl!, at: j)
    }

    func load() {
        if
            let data = try? Data(contentsOf: dataUrl),
            let list = try? JSONDecoder().decode(CookingGenreList.self, from: data) {
            self.cookingGenreList = list
        } else {
            self.cookingGenreList = CookingGenreList()
        }
    }

    func save() throws {
        let data = try JSONEncoder().encode(cookingGenreList)
        try data.write(to: dataUrl)
    }
    
    func overwriteSave(index: Int ,data: CookingGenreData) {
        cookingGenreList.list[index] = data
    }
    
}

class CookingGenreList: Codable {
    var list = [CookingGenreData]()
}


class CookingGenreData: Codable {
    var imageName: String?
    var genreTitle: String
    init(imageName: String?, genreTitle: String) {
        self.imageName = imageName
        self.genreTitle = genreTitle
    }
    
}


//extension FileManager {
//    func urls(for directory: FileManager.SearchPathDirectory, skipsHiddenFiles: Bool = true ) -> [URL]? {
//        let documentsURL = urls(for: directory, in: .userDomainMask)[0]
//        let fileURLs = try? contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil, options: skipsHiddenFiles ? .skipsHiddenFiles : [] )
//        return fileURLs
//    }
//}
