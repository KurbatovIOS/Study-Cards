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
    
    var model = ContentModel()
    
    var card: Card?
    var collectionId: Int?
    
    var cardIndex: Int?
    
    func setUpFrontLable(frontLabel: String) {
        
        cardFrontLabel.text = frontLabel
        
        let front = card!.front
        let back = card!.back
        
        self.cardIndex = model.getCardIndex(collectionId: collectionId!, front: front, back: back)
        
        updateButton()
    }
    
    
    @IBAction func statusButtonClicked(_ sender: Any) {
        
        guard card != nil && collectionId != nil else { return }
        
        let front = card!.front
        let back = card!.back
        
        model.updateCardStatus(collectionId: collectionId!, front: front, back: back)
        
        updateButton()
    }
    
    func updateButton() {
        statusButton.tintColor = ContentModel.collections[collectionId!].cards[cardIndex!].isLearned ? .systemGreen : .systemGray2
    }
}
