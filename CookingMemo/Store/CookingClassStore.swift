//
//  CookingGenreStore.swift
//  CookingMemo
//
//  Created by take on 2021/02/07.
//

import Foundation



final class CookingClassStore {
    
    static let shared = CookingClassStore()
    private var classData: RecipeViewControllerData!
//    private var list: CookingClassList!
    
    let baseUrl: URL = {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//        let dataUrl = url.appendingPathComponent("data.json")
        return url
    }()
    
//    private init() {
//        load()
//    }

    func add(data: RecipeViewControllerData) {
        classData = data
    }
    
    func get() -> RecipeViewControllerData? {
        return classData
    }
    
    func load(genreIndex: Int, listIndex: Int) -> Bool {
        let pathName = "data" + String(genreIndex) + "-" + String(listIndex) + ".json"
        if
            let data = try? Data(contentsOf: baseUrl.appendingPathComponent(pathName)),
            let classData = try? JSONDecoder().decode(RecipeViewControllerData.self, from: data) {
            self.classData = classData
            
            return true
            } else {
            return false
        }
    }
    
    func save(genreIndex: Int, listIndex: Int) throws {
        let data = try JSONEncoder().encode(classData)
        let dataName = "data" + String(genreIndex) + "-" + String(listIndex) + ".json"
        let dataUrl = baseUrl.appendingPathComponent(dataName)
        try data.write(to: dataUrl)
    }
}


class CookingClassList: Codable {
    var list = [RecipeViewControllerData]()
}
