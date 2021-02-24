//
//  RecipeView.swift
//  CookingMemo
//
//  Created by take on 2021/02/09.
//

import UIKit

class RecipeXibView: UIView, UITextViewDelegate {
    @IBOutlet weak var recipeNum: UILabel!
    @IBOutlet weak var recipeTextView: UITextView!
    @IBOutlet var view: UIView!
    
    private var mainView: UIView?
    
    public var recipeXibViewArray: [RecipeXibView]?
    public var cookingMemo: UITextView?
    public var addRecipeButton: UIButton?
    public var index: Int?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()

    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadNib()
    }
    
    func loadNib() {
        view = Bundle.main.loadNibNamed("Recipe", owner: self, options: nil)?.first as! UIView?
        view.backgroundColor = .clear
        view.frame = self.bounds
        recipeTextView.delegate = self
        self.addSubview(view)
        recipeTextView.textColor = .gray
        recipeTextView.layer.borderWidth = 0.5
        recipeTextView.layer.borderColor = UIColor.gray.cgColor
        recipeTextView.layer.cornerRadius = 10.0
        setKeyboardBar()
    }
    
    func setKeyboardBar() {
        let keyboardBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        keyboardBar.barStyle = UIBarStyle.default
        keyboardBar.sizeToFit()

        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)

        let done = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.done))
        done.tintColor = .systemOrange


        keyboardBar.items = [spacer, done]

        recipeTextView.inputAccessoryView = keyboardBar
    }
    
    func setOfserver(view: UIView) {
        mainView = view
        configureObserver()  //Notification発行
    }
    
    @objc func done(_ sender: UIButton){
        recipeTextView.resignFirstResponder()
    }

    func viewAdjustment() {
        let y = self.frame.origin.y
        let beforeHeight = recipeTextView.frame.height
        var height = recipeTextView.sizeThatFits(CGSize(width: self.frame.width, height: CGFloat.greatestFiniteMagnitude)).height
        
        if height < 90 {
            height = 90
        }
        recipeTextView.frame.size.height = height
        self.bounds.size.height = height
        self.frame.origin.y = y
        view.frame.size.height = height
        
        cookingMemo!.frame.origin.y += height - beforeHeight
        mainView!.frame.size.height = cookingMemo!.frame.origin.y + cookingMemo!.frame.height + 144
        
    }
    
    func nextRecipeViewPositionChange(){
        
        recipeXibViewArray![index! + 1].frame.origin.y = self.frame.origin.y + self.frame.height + 10
        if recipeXibViewArray!.count > 2 {
            for i in 1 ..< recipeXibViewArray!.count - 1 {
                let frame = recipeXibViewArray![i].frame
                recipeXibViewArray![i + 1].frame.origin.y = frame.origin.y + frame.height + 10
            }
        }
        
        recipeXibViewArray![index! + 1].frame.origin.y = self.frame.origin.y + self.frame.height + 10
        mainView?.frame.size.height += 40
        let i = recipeXibViewArray!.count - 1
        addRecipeButton!.frame.origin.y = recipeXibViewArray![i].frame.origin.y + recipeXibViewArray![i].frame.height + addButtonDistance
    }
    
    func textViewDidChange(_ textView: UITextView) {
        viewAdjustment()
        addRecipeButton!.frame.origin.y = self.frame.origin.y + self.frame.height + addButtonDistance
        if recipeXibViewArray!.count >= index! + 2 {
            nextRecipeViewPositionChange()
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if recipeTextView.textColor == UIColor.gray {
            recipeTextView.text = ""
            recipeTextView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if recipeTextView.text == "" {
            recipeTextView.text = "玉ねぎをみじん切りにする"
            recipeTextView.textColor = .gray
        }
    }
    
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
