//
//  CookingGenreListCell.swift
//  CookingMemo
//
//  Created by take on 2021/02/07.
//

import UIKit

class CookingGenreListCell: UITableViewCell {

    @IBOutlet weak var genreImage: UIImageView!
    @IBOutlet weak var genreTitle: UILabel!
    
    var imageNum: UInt = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

class CookingGenreListData: Codable {
    var imageNum: UInt
    var title: String
    
    init(num: UInt, title: String) {
        self.title = title
        self.imageNum = num
    }
}

class GenreList: Codable {
    var list = [CookingGenreListData]()
}
