//
//  RecipeViewControllerTextFieldExtension.swift
//  CookingMemo
//
//  Created by take on 2021/02/23.
//

import UIKit

extension RecipeViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if titleField.textColor == UIColor.gray {
            titleField.text = ""
            titleField.textColor = .black
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if titleField.text == "" {
            titleField.text = "タイトル"
            titleField.textColor = .gray
        }
    }
    
    // キーボードのボタンをセット
    func setKeyboardBar() {
        
        let keyboardBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        keyboardBar.barStyle = UIBarStyle.default
        keyboardBar.sizeToFit()

        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)

        let done = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.done))
        done.tintColor = .systemOrange


        keyboardBar.items = [spacer, done]

        titleField.inputAccessoryView = keyboardBar
    }
    
    @objc func done(_ sender: UIButton){
        titleField.resignFirstResponder()
    }

    // Notification発行
    func configureObserver() {
        let notification = NotificationCenter.default
        notification.addObserver(self, selector: #selector(keyboardWillShow(_:)),
                                 name: UIResponder.keyboardWillShowNotification, object: nil)
        notification.addObserver(self, selector: #selector(keyboardWillHide(_:)),
                                 name: UIResponder.keyboardWillHideNotification, object: nil)
        print("Notificationを発行")
    }

    // キーボードの表示時に画面をずらす。
    @objc func keyboardWillShow(_ notification: Notification?) {
        guard let rect = (notification?.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = notification?.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        UIView.animate(withDuration: duration) {
            let transform = CGAffineTransform(translationX: 0, y: -(rect.size.height))
            self.mainView!.transform = transform
        }
        print("keyboardWillShowを実行")
    }

    // キーボードが降りたら画面を戻す
    @objc func keyboardWillHide(_ notification: Notification?) {
        guard let duration = notification?.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? TimeInterval else { return }
        UIView.animate(withDuration: duration) {
            self.mainView!.transform = CGAffineTransform.identity
        }
        print("keyboardWillHideを実行")
    }
}
