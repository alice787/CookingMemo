//
//  RecipeViewController.swift
//  CookingMemo
//
//  Created by take on 2021/02/09.
//

import UIKit

class RecipeViewController: UIViewController,UIGestureRecognizerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var endButton: UIButton!
    
    var childCallBack: ((String, Int) -> Void)?
    var titleFieldText:String?
    
    internal let cookingMemo = UITextView()
    internal var imageName: String?
    private let addIngredientsButton = UIButton()
    private let addRecipeButton = UIButton()
    private var recipeXibView = [RecipeXibView]()
    private var cookingIngredients = [CookingIngredientsView]()
    private var previousButtonItem: UIBarButtonItem!
    
    public var genreIndex: Int?
    public var listIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // mainViewの大きさを変更するため
        mainView.translatesAutoresizingMaskIntoConstraints = true
        
        self.image.image = UIImage(named: "empty")

        previousButtonItem = UIBarButtonItem(title: "戻る", style: .done, target: self, action: #selector(previousBarButtonTapped(_:)))
        navigationItem.leftBarButtonItems = [previousButtonItem]
        
        // 終了ボタン
        endButton.layer.borderWidth = 0.5
        endButton.layer.borderColor = UIColor.gray.cgColor
        endButton.layer.cornerRadius = 10.0
        
        // タイトルのView
        self.titleField.text = self.titleFieldText
        
        if titleField.text != nil {
            self.titleField.textColor = .black
        } else {
            self.titleField.textColor = .gray
        }
        setKeyboardBar()
        titleField.delegate = self
        
        // 材料のViewを３つ作成
        for i in 0 ..< 3{
            cookingIngredients.append(CookingIngredientsView(frame: CGRect(origin: CGPoint(x: screenX, y: titleField.frame.origin.y + 90 + CGFloat(i) * ingredientsSize.height), size: ingredientsSize)))
            cookingIngredients[i].setOfserver(view: mainView)
            self.mainView.addSubview(cookingIngredients[i])
        }

        
        // 材料のView追加ボタン
        addIngredientsButton.frame = CGRect(origin: CGPoint(x: addButtonCenter, y: cookingIngredients[2].frame.origin.y + ingredientsSize.height + addButtonDistance), size: addButtonSize)
        addIngredientsButton.setTitle("＋ 材料を追加", for: .normal)
        addIngredientsButton.setTitleColor(.orange, for: .normal)
        addIngredientsButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        self.mainView.addSubview(addIngredientsButton)
        addIngredientsButton.addTarget(self, action: #selector(self.addIngredientsButtonTapped(_:)), for: .touchUpInside)

        // レシピのView
        recipeXibView.append(RecipeXibView(frame: CGRect(origin: CGPoint(x: screenX, y: addIngredientsButton.frame.origin.y + 100), size: recipeViewSize)))
        recipeXibView[0].loadNib()
        recipeXibView[0].setOfserver(view: mainView)
        recipeXibView[0].index = 0
        recipeXibView[0].recipeXibViewArray = recipeXibView
        self.mainView.addSubview(recipeXibView[0])
        
        // レシピのView追加ボタン
        addRecipeButton.frame = CGRect(origin: CGPoint(x: addButtonCenter, y: recipeXibView[0].frame.origin.y + 100), size: addButtonSize)
        addRecipeButton.setTitle("＋ レシピを追加", for: .normal)
        addRecipeButton.setTitleColor(.orange, for: .normal)
        addRecipeButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        self.mainView.addSubview(addRecipeButton)
        addRecipeButton.addTarget(self, action: #selector(self.addRecipeButtonTapped(_:)), for: .touchUpInside)
        
        // メモのView
        cookingMemo.frame = CGRect(origin: CGPoint(x: 5, y: addRecipeButton.frame.origin.y + 100), size: memoSize)
        cookingMemo.layer.borderWidth = 0.5
        cookingMemo.layer.borderColor = UIColor.gray.cgColor
        cookingMemo.layer.cornerRadius = 10.0
        cookingMemo.font = UIFont.systemFont(ofSize: 20)
        cookingMemo.isScrollEnabled = false
        cookingMemo.delegate = self
        MemoSetKeyboardBar()
        self.mainView.addSubview(cookingMemo)
        
        recipeXibView[0].cookingMemo = self.cookingMemo
        recipeXibView[0].addRecipeButton = self.addRecipeButton
        
        
        if CookingClassStore.shared.load(genreIndex: self.genreIndex!, listIndex: listIndex!) {
            let data = CookingClassStore.shared.get()
            loadData(data: data!)
        }
    }
    
    
    
    // ドキュメントからデータの読み込み
    func loadData(data: RecipeViewControllerData) {
        
        self.mainView.frame.size = data.mainView
        self.titleField.text = data.title
        self.titleField.textColor = .black
        self.cookingMemo.text = data.memo
        self.imageName = data.imageName
        self.image.image = UIImage(contentsOfFile: self.imageName!)
        
        for i in 0 ..< (CookingClassStore.shared.get()?.ingredients.count)! {
            if i >= 2 && i != (CookingClassStore.shared.get()?.ingredients.count)! - 1 {
                addIngredientsView()
                recipeViewPositionAdjustment()
            }
            self.cookingIngredients[i].ingredientsLabel.text = data.ingredients[i]
            self.cookingIngredients[i].ingredientsLabel.textColor = .black
            self.cookingIngredients[i].foodAmountLabel.text = data.amount[i]
            self.cookingIngredients[i].foodAmountLabel.textColor = .black
        }
        
        for i in 0 ..< (CookingClassStore.shared.get()?.recipeText.count)! {
            self.recipeXibView[i].recipeTextView.text = data.recipeText[i]
            self.recipeXibView[i].recipeTextView.textColor = .black
            if i != (CookingClassStore.shared.get()?.recipeText.count)! - 1 {
                addRecipeView()
            }
        }
        self.recipeXibView[(CookingClassStore.shared.get()?.recipeText.count)! - 1].recipeTextView.text = data.recipeText[(CookingClassStore.shared.get()?.recipeText.count)! - 1]
        self.recipeXibView[(CookingClassStore.shared.get()?.recipeText.count)! - 1].recipeTextView.textColor = .black
        recipeNumCul()
    }

    @IBAction func addImage(_ sender: Any) {
        let pk = UIImagePickerController()
        pk.delegate = self
        present(pk, animated: true)
//        self.image.image = UIImage(contentsOfFile: String(index))
    }
    
    // 材料のViewを追加
    func addIngredientsView() {
        let positionY = cookingIngredients[cookingIngredients.count - 1].frame.origin.y
        cookingIngredients.append(CookingIngredientsView(frame: CGRect(x: 0, y: positionY + ingredientsSize.height, width: mainView.frame.width, height: ingredientsSize.height)))
        let index = cookingIngredients.count - 1
        cookingIngredients[index].setOfserver(view: mainView)
        self.mainView.addSubview(cookingIngredients[index])
        addIngredientsButton.frame.origin.y = cookingIngredients[index].frame.origin.y + cookingIngredients[index].frame.height + addButtonDistance
        cookingMemo.frame.origin.y += ingredientsSize.height
        self.mainView.frame.size.height += ingredientsSize.height
    }
    
    // レシピのViewを追加
    func addRecipeView() {
        let positionY = recipeXibView[recipeXibView.count - 1].frame.origin.y
        recipeXibView.append(RecipeXibView(frame: CGRect(origin: CGPoint(x: screenX, y: positionY + recipeXibView[recipeXibView.count - 1].frame.height + 10), size: recipeViewSize)))
        let index = recipeXibView.count - 1
        recipeXibView[index].loadNib()
        recipeXibView[index].setOfserver(view: mainView)
        recipeXibView[index].index = index
        self.mainView.addSubview(recipeXibView[index])
        self.mainView.frame.size.height += recipeViewSize.height + 10 // 10はレシピのView同士の隙間
        
        addRecipeButton.frame.origin.y = recipeXibView[index].frame.origin.y + recipeXibView[index].frame.height + addButtonDistance
        for i in 0 ..< recipeXibView.count{
            recipeXibView[i].recipeXibViewArray = recipeXibView
        }
        recipeXibView[index].cookingMemo = self.cookingMemo
        recipeXibView[index].addRecipeButton = self.addRecipeButton
        cookingMemo.frame.origin.y = addRecipeButton.frame.origin.y + 100
    }
    
    // レシピのナンバーの計算
    func recipeNumCul() {
        for i in 0 ..< recipeXibView.count {
            recipeXibView[i].recipeNum.text = String(i + 1)
        }
    }
    
    // レシピのViewの位置を調整
    func recipeViewPositionAdjustment() {
        recipeXibView[0].frame.origin.y = addIngredientsButton.frame.origin.y + 100
        for i in 1 ..< recipeXibView.count {
            recipeXibView[i].frame.origin.y = recipeXibView[i - 1].frame.origin.y + recipeXibView[i - 1].frame.height + 10
        }
        addRecipeButton.frame.origin.y = recipeXibView[recipeXibView.count - 1].frame.origin.y + recipeXibView[recipeXibView.count - 1].frame.height + addButtonDistance
    }
    
    // ボタンを押したら材料のViewを追加
    @objc func addIngredientsButtonTapped(_ sender: Any){
        addIngredientsView()
        recipeViewPositionAdjustment()
    }
    
    // ボタンを押したらレシピのViewを追加
    @objc func addRecipeButtonTapped(_ sender: Any){
        addRecipeView()
        recipeNumCul()
    }
    
    func getRecipeTextArray() -> [String] {
        var array = [String]()
        for i in 0 ..< recipeXibView.count {
            array.append(recipeXibView[i].recipeTextView.text)
        }
        return array
    }
    
    func getIngredientsArray() -> [String] {
        var array = [String]()
        for i in 0 ..< cookingIngredients.count {
            array.append(cookingIngredients[i].ingredientsLabel.text!)
        }
        return array
    }
    
    func getAmountArray() -> [String] {
        var array = [String]()
        for i in 0 ..< cookingIngredients.count {
            array.append(cookingIngredients[i].foodAmountLabel.text!)
        }
        return array
    }
    
    // 終了ボタンを押したら
    @IBAction func endButton(_ sender: Any) {
        if imageName == nil {
            let alert = UIAlertController(title: "保存できませんでした", message: "", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { _ in
                self.dismiss(animated: true, completion: nil)
            })
            self.present(alert, animated: true, completion: nil)
        }
        let alert = UIAlertController(title: "保存しますか？", message: "", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { _ in
            CookingClassStore.shared.add(data: RecipeViewControllerData(self.mainView.frame.size, imageName: self.imageName!, title: self.titleField.text!, memo: self.cookingMemo.text!, recipeText: self.getRecipeTextArray(), ingredients: self.getIngredientsArray(), amount: self.getAmountArray()))
            try? CookingClassStore.shared.save(genreIndex: self.genreIndex!, listIndex: self.listIndex!)
            self.dismiss(animated: true) {
                self.childCallBack!( self.titleField.text!, self.listIndex!)
            }
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func previousBarButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
