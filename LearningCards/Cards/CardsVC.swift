//
//  CardsVC.swift
//  LearningCards
//
//  Created by Kurbatov Artem on 16.08.2022.
//

import UIKit

class CardsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    var model = ContentModel()
    
    var collectionId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = ContentModel.collections[collectionId!].title
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.showsVerticalScrollIndicator = false
        tableView.allowsSelection = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if ContentModel.collections[collectionId!].cards.count > 0 {
            
            messageLabel.alpha = 0
        }
        else {
            messageLabel.alpha = 1
        }
    }
    
    //MARK: - Bar buttons
    //TODO: Make button remove all cards instead of collection itself
    @IBAction func removeButtonAction(_ sender: Any) {
        
        if self.collectionId != nil  && !ContentModel.collections[self.collectionId!].cards.isEmpty {
            
            let alert = UIAlertController(title: "Delete all cards?", message: "Are you sure you want to delete all cards?", preferredStyle: .alert)
            
            // Remove action
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                
                if self.collectionId != nil {
                    self.model.removeAllCards(collectionId: self.collectionId!)
                    self.messageLabel.alpha = 1
                    self.tableView.reloadData()
                }
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            present(alert, animated: true)
        }
    }
    
    
    @IBAction func addButtonAction(_ sender: Any) {
        
        guard collectionId != nil else {
            return
        }
        
        // TODO: Change message
        
        let alert = UIAlertController(title: "Creat a new card", message: "", preferredStyle: .alert)
        
        alert.addTextField { textField in
            
            textField.placeholder = "front"
            textField.keyboardType = .default
        }
        
        alert.addTextField { textField in
            
            textField.placeholder = "back"
            textField.keyboardType = .default
        }
        
        
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { action in
            
            // Get front and back titles
            let front = alert.textFields?[0].text
            let back = alert.textFields?[1].text
            
            guard front != nil && front?.trimmingCharacters(in: .whitespaces) != "" && back != nil && back?.trimmingCharacters(in: .whitespaces) != "" else {
                return
            }
            
            // Add the card to the collection
            self.model.addCard(collectionId: self.collectionId!, front: front!, back: back!)
                
            // Hide message if there is a card
            if ContentModel.collections[self.collectionId!].cards.count > 0 {
                self.messageLabel.alpha = 0
            }
                
            self.tableView.reloadData()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                
        present(alert, animated: true)
    }
}

// MARK: - TableView

extension CardsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return ContentModel.collections[collectionId ?? 0].cards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cardCell", for: indexPath) as! CardCell
        
        let card = ContentModel.collections[collectionId!].cards[indexPath.row]
        
        cell.setUpFrontLable(frontLabel: card.front)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let edit = UIContextualAction(style: .normal, title: "") { (action, view, success:(Bool) -> Void) in
            
            // TODO: move edit function into contentModel
            
            let cardId = indexPath.row
            
            if self.collectionId != nil {

                let alert = UIAlertController(title: "Edit card", message: nil, preferredStyle: .alert)
                
                
                alert.addTextField { textField in
                    
                    textField.text = ContentModel.collections[self.collectionId!].cards[cardId].front
                    textField.keyboardType = .default
                }
                
                alert.addTextField { textField in
                    
                    textField.text = ContentModel.collections[self.collectionId!].cards[cardId].back
                    textField.keyboardType = .default
                }
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .default))
                
                alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { _ in
                    
                    guard alert.textFields?[0].text != nil && alert.textFields?[1].text != nil else {
                        return
                    }
                    
                    ContentModel.collections[self.collectionId!].cards[cardId].front = alert.textFields![0].text!
                    ContentModel.collections[self.collectionId!].cards[cardId].back = alert.textFields![1].text!
                    
                    self.model.save()
                    self.tableView.reloadData()
                    
                }))
                
                self.present(alert, animated: true)
            }
            success(true)
        }
        
        edit.image = UIImage(systemName: "pencil")
        
        
        // TODO: move remove function into contentModel
        let remove = UIContextualAction(style: .destructive, title: "") { (action, view, success:(Bool) -> Void) in
            
            let cardId = indexPath.row
            
            if self.collectionId != nil {

                ContentModel.collections[self.collectionId!].cards.remove(at: cardId)
                
                self.model.save()
                self.tableView.reloadData()
                
                if ContentModel.collections[self.collectionId!].cards.count < 1 {
                    self.messageLabel.alpha = 1
                }
            }
            success(true)
        }

        remove.image = UIImage(systemName: "trash.fill")
        
        return UISwipeActionsConfiguration(actions: [remove, edit])
    }
}
