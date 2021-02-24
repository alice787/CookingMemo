//
//  CookingGenreStore.swift
//  CookingMemo
//
//  Created by take on 2021/02/19.
//

import Foundation

final class CookingListViewStore {

    static let shared = CookingListViewStore()
    private var cookingList: CookingList!

    let baseUrl: URL = {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//        let dataUrl = url.appendingPathComponent("data.json")
        return url
    }()

//    private init(index:Int) {
//        load(index: index)
//    }
//
    func count() -> Int? {
        return cookingList.list.count
    }

    func add(data: CookingListViewData) {
        cookingList.list.append(data)    }

    func remove(_ index:Int) {
        cookingList.list.remove(at: index)
    }

    func get(index i: Int) -> CookingListViewData? {
        if cookingList.list.count > i {
            return cookingList.list[i]
        }
        return nil
    }

    func move(from i: Int, to j: Int) {
        let cl = get(index: i)
        cookingList.list.remove(at: i)
        cookingList.list.insert(cl!, at: j)
    }

    func load(index: Int) -> Bool {
        if
            let data = try? Data(contentsOf: baseUrl.appendingPathComponent("data" + String(index) + ".json")),
            let list = try? JSONDecoder().decode(CookingList.self, from: data) {
            self.cookingList = list
            return true
        } else {
            self.cookingList = CookingList()
            return false
        }
    }

    func save(index: Int) throws {
        let data = try JSONEncoder().encode(cookingList)
        let dataName = "data" + String(index) + ".json"
        let dataUrl = baseUrl.appendingPathComponent(dataName)
        try data.write(to: dataUrl)
    }
    
    func overwriteSave(index: Int ,data: CookingListViewData) {
        cookingList.list[index] = data
    }
}

class CookingList: Codable {
    var list = [CookingListViewData]()
}


class CookingListViewData: Codable {
    var imageName: String?
    var title: String
    var index: Int
    init(imageName: String?, title: String, index: Int) {
        self.imageName = imageName
        self.title = title
        self.index = index
    }

}
