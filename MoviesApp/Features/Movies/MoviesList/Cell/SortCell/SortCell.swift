//
//  SortCell.swift
//  MoviesApp
//
//  Copyright © 2019 Gabriel. All rights reserved.
//

import UIKit

class SortCell: UICollectionViewCell {

    @IBOutlet var text: UILabel!
    
    override var isSelected: Bool{
        willSet{
            super.isSelected = newValue
            if newValue {
                text.backgroundColor = #colorLiteral(red: 0.4497107267, green: 0.7893311977, blue: 0.7869261503, alpha: 1)
            } else {
                text.backgroundColor = #colorLiteral(red: 0.9850550744, green: 0.9733064155, blue: 0.8824451708, alpha: 1)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        text.layer.cornerRadius = 25
        text.layer.shadowColor = UIColor.lightGray.cgColor
        text.layer.shadowRadius = 2
        text.backgroundColor = UIColor.lightGray
        text.clipsToBounds = true
    }
}
