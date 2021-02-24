//
//  RecipeViewControllerSave.swift
//  CookingMemo
//
//  Created by take on 2021/02/18.
//

import UIKit

class RecipeViewControllerData: Codable {
    var mainView: CGSize
    var imageName: String
    var title: String
    var memo: String
    var recipeText: [String]
    var ingredients: [String]
    var amount: [String]
    
    init(_ mainView: CGSize, imageName: String, title: String, memo: String, recipeText: [String], ingredients: [String], amount: [String]) {
        self.mainView = mainView
        self.imageName = imageName
        self.title = title
        self.memo = memo
        self.recipeText = recipeText
        self.ingredients = ingredients
        self.amount = amount
    }
}
