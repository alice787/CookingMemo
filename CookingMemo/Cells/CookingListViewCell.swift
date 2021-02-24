//
//  CookingListViewCell.swift
//  CookingMemo
//
//  Created by take on 2021/02/07.
//

import UIKit

class CookingListViewCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var cookingTitle: UITextView!
 
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
