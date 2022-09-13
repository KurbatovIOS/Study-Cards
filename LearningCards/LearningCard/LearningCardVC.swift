//
//  LearningCardVC.swift
//  LearningCards
//
//  Created by Kurbatov Artem on 25.08.2022.
//

import UIKit

class LearningCardVC: UIViewController {
    
    @IBOutlet weak var previousImageView: UIImageView!
    
    @IBOutlet weak var rightImageView: UIImageView!
    
    @IBOutlet weak var shuffleImageView: UIImageView!
    
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var cardLabel: UILabel!
    
    
    var collectionToDisplay: Collection?
    var currentCardIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = collectionToDisplay?.title
        
        previousImageView.tintColor = .gray
        shuffleImageView.tintColor = .gray
        
        cardView.layer.cornerRadius = 10.0
        
        // border
        cardView.layer.borderColor = UIColor.gray.cgColor
        cardView.layer.borderWidth = 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        cardLabel.text = collectionToDisplay?.cards[0].front
        cardLabel.numberOfLines = 0
    }
}
