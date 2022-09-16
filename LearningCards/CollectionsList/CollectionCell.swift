//
//  CollectionCell.swift
//  LearningCards
//
//  Created by Kurbatov Artem on 07.08.2022.
//

import UIKit

class CollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var collectionLabel: UILabel!
    
    @IBOutlet weak var buttonLabel: UIButton!
    
    
    func setUpCell(collectionToDisplay: Collection) {
                
        collectionLabel.text = collectionToDisplay.title
        collectionLabel.numberOfLines = 0
        
        // border radius
        layer.cornerRadius = 10.0
        
        // border
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 1
    }
    
}
