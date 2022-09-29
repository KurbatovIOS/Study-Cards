//
//  CardCell.swift
//  LearningCards
//
//  Created by Kurbatov Artem on 17.08.2022.
//

import UIKit

class CardCell: UITableViewCell {

    @IBOutlet weak var cardFrontLabel: UILabel!
    
    func setUpFrontLable(frontLabel: String) {
        
        cardFrontLabel.text = frontLabel
    }

}
