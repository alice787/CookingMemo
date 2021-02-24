//
//  macro.swift
//  CookingMemo
//
//  Created by take on 2021/02/21.
//

import UIKit

// 画面左の座標
let screenX:CGFloat = 0
// iPhoneの画面の横幅
let screenWidth = UIScreen.main.bounds.width
// 料理の材料のUITextViewのサイズ
let ingredientsSize = CGSize(width: screenWidth, height: 40)
// レシピのUITextViewのサイズ
let recipeViewSize = CGSize(width: screenWidth, height: 90)
// レシピのUITextViewの追加ボタンのサイズと料理の材料のUITextViewの追加ボタンのサイズ
let addButtonSize = CGSize(width: 200, height: 40)
// 追加ボタンを画面の真ん中にセットするための定数
let addButtonCenter:CGFloat = screenWidth / 2 - addButtonSize.width / 2
// メモのUITextViewのサイズ
let memoSize = CGSize(width: screenWidth - 10, height: 100)
// 材料のViewもしくはレシピのViewと追加ボタンの間の距離
let addButtonDistance:CGFloat = 10
