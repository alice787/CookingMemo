//
//  cookingIngredientsView.swift
//  CookingMemo
//
//  Created by take on 2021/02/17.
//

import UIKit

class CookingIngredientsView: UIView, UITextFieldDelegate {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var ingredientsLabel: UITextField!
    @IBOutlet weak var foodAmountLabel: UITextField!
    
    private var mainView: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadNib()
    }
    
    func loadNib() {
        view = Bundle.main.loadNibNamed("cookingIngredientsXib", owner: self, options: nil)?.first as! UIView?
        view.backgroundColor = .clear
        view.frame = self.bounds
        addSubview(view)
        ingredientsLabel.delegate = self
        foodAmountLabel.delegate = self
        ingredientsLabel.textColor = .gray
        foodAmountLabel.textColor = .gray
        setKeyboardBar()
    }
    
    func setOfserver(view: UIView) {
        mainView = view
        configureObserver()  //Notification発行
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.textColor == UIColor.gray {
            textField.text = ""
            textField.textColor = .black
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" {
            textField.text = "人参"
            textField.textColor = .gray
        }
    }
    
    @objc func ingredientsLabelDone(_ sender: UIButton){
        ingredientsLabel.resignFirstResponder()
    }
    @objc func foodAmountLabelDone(_ sender: UIButton){
        foodAmountLabel.resignFirstResponder()
    }
    
    // キーボードのボタンをセット
    func setKeyboardBar() {
        
        var keyboardBar = [UIToolbar]()
        
        for i in 0 ..< 2 {
            keyboardBar.append(UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40)))
            keyboardBar[i].barStyle = UIBarStyle.default
            keyboardBar[i].sizeToFit()
            
            let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)

            var done = UIBarButtonItem()
            
            if i == 0 {
                done = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.ingredientsLabelDone))
            } else {
                done = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.foodAmountLabelDone))
            }
            done.tintColor = .systemOrange

            keyboardBar[i].items = [spacer, done]
        }

        ingredientsLabel.inputAccessoryView = keyboardBar[0]
        foodAmountLabel.inputAccessoryView = keyboardBar[1]
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
