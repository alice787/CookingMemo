//
//  CookingListViewController.swift
//  CookingMemo
//
//  Created by take on 2021/02/07.
//

import UIKit

class CookingListViewController: UIViewController {
    
    @IBOutlet weak var listCollectionView: UICollectionView!
    
    var itemtitle: String?
    var cookingTitle: String?
    var imageName: String?
    var addBarButtonItem: UIBarButtonItem!
    var cellNum: Int = 0
    var index: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listCollectionView.delegate = self
        listCollectionView.dataSource = self
        
        
        if CookingListViewStore.shared.load(index: self.index!) {
            self.cellNum = CookingListViewStore.shared.count()!
        }
        
        navigationItem.title = self.itemtitle
        addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonTapped(_:)))
        navigationItem.rightBarButtonItems = [addBarButtonItem]
    }
    
    
    @objc func addBarButtonTapped(_ sender: UIBarButtonItem) {
        var alertTextField: UITextField?
        
        let alert = UIAlertController(title: "料理名", message: "Enter new name", preferredStyle: UIAlertController.Style.alert)
        alert.addTextField(configurationHandler: { (textField: UITextField!) in alertTextField = textField })
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { _ in
            self.cellNum += 1
            self.cookingTitle = alertTextField?.text
            CookingListViewStore.shared.add(data: CookingListViewData(imageName: "empty" ,title: self.cookingTitle!, index: self.index!))
            try? CookingListViewStore.shared.save(index: self.index!)
            self.listCollectionView.reloadData()
        })
        self.present(alert, animated: true, completion: nil)
    }
}




extension CookingListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellNum
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CookingListViewCell
        setCellImage(genreIndex: self.index!, listIndex: indexPath.row)
        if imageName != "empty" {
            cell.image.image = UIImage(contentsOfFile: self.imageName!)
        } else {
            cell.image.image = UIImage(named: self.imageName!)
        }
        if CookingListViewStore.shared.load(index: self.index!) {
            self.cookingTitle = CookingListViewStore.shared.get(index: indexPath.row)?.title
        }
        cell.cookingTitle.text = self.cookingTitle
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "RecipeViewSB", bundle: nil)
        let navi = storyboard.instantiateViewController(identifier: "navigationController") as! UINavigationController
        let vc = navi.visibleViewController as! RecipeViewController
        vc.genreIndex = self.index
        vc.listIndex = indexPath.row
        vc.titleFieldText = self.cookingTitle
        vc.childCallBack = { (text , listIndex) in
            self.callBack(text: text, listIndex: listIndex)
        }
        self.present(vc.navigationController!, animated: true, completion: nil)
    }
    func callBack(text: String, listIndex: Int) {
        self.cookingTitle = text
        CookingListViewStore.shared.overwriteSave(index: listIndex, data: CookingListViewData(imageName: self.imageName, title: self.cookingTitle!, index: self.index!))
        try? CookingListViewStore.shared.save(index: index!)
        listCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width / 2
        let returnSize = CGSize(width: width - 10, height: width + 20)
        return returnSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let pad:CGFloat = 5

        return UIEdgeInsets(top: pad, left: pad, bottom: pad + 20, right: pad)
    }
    
    func setCellImage(genreIndex: Int, listIndex: Int) {
        
        if CookingClassStore.shared.load(genreIndex: genreIndex, listIndex: listIndex) {
            self.imageName = CookingClassStore.shared.get()?.imageName
        } else {
            self.imageName = "empty"
        }
    }
}
