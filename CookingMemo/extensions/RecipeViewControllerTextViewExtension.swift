//
//  RecipeViewControllerTextViewExtension.swift
//  CookingMemo
//
//  Created by take on 2021/02/23.
//

import UIKit

extension RecipeViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        memoAdjustment()
    }
    
    // メモのViewのサイズ調整
    func memoAdjustment() {
        let beforeHeight = cookingMemo.frame.height
        var height = cookingMemo.sizeThatFits(CGSize(width: cookingMemo.frame.width, height: CGFloat.greatestFiniteMagnitude)).height
        cookingMemo.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        if height < 100 {
            height = 100
        }
        cookingMemo.frame.size.height = height
        
        self.mainView.frame.size.height += height - beforeHeight
    }
    // キーボードのボタンをセット
    func MemoSetKeyboardBar() {
        
        let keyboardBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        keyboardBar.barStyle = UIBarStyle.default
        keyboardBar.sizeToFit()

        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)

        let done = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.memoDone))
        done.tintColor = .systemOrange


        keyboardBar.items = [spacer, done]

        cookingMemo.inputAccessoryView = keyboardBar
    }
    
    @objc func memoDone(_ sender: UIButton){
        cookingMemo.resignFirstResponder()
    }
}
