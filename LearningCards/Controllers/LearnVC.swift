//
//  LearnVC.swift
//  LearningCards
//
//  Created by Kurbatov Artem on 21.08.2022.
//

import UIKit

class LearnVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    var collectionsWithCards: [Collection] = []
    var model = ContentModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.messageLabel.text = "You must have at least one non-empty collection to begin training"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        collectionsWithCards = []
        
        // Get not empty collections to show
        for index in 0..<ContentModel.collections.count {
            
            if ContentModel.collections[index].cards.count > 0 {
                collectionsWithCards.append(ContentModel.collections[index])
            }
        }
        
        if !collectionsWithCards.isEmpty {
            messageLabel.alpha = 0
        }
        else {
            messageLabel.alpha = 1
        }
        
        tableView.reloadData()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let learningCardVC = segue.destination as! LearningCardVC
        
        let indexPath = tableView.indexPathForSelectedRow
        
        if indexPath != nil {
            
            guard let index = model.getCollectionIndex(title: collectionsWithCards[indexPath!.row].title) else {
                return
            }
            
            learningCardVC.collectionIndex = index
        }
    }
}

extension LearnVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return collectionsWithCards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "collectionCell", for: indexPath) as! LearnCell
        
        cell.setUpLabel(collectionToDisplay: collectionsWithCards[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "startLearning", sender: self)
    }
}
