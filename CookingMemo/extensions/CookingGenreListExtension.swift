//
//  CookingGenreListExtension.swift
//  CookingMemo
//
//  Created by take on 2021/02/23.
//

import UIKit

// tableView関連
extension CookingGenreListViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            CookingGenreStore.shared.remove(indexPath.row)
            CookingGenreStore.shared.removeFile(index: self.num[indexPath.row])
            self.num.remove(at: indexPath.row)
            self.saveNum()
            self.cellNum -= 1
            try? CookingGenreStore.shared.save()
            genreListTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let num = self.num[sourceIndexPath.row]
        self.num.remove(at: sourceIndexPath.row)
        self.num.insert(num, at: destinationIndexPath.row)

        CookingGenreStore.shared.move(from: sourceIndexPath.row, to: destinationIndexPath.row)
        self.saveNum()
        try? CookingGenreStore.shared.save()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellNum
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "CookingList", bundle: nil)
        let cookingListViewController = storyboard.instantiateViewController(identifier: "CookingListViewController") as! CookingListViewController
        cookingListViewController.itemtitle = CookingGenreStore.shared.get(index: indexPath.row)?.genreTitle
        cookingListViewController.index = self.num[indexPath.row]
        navigationController?.pushViewController(cookingListViewController, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as! CookingGenreListCell
        self.loadNum()
        
        self.genreTitle = CookingGenreStore.shared.get(index: indexPath.row)?.genreTitle
        
        setCellImage(index: indexPath.row)
        if self.imageName != "empty" {
            cell.genreImage.image = UIImage(contentsOfFile: self.imageName!)
        } else {
            cell.genreImage.image = UIImage(named: "empty")
        }
        cell.genreTitle.text = self.genreTitle
        
        return cell
    }
    
    func setCellImage(index: Int) {
        
        if CookingClassStore.shared.load(genreIndex: self.num[index] , listIndex: 0) {
            self.imageName = CookingClassStore.shared.get()?.imageName
        } else {
            self.imageName = "empty"
        }
    }
}
