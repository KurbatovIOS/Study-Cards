//
//  LearnCell.swift
//  LearningCards
//
//  Created by Kurbatov Artem on 21.08.2022.
//

import UIKit

class LearnCell: UITableViewCell {
    
    @IBOutlet weak var collectionLabel: UILabel!
    
    func setUpLabel(collectionToDisplay: Collection) {
        
        collectionLabel.text = collectionToDisplay.title
        collectionLabel.numberOfLines = 0
    }
    
}
