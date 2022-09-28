//
//  LearningCardVC.swift
//  LearningCards
//
//  Created by Kurbatov Artem on 25.08.2022.
//

import UIKit

class LearningCardVC: UIViewController {
    
    @IBOutlet weak var previousImageView: UIImageView!
    
    @IBOutlet weak var nextImageView: UIImageView!
    
    @IBOutlet weak var shuffleImageView: UIImageView!
    
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var cardLabel: UILabel!
    
    
    var collectionToDisplay: Collection?
    var currentCardIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = collectionToDisplay?.title
        
        previousImageView.tintColor = .gray
        
        cardView.layer.cornerRadius = 10.0
        
        // border
        cardView.layer.borderColor = UIColor.gray.cgColor
        cardView.layer.borderWidth = 1
        
        previousImageView.isUserInteractionEnabled = true
        shuffleImageView.isUserInteractionEnabled = true
        nextImageView.isUserInteractionEnabled = true
        
        
        let previousPressGesture = UITapGestureRecognizer(target: self, action: #selector(previousPress))
        let nextPressGesture = UITapGestureRecognizer(target: self, action: #selector(nextPress))
        let shufflePressGesture = UITapGestureRecognizer(target: self, action: #selector(shufflePress))
        
        previousImageView.addGestureRecognizer(previousPressGesture)
        shuffleImageView.addGestureRecognizer(shufflePressGesture)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        cardLabel.text = collectionToDisplay?.cards[0].front
        cardLabel.numberOfLines = 0
    }
    
    @objc func previousPress() {
        
        currentCardIndex += 1
        
       // if currentCardIndex < Coll
        
    }
    
    @objc func nextPress() {
        
        
    }
    
    @objc func shufflePress() {
        
        collectionToDisplay!.cards.shuffle()
        cardLabel.text = collectionToDisplay!.cards[currentCardIndex].front
    }
}
