//
//  CookingGenreListViewController.swift
//  CookingMemo
//
//  Created by take on 2021/02/07.
//

import UIKit

class CookingGenreListViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var genreListTableView: UITableView!
    var addBarButtonItem: UIBarButtonItem!
    var editBarButtonItem: UIBarButtonItem!
    var cellNum = 0
    var genreTitle: String?
    var imageName: String?
    var num = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.cellNum = CookingGenreStore.shared.count()
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(cellLongPressed(recognizer:)))
        longPressRecognizer.delegate = self
        genreListTableView.addGestureRecognizer(longPressRecognizer)
        
        genreListTableView.delegate = self
        genreListTableView.dataSource = self
        
        navigationItem.title = "ジャンル"
        
        addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonTapped(_:)))
        editBarButtonItem = UIBarButtonItem(title: "編集", style: .done, target: self, action: #selector(editBarButtonTapped(_:)))
        navigationItem.rightBarButtonItems = [editBarButtonItem, addBarButtonItem]
        genreListTableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "tableViewCell")
    }
    
    // navigationBarの＋ボタンをタップしたら
    @objc func addBarButtonTapped(_ sender: UIBarButtonItem) {
        var alertTextField: UITextField?
        
        let alert = UIAlertController(title: "ジャンルタイトル", message: "Enter new name", preferredStyle: UIAlertController.Style.alert)
        alert.addTextField(configurationHandler: { (textField: UITextField!) in alertTextField = textField })
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { _ in
            self.cellNum += 1
            
            self.addNum()
            self.genreTitle = alertTextField?.text
            CookingGenreStore.shared.add(data: CookingGenreData(imageName: "empty" ,genreTitle: self.genreTitle!))
            try? CookingGenreStore.shared.save()
            self.saveNum()
            self.genreListTableView.reloadData()
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    // self.num[]を追加
    func addNum() {
        let sortNum = self.num.sorted()
        
        for i in 0 ..< sortNum.count {
            if i != sortNum[i] {
                self.num.append(i)
                return
            }
        }
        self.num.append(self.cellNum - 1)
    }
    
    // navigationBarの編集ボタンたっぷしたら
    @objc func editBarButtonTapped(_ sender: UIBarButtonItem) {
        if(genreListTableView.isEditing) {
            genreListTableView.setEditing(false, animated: true)
            editBarButtonItem.title = "編集"
            try? CookingGenreStore.shared.save()
        } else {
            genreListTableView.setEditing(true, animated: true)
            editBarButtonItem.title = "完了"
        }
    }
    
    // Cell長押ししたら
    @objc func cellLongPressed(recognizer: UILongPressGestureRecognizer) {
        let point = recognizer.location(in: genreListTableView)
        let indexPath = genreListTableView.indexPathForRow(at: point)
        
        var alertTextField: UITextField?
        
        let alert = UIAlertController(title: "タイトル変更", message: "Enter new name", preferredStyle: UIAlertController.Style.alert)
        alert.addTextField(configurationHandler: { (textField: UITextField!) in alertTextField = textField })
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { _ in
            let imageName = CookingGenreStore.shared.get(index: self.num[indexPath!.row])?.imageName
            CookingGenreStore.shared.overwriteSave(index: self.num[indexPath!.row], data: CookingGenreData(imageName: imageName, genreTitle: alertTextField!.text!))
            try? CookingGenreStore.shared.save()
            self.genreListTableView.reloadData()
            
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        genreListTableView.reloadData()
    }
    
    // self.num[]を読み込み
    func loadNum() {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let dataUrl = url.appendingPathComponent("numData.json")
        
        if
            let data = try? Data(contentsOf: dataUrl),
            let num = try? JSONDecoder().decode([Int].self, from: data) {
            self.num = num
        }
    }
    
    // self.num[]をセーブ
    func saveNum() {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let dataUrl = url.appendingPathComponent("numData.json")
        let data = try? JSONEncoder().encode(self.num)
        try? data!.write(to: dataUrl)
    }
    
    func removeData() {
    }
    
}

//
//// tableView関連
//extension CookingGenreListViewController: UITableViewDelegate, UITableViewDataSource {
//
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100
//    }
//
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            CookingGenreStore.shared.remove(indexPath.row)
//            CookingGenreStore.shared.removeFile(index: self.num[indexPath.row])
//            self.num.remove(at: indexPath.row)
//            self.saveNum()
//            self.cellNum -= 1
//            try? CookingGenreStore.shared.save()
//            genreListTableView.reloadData()
//        }
//    }
//
//    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        let num = self.num[sourceIndexPath.row]
//        self.num.remove(at: sourceIndexPath.row)
//        self.num.insert(num, at: destinationIndexPath.row)
//
//        CookingGenreStore.shared.move(from: sourceIndexPath.row, to: destinationIndexPath.row)
//        self.saveNum()
//        try? CookingGenreStore.shared.save()
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return cellNum
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let storyboard = UIStoryboard.init(name: "CookingList", bundle: nil)
//        let cookingListViewController = storyboard.instantiateViewController(identifier: "CookingListViewController") as! CookingListViewController
//        cookingListViewController.itemtitle = CookingGenreStore.shared.get(index: indexPath.row)?.genreTitle
//        cookingListViewController.index = self.num[indexPath.row]
//        navigationController?.pushViewController(cookingListViewController, animated: true)
//
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as! CookingGenreListCell
//        self.loadNum()
//
//        self.genreTitle = CookingGenreStore.shared.get(index: indexPath.row)?.genreTitle
//
//        setCellImage(index: indexPath.row)
//        if self.imageName != "empty" {
//            cell.genreImage.image = UIImage(contentsOfFile: self.imageName!)
//        } else {
//            cell.genreImage.image = UIImage(named: "empty")
//        }
//        cell.genreTitle.text = self.genreTitle
//
//        return cell
//    }
//
//    func setCellImage(index: Int) {
//
//        if CookingClassStore.shared.load(genreIndex: self.num[index] , listIndex: 0) {
//            self.imageName = CookingClassStore.shared.get()?.imageName
//        } else {
//            self.imageName = "empty"
//        }
//    }
//}
