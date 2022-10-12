//
//  LearningCardVC.swift
//  LearningCards
//
//  Created by Kurbatov Artem on 25.08.2022.
//

import UIKit
import AVFoundation

class LearningCardVC: UIViewController {
    
    @IBOutlet weak var previousImageView: UIImageView!
    @IBOutlet weak var nextImageView: UIImageView!
    @IBOutlet weak var shuffleImageView: UIImageView!
    
    @IBOutlet weak var statusImageView: UIImageView!
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var cardLabel: UILabel!
    
    var isFront: Bool = true
    var collectionToDisplay: Collection?
    var currentCardIndex: Int = 0
    var collectionIndex: Int?
    
    var model = ContentModel()
    
    var player: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard collectionIndex != nil else {
            print("No collection index")
            return
        }
        
        collectionToDisplay = ContentModel.collections[collectionIndex!]
        
        setUpView()
        addPressGestures()
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.popToRootViewController(animated: true)
    }
    
    func setUpView() {
        
        navigationItem.title = collectionToDisplay?.title
        
        // Customizing card
        cardView.layer.cornerRadius = 10.0
    
        // border
        cardView.layer.borderColor = UIColor.gray.cgColor
        cardView.layer.borderWidth = 1
        
        cardLabel.text = collectionToDisplay?.cards[currentCardIndex].front
        updateStatus()
        cardLabel.numberOfLines = 0
        
        currentCardIndex = 0
        
        previousImageView.tintColor = .gray

        if collectionToDisplay!.cards.count < 2 {
            nextImageView.tintColor = .gray
            shuffleImageView.tintColor = .gray
        }
    }
    
    func addPressGestures() {

        previousImageView.isUserInteractionEnabled = true
        shuffleImageView.isUserInteractionEnabled = true
        nextImageView.isUserInteractionEnabled = true
        statusImageView.isUserInteractionEnabled = true
        
        let previousPressGesture = UITapGestureRecognizer(target: self, action: #selector(previousPress))
        let nextPressGesture = UITapGestureRecognizer(target: self, action: #selector(nextPress))
        let shufflePressGesture = UITapGestureRecognizer(target: self, action: #selector(shufflePress))
        
        let cardPressGesture = UITapGestureRecognizer(target: self, action: #selector(flipCard))
        
        let cardDoubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(changeCardStatus))
        
        previousImageView.addGestureRecognizer(previousPressGesture)
        shuffleImageView.addGestureRecognizer(shufflePressGesture)
        nextImageView.addGestureRecognizer(nextPressGesture)
        cardView.addGestureRecognizer(cardPressGesture)
        statusImageView.addGestureRecognizer(cardDoubleTapGesture)
    }
    
    @objc func flipCard() {
        
        if isFront {
            // Flip a card to the back side
            cardLabel.text = collectionToDisplay!.cards[currentCardIndex].back
            UIView.transition(with: cardView, duration: 0.7, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        }
        else {
            //flip a card to the front side
            cardLabel.text = collectionToDisplay!.cards[currentCardIndex].front
            UIView.transition(with: cardView, duration: 0.7, options: .transitionFlipFromRight, animations: nil, completion: nil)
        }
        
        let path = Bundle.main.path(forResource: "cardFlip", ofType: "wav")
        let url = URL(fileURLWithPath: path!)
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        }
        catch {
            print("Player error")
        }
      
        isFront.toggle()
    }
    
    @objc func changeCardStatus() {
        
        guard collectionToDisplay != nil else { return }
        
        let front = collectionToDisplay!.cards[currentCardIndex].front
        let back = collectionToDisplay!.cards[currentCardIndex].back
        
        model.updateCardStatus(collectionId: collectionIndex!, front: front, back: back)
        updateStatus()
    }
    
    func updateStatus() {
        
        guard collectionIndex != nil && collectionToDisplay != nil else { return }
        
        let front = collectionToDisplay!.cards[currentCardIndex].front
        let back = collectionToDisplay!.cards[currentCardIndex].back
        
        let cardIndex = model.getCardIndex(collectionId: collectionIndex!, front: front, back: back)
        
        guard cardIndex != nil else { return }
        
        statusImageView.tintColor = ContentModel.collections[collectionIndex!].cards[cardIndex!].isLearned ? .systemGreen : .systemGray2
    }
    
    @objc func previousPress() {
        
        if currentCardIndex - 1 >= 0 {
            
            let path = Bundle.main.path(forResource: "next", ofType: "wav")
            let url = URL(fileURLWithPath: path!)
            
            do {
                player = try AVAudioPlayer(contentsOf: url)
                player?.play()
            }
            catch {
                print("Player error")
            }
            
            currentCardIndex -= 1
            
            UIView.animate(withDuration: 0.3) {
                self.cardView.frame = CGRect(x: 500, y: self.cardView.frame.origin.y, width: self.cardView.frame.width, height: self.cardView.frame.height)
            }
            
            cardLabel.text = collectionToDisplay!.cards[currentCardIndex].front
            updateStatus()
            
            if nextImageView.tintColor == .gray {
                nextImageView.tintColor = .systemBlue
            }
            
            if currentCardIndex == 0 {
                previousImageView.tintColor = .gray
            }
        }
    }
    
    @objc func nextPress() {
        
        if currentCardIndex + 1 < collectionToDisplay!.cards.count {
            
            let path = Bundle.main.path(forResource: "next", ofType: "wav")
            let url = URL(fileURLWithPath: path!)
            
            do {
                player = try AVAudioPlayer(contentsOf: url)
                player?.play()
            }
            catch {
                print("Player error")
            }
            
            currentCardIndex += 1
            
            UIView.animate(withDuration: 0.3) {
                self.cardView.frame = CGRect(x: -500, y: self.cardView.frame.origin.y, width: self.cardView.frame.width, height: self.cardView.frame.height)
            }
            
            cardLabel.text = collectionToDisplay!.cards[currentCardIndex].front
            updateStatus()
            
            if previousImageView.tintColor == .gray {
                previousImageView.tintColor = .systemBlue
            }
            
            if currentCardIndex == collectionToDisplay!.cards.count-1 {
                nextImageView.tintColor = .gray
            }
        }
    }
    
    @objc func shufflePress() {
        
        if collectionToDisplay!.cards.count > 1 {
            collectionToDisplay!.cards.shuffle()
            isFront = true
            self.cardView.alpha = 0
            
            UIView.animate(withDuration: 0.7) {
               
                self.cardView.alpha = 1
            }
            
            cardLabel.text = collectionToDisplay!.cards[currentCardIndex].front
            updateStatus()
        }
    }
}
