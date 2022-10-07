//
//  CardCell.swift
//  LearningCards
//
//  Created by Kurbatov Artem on 17.08.2022.
//

import UIKit

class CardCell: UITableViewCell {

    @IBOutlet weak var cardFrontLabel: UILabel!
    @IBOutlet weak var statusButton: UIButton!
    var isLearned = false
    
    func setUpFrontLable(frontLabel: String) {
        
        cardFrontLabel.text = frontLabel
    }
    
    
    @IBAction func statusButtonClicked(_ sender: Any) {
        
        isLearned.toggle()
        statusButton.tintColor = isLearned ? .systemGreen : .systemGray2
        
    }
}
